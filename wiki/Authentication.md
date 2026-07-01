# Authentication for `/import`

The `/import` endpoint overwrites the live database. As of the current codebase
it is **disabled unless `SCIFIND_IMPORT_TOKEN` is set**, in which case a static
shared secret is required. This document explains why that's not enough, and
lists better options ranked from simplest to most capable.

## Why a shared secret isn't enough

The token is a bearer credential. Anyone who learns it can replace the database.
Symptoms:

- Token leaks via shell history, logs, screenshots, or a careless git commit.
- Token can't be rotated without restarting the server.
- No audit trail: all imports look identical.
- No way to grant temporary or read-only access.

## Options

### 1. Public-key SSH-style auth (recommended for low-volume contributors)

Each contributor has an SSH keypair. They sign a timestamp + nonce with their
private key; the server verifies with the public key stored in a small JSON
file. No shared secret.

```
# ~/.config/scifind/importers.json
{
  "alice@example.com": "ssh-ed25519 AAAA...alice...",
  "bob@example.com":   "ssh-ed25519 AAAA...bob..."
}
```

Request:
```
POST /import
X-Import-Key: alice@example.com
X-Import-Signature: <base64 ed25519 signature over (timestamp || nonce || sha256(body))>
X-Import-Timestamp: 2026-06-29T12:34:56Z
```

Server checks: signature valid, timestamp within ±5 minutes, nonce not seen before.

Pros: each contributor has their own key, can be revoked individually, no shared secret to leak.
Cons: requires the `cryptography` or `PyNaCl` dep, ~80 lines of code.

### 2. Signed upload URLs (recommended for scheduled jobs)

The server has a long-lived admin secret. To grant a one-shot import, the admin
generates a signed URL containing an expiry and an action:

```
GET /admin/sign?action=import&expires=1730000000
Authorization: Bearer <admin-secret>
→ { "url": "/import?token=eyJ...&expires=1730000000" }
```

The signed token encodes `action=import`, the expiry, and an HMAC. Anyone with
the URL can import once before it expires.

Pros: no per-user state; URLs can be passed in CI pipelines or scheduler configs.
Cons: anyone who captures the URL can use it before expiry.

### 3. Reverse proxy auth (recommended for self-hosted LAN deployments)

Run the app behind nginx/Caddy/Traefik and put basic-auth or OIDC at the proxy.
The app doesn't see the credentials — it just trusts that authenticated users
exist.

```
# Caddy example
scifind.lan {
  basicauth {
    alice $2a$14$...
  }
  reverse_proxy 127.0.0.1:5000
}
```

For OIDC: use `auth_request` or `oauth2-proxy` in front of the app.

Pros: zero changes to the app; mature ecosystem; MFA possible.
Cons: requires a reverse proxy; doesn't help if the app is exposed directly.

### 4. Single-user password (simplest for solo use)

One password, hashed with `argon2` or `bcrypt`, stored in env var or config
file. Login returns a session cookie. UI gets a small `/login` page.

Pros: trivial, works for one user.
Cons: single credential, no audit trail.

### 5. WebAuthn / passkey (best for end-user-facing apps)

Browser-native auth via `py_webauthn`. No passwords to phish. Each user has a
passkey on their device.

Pros: phishing-resistant, no shared secrets.
Cons: significant implementation work (~200 lines), needs HTTPS, only useful
if many distinct users will import.

## Recommendation

| Deployment size | Pick |
|-----------------|------|
| Solo developer, local | 4 (password) — already done with token, upgrade later |
| Small team, LAN      | 3 (reverse proxy basic-auth) |
| Self-hosted, public | 1 (SSH-style) or 3 (OIDC at proxy) |
| Hosted SaaS          | 5 (WebAuthn) with per-user audit log |

All options should still keep the existing CSV/XLSX/ODS validation and the
upload size cap (`SCIFIND_MAX_UPLOAD_MB`).

## Audit logging

Regardless of auth choice, log every successful import:

```python
audit_log.info("import", extra={
    "user": user_id,
    "ip": request.remote_addr,
    "filename": file.filename,
    "size_bytes": len(raw),
    "tables": counts,
})
```

The current code already captures `counts` per table — just needs the metadata
wrapped around it.