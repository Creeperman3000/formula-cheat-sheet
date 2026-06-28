#!/usr/bin/env python3
"""Flask webapp for Scifind — a structured physics formula database."""

import copy
import html
import io
import json
import os
import re
import sys
import tempfile
import zipfile
from pathlib import Path

from flask import Flask, render_template, request, g, Response, redirect, session, flash
from markupsafe import Markup

_project_dir = Path(__file__).resolve().parent
if str(_project_dir) not in sys.path:
    sys.path.insert(0, str(_project_dir))

from formula_lib import (
    get_conn, render_formula_items, render_dimensions_latex,
    render_default_unit_html, render_default_unit_symbol,
    render_unit_decomposition, is_composite_unit, get_dim_var_ids,
    get_formula_detail, get_formula_items,
    get_formula_conditions, get_formula_relations, get_formula_quantities,
    get_quantity_detail, get_quantity_units,
    get_quantity_formulas_split, get_formula_primary_dimensions,
    get_formula_dimension_map, get_formulas_containing_any_quantities, get_formulas_containing_all_quantities,
    get_si_unit_symbol, get_quantity_related_formulas,
    get_unit_detail, get_dimension_symbol_maps,
    get_all_quantities, get_all_formulas,
    search, migrate_db,
    export_csv_dir, export_xlsx, export_ods,
    import_csv, import_csv_dir, import_xlsx, import_ods, rebuild_fts,
    en as locale_en,
    load_sciences_tree, tl,
    DIM_ORDER,
)

app = Flask(__name__)
app.secret_key = os.urandom(24).hex()

_db_migrated = False

_dim_var_latex_map = None
_dim_unit_symbol_map = None
_dim_latex_map = None


def _ensure_dim_caches():
    """Initialize dimension caches keyed by dim_sym (M,L,T,I,Θ,N,J)."""
    global _dim_var_latex_map, _dim_unit_symbol_map, _dim_latex_map
    if _dim_var_latex_map is None:
        _dim_var_latex_map = {}
        _dim_unit_symbol_map = {}
        _dim_latex_map = {}
        db = get_db()
        for dim_sym, qid in get_dim_var_ids(db).items():
            # var mode from quantity.symbol
            row = db.execute("SELECT symbol, default_unit FROM quantity WHERE id=?", (qid,)).fetchone()
            if row:
                sym = row["symbol"]
                if sym.startswith("\\"):
                    _dim_var_latex_map[dim_sym] = sym
                else:
                    _dim_var_latex_map[dim_sym] = f"\\mathrm{{{sym}}}"
            # unit mode: parse default_unit JSON to find the first unit's symbol
            unit_sym = None
            if row and row["default_unit"]:
                try:
                    du = json.loads(row["default_unit"])
                    if isinstance(du, list) and du:
                        uid = du[0].get("unit", "")
                        if uid:
                            urow = db.execute("SELECT symbol FROM unit WHERE id=?", (uid,)).fetchone()
                            if urow:
                                unit_sym = urow["symbol"]
                except (ValueError, TypeError, IndexError):
                    pass
            if unit_sym:
                if not unit_sym.startswith("\\"):
                    unit_sym = f"\\mathrm{{{unit_sym}}}"
                _dim_unit_symbol_map[dim_sym] = unit_sym
            # dim mode from quantity.symbol_overwrite["dim"]
            ow = db.execute("SELECT symbol_overwrite FROM quantity WHERE id=?", (qid,)).fetchone()
            dim_sym_val = None
            if ow and ow["symbol_overwrite"]:
                try:
                    parsed = json.loads(ow["symbol_overwrite"])
                    dim_sym_val = parsed.get("dim")
                except (ValueError, TypeError):
                    pass
            if dim_sym_val:
                ds = dim_sym_val
                if not ds.startswith("\\"):
                    ds = f"\\mathrm{{{ds}}}"
                _dim_latex_map[dim_sym] = ds
            else:
                _dim_latex_map[dim_sym] = f"\\mathrm{{{dim_sym}}}"


# Sciences JSON cache
_sciences_tree_cache = None
def _get_sciences_tree():
    global _sciences_tree_cache
    if _sciences_tree_cache is None:
        try:
            _sciences_tree_cache = load_sciences_tree()
        except Exception:
            _sciences_tree_cache = []
    return _sciences_tree_cache


def _apply_locale(items, locale):
    """Apply locale to sciences tree items. Returns a new deep-copied tree."""
    result = copy.deepcopy(items)
    for item in result:
        item["_name"] = tl(item.get("translations", {}), locale)
        for child in item.get("children", []):
            child["_name"] = tl(child.get("translations", {}), locale)
            for sub in child.get("children", []):
                sub["_name"] = tl(sub.get("translations", {}), locale)
                if isinstance(sub, dict) and "children" in sub and sub["children"]:
                    for topic in sub["children"]:
                        topic["_name"] = tl(topic.get("translations", {}), locale)
    return result


def _get_science_ids_from_params(params_science):
    """Parse science param into list of IDs."""
    if not params_science or params_science == '_none_':
        return []
    return [s.strip() for s in params_science.split(",") if s.strip()]


def _join_names(names):
    if not names:
        return ""
    if len(names) == 1:
        return names[0]
    if len(names) == 2:
        return f"{names[0]} and {names[1]}"
    return f"{', '.join(names[:-1])} and {names[-1]}"


def _strip_latex(s):
    """Remove LaTeX markup for plain-text display, converting subscripts to unicode."""
    s = re.sub(r'\\[a-zA-Z]+\{([^}]*)\}', r'\1', s)
    SUB_MAP = str.maketrans({
        '0': '₀', '1': '₁', '2': '₂', '3': '₃', '4': '₄',
        '5': '₅', '6': '₆', '7': '₇', '8': '₈', '9': '₉',
        'a': 'ₐ', 'e': 'ₑ', 'h': 'ₕ', 'i': 'ᵢ', 'j': 'ⱼ',
        'k': 'ₖ', 'l': 'ₗ', 'm': 'ₘ', 'n': 'ₙ', 'o': 'ₒ',
        'p': 'ₚ', 'r': 'ᵣ', 's': 'ₛ', 't': 'ₜ', 'u': 'ᵤ',
        'v': 'ᵥ', 'x': 'ₓ',
    })
    def _sub_brace(m):
        inner = m.group(1)
        return inner.translate(SUB_MAP) if inner else ''
    def _sub_char(m):
        return m.group(1).translate(SUB_MAP)
    s = re.sub(r'_\{([^}]*)\}', _sub_brace, s)
    s = re.sub(r'_(\w)', _sub_char, s)
    return s


def _make_heading(view, science_ids, branch_ids, subbranch_ids, topic_ids,
                  diff_min, diff_max, locale, tree,
                  dim_filter=None, dim_symbol_map=None, dim_unit_symbol_map=None,
                  dim_var_symbol_map=None, active_qty_names=None,
                  force_var_left=False):
    """Generate page heading with all active filters."""
    view_label = view.capitalize()

    # Collect all named filter items (sciences, branches, subbranches, topics)
    filter_items = []
    seen = set()
    for sid in (science_ids or []):
        name = _get_science_name(sid, locale)
        if name and name not in seen:
            filter_items.append(name)
            seen.add(name)
    for s in tree:
        for b in s.get("children", []):
            bid = b["id"]
            if bid in (branch_ids or []) and bid not in seen:
                filter_items.append(tl(b.get("translations", {}), locale))
                seen.add(bid)
            for c in b.get("children", []):
                cid = c["id"]
                if isinstance(c, dict) and "children" in c and c["children"]:
                    if cid in (subbranch_ids or []) and cid not in seen:
                        filter_items.append(tl(c.get("translations", {}), locale))
                        seen.add(cid)
                    for t in c.get("children", []):
                        if t["id"] in (topic_ids or []) and t["id"] not in seen:
                            filter_items.append(tl(t.get("translations", {}), locale))
                            seen.add(t["id"])
                else:
                    if cid in (topic_ids or []) and cid not in seen:
                        filter_items.append(tl(c.get("translations", {}), locale))
                        seen.add(cid)

    parts = [view_label]

    if filter_items:
        parts.append(f"from {_join_names(filter_items)}")

    # Collect all non-tree filter descriptions
    extra_parts = []

    # Dimension info — add each dimension individually to extra_parts
    if dim_filter:
        _sup = str.maketrans('0123456789', '⁰¹²³⁴⁵⁶⁷⁸⁹')
        for dsym in DIM_ORDER:
            df = dim_filter.get(dsym, {})
            v = df.get("val")
            if v is not None and v != 0:
                left_map = (dim_var_symbol_map if force_var_left else dim_symbol_map) or {}
                var_sym = _strip_latex(left_map.get(dsym, dsym))
                unit_sym = _strip_latex((dim_unit_symbol_map or {}).get(dsym, dsym))
                exp_str = f"{'⁻' if v < 0 else ''}{str(abs(v)).translate(_sup)}"
                if dim_unit_symbol_map and unit_sym:
                    extra_parts.append(f"{var_sym} = {unit_sym}{exp_str}")
                else:
                    extra_parts.append(f"{var_sym}{exp_str}")

    # Quantity info
    if active_qty_names:
        extra_parts.append(_join_names(active_qty_names))

    # Difficulty info
    has_diff = diff_min > 0 or diff_max < 10
    if has_diff:
        if diff_min == diff_max:
            extra_parts.append(f"difficulty {diff_min}")
        else:
            extra_parts.append(f"difficulty {diff_min}\u2013{diff_max}")

    if extra_parts:
        parts.append("with " + _join_names(extra_parts))

    result = " ".join(parts)
    return result[0].upper() + result[1:] if result else f"All {view_label}"



def _get_science_name(science_id, locale):
    """Get localized science name from JSON tree."""
    tree = _get_sciences_tree()
    for s in tree:
        if s["id"] == science_id:
            return tl(s.get("translations", {}), locale)
    return science_id


def _get_branch_name(branch_id, locale="en-us"):
    """Get localized branch name from JSON tree by ID."""
    tree = _get_sciences_tree()
    for s in tree:
        for child in s.get("children", []):
            if child["id"] == branch_id:
                return tl(child.get("translations", {}), locale)
    return branch_id


def _get_topic_name(topic_id, locale="en-us"):
    """Get localized topic name from JSON tree by ID."""
    tree = _get_sciences_tree()
    for s in tree:
        for child in s.get("children", []):
            for c in child.get("children", []):
                if isinstance(c, dict) and "children" in c and c["children"]:
                    for topic in c["children"]:
                        if topic["id"] == topic_id:
                            return tl(topic.get("translations", {}), locale)
                else:
                    if c["id"] == topic_id:
                        return tl(c.get("translations", {}), locale)
    return topic_id


def _get_subbranch_name(subbranch_id, locale="en-us"):
    tree = _get_sciences_tree()
    for s in tree:
        for child in s.get("children", []):
            for sub in child.get("children", []):
                if sub["id"] == subbranch_id:
                    return tl(sub.get("translations", {}), locale)
    return subbranch_id


# ---------------------------------------------------------------------------
# Locale
# ---------------------------------------------------------------------------

@app.before_request
def detect_locale():
    locale = request.args.get("locale")
    if locale in ("en-us", "en-uk"):
        session["locale"] = locale
    if session.get("locale") in ("en-us", "en-uk"):
        g.locale = session["locale"]
    else:
        lang = request.headers.get("Accept-Language", "")[:5]
        g.locale = "en-uk" if lang.startswith("en-GB") else "en-us"

    dim_mode = request.args.get("dim_mode")
    if dim_mode in ("dim", "var", "unit"):
        session["dim_mode"] = dim_mode
    g.dim_mode = session.get("dim_mode", "dim")


@app.template_global()
def locale_text(data):
    if not data:
        return ""
    try:
        d = json.loads(data)
        val = d.get(g.locale) or d.get("en-us") or data
        return val
    except (json.JSONDecodeError, TypeError):
        return str(data)


def _l(row, locale, *fields):
    r = dict(row)
    if locale == "en-us":
        return r
    for f in fields:
        raw = r.get(f)
        if raw and isinstance(raw, str) and (raw.startswith("{") or raw.startswith('"')):
            r[f"{f}_en"] = locale_en(raw, locale)
    return r


def _unit_name_map(db, locale):
    cache_key = "_unit_names_" + locale
    if hasattr(g, cache_key):
        return getattr(g, cache_key)
    rows = db.execute("SELECT id, name FROM unit").fetchall()
    result = {r["id"]: locale_en(r["name"], locale) for r in rows}
    setattr(g, cache_key, result)
    return result


def _unit_symbol_map(db):
    cache_key = "_unit_symbols"
    if hasattr(g, cache_key):
        return getattr(g, cache_key)
    rows = db.execute("SELECT id, symbol FROM unit").fetchall()
    result = {r["id"]: r["symbol"] for r in rows}
    setattr(g, cache_key, result)
    return result


def get_db():
    global _db_migrated
    if "db" not in g:
        g.db = get_conn()
        if not _db_migrated:
            migrate_db(g.db)
            _db_migrated = True
    return g.db


@app.teardown_appcontext
def close_db(exc):
    db = g.pop("db", None)
    if db is not None:
        db.close()


# ---------------------------------------------------------------------------
# Template globals
# ---------------------------------------------------------------------------

@app.template_global()
def unit_name(unit_id):
    loc = g.locale if hasattr(g, "locale") else "en-us"
    names = _unit_name_map(g.db, loc) if "db" in g else _unit_name_map(get_db(), loc)
    if unit_id in names:
        return Markup(f'<a href="/unit/{html.escape(unit_id)}">{html.escape(names[unit_id])}</a>')
    return Markup(render_unit_decomposition(
        unit_id,
        name_func=lambda uid: names.get(uid, uid.replace("_", " ").title()),
        url_func=lambda uid: f"/unit/{uid}",
        locale=loc,
    ))


_SYMBOL_MATH = {
    "\\newton": "\\mathrm{N}", "\\ohm": "\\mathrm{\\Omega}",
    "\\degreeCelsius": "\\mathrm{^{\\circ}C}", "\\celsius": "\\mathrm{^{\\circ}C}",
    "\\meter": "\\mathrm{m}", "\\metre": "\\mathrm{m}",
    "\\kilogram": "\\mathrm{kg}", "\\kilogramme": "\\mathrm{kg}",
    "\\second": "\\mathrm{s}", "\\kelvin": "\\mathrm{K}",
    "\\gram": "\\mathrm{g}", "\\ampere": "\\mathrm{A}",
    "\\mole": "\\mathrm{mol}", "\\candela": "\\mathrm{cd}",
    "\\hertz": "\\mathrm{Hz}",
    "\\text{\\textdegree C}": "\\mathrm{^{\\circ}C}",
    "\\Omega": "\\mathrm{\\Omega}",
}


@app.template_global()
def render_symbol(symbol):
    if not symbol:
        return ""
    s = symbol.strip()
    if s in _SYMBOL_MATH:
        return _SYMBOL_MATH[s]
    if s.startswith("\\mathrm{") or s.startswith("\\") or s.startswith("{}"):
        return s
    return "\\mathrm{" + html.escape(s) + "}"


# ---------------------------------------------------------------------------
# Context processor
# ---------------------------------------------------------------------------

@app.context_processor
def inject_globals():
    locale = g.get("locale", "en-us")
    tree = _apply_locale(_get_sciences_tree(), locale)
    sciences_param = request.args.get("science", "")
    active_science_ids = _get_science_ids_from_params(sciences_param)
    branches_param = request.args.get("branch", "")
    active_branch_ids = branches_param.split(",") if branches_param else []
    subbranches_param = request.args.get("subbranch", "")
    active_subbranch_ids = subbranches_param.split(",") if subbranches_param else []
    topics_param = request.args.get("topic", "")
    active_topic_ids = topics_param.split(",") if topics_param else []
    diff_min = request.args.get("diff_min", 0, type=int)
    diff_max = request.args.get("diff_max", 10, type=int)
    path = request.path
    current_view = "quantities" if path in ("/quantities", "/base-units") or path.startswith("/quantity/") or path.startswith("/unit/") else "formulas"

    # Dimension filter state
    dim_filter = {}
    for dsym in DIM_ORDER:
        op = request.args.get(f"dim_{dsym}_op", "eq")
        val = request.args.get(f"dim_{dsym}_val", None, type=int)
        dim_filter[dsym] = {"op": op if op in ("eq", "gte", "lte") else "eq", "val": val}

    # Quantity filter state
    qty_param = request.args.get("qty", "")
    active_qty_ids = qty_param.split(",") if qty_param else []

    # Pass all quantities for the filter checkboxes
    all_quantities_for_filter = []
    try:
        db = get_db()
        raw_qs = get_all_quantities(db)
        for q in raw_qs:
            raw_name = q["name"]
            display_name = q["id"]
            if raw_name:
                if isinstance(raw_name, str) and raw_name.startswith("{"):
                    try:
                        parsed = json.loads(raw_name)
                        display_name = parsed.get(locale) or parsed.get("en-us") or q["id"]
                    except (ValueError, TypeError):
                        display_name = raw_name
                else:
                    display_name = raw_name
            all_quantities_for_filter.append({
                "id": q["id"],
                "name": display_name,
                "symbol": q["symbol"] if q["symbol"] else "",
            })
    except Exception:
        pass

    dim_var_map, dim_unit_map, dim_dim_map = get_dimension_symbol_maps(db)
    dim_mode = g.get("dim_mode", "dim")
    if dim_mode == "dim":
        dim_symbols = dim_dim_map
    elif dim_mode == "var":
        dim_symbols = dim_var_map
    else:
        dim_symbols = dim_unit_map

    return dict(
        tree=tree,
        active_science_ids=active_science_ids,
        active_branch_ids=active_branch_ids,
        active_subbranch_ids=active_subbranch_ids,
        active_topic_ids=active_topic_ids,
        diff_min=diff_min,
        diff_max=diff_max,
        current_view=current_view,
        all_none=(sciences_param == '_none_'),
        dim_filter=dim_filter,
        active_qty_ids=active_qty_ids,
        all_quantities_for_filter=all_quantities_for_filter,
        dim_symbols=dim_symbols,
    )


# ---------------------------------------------------------------------------
# Home
# ---------------------------------------------------------------------------

@app.route("/")
def index():
    return redirect("/formulas")


@app.route("/base-units")
def base_units_page():
    return redirect("/quantities?is_dim=1")


# ---------------------------------------------------------------------------
# Formula
# ---------------------------------------------------------------------------

@app.route("/formula/<formula_id>")
def formula_detail(formula_id):
    db = get_db()
    locale = g.locale
    row = get_formula_detail(db, formula_id)
    if not row:
        return "Formula not found", 404
    row = _l(row, locale, "name", "description")
    row["science"] = _get_science_name(row.get("science_id", ""), locale)
    row["branch"] = _get_branch_name(row.get("branch_id", ""), locale)
    row["subbranch"] = _get_subbranch_name(row.get("subbranch_id", ""), locale)
    row["topic"] = _get_topic_name(row.get("topic_id", ""), locale)
    items = get_formula_items(db, formula_id)
    latex = render_formula_items(items, locale=locale) if items else ""
    conds = get_formula_conditions(db, formula_id)
    relations = get_formula_relations(db, formula_id)
    quantities = get_formula_quantities(db, formula_id)
    unit_names = _unit_name_map(db, locale)
    unit_symbols = _unit_symbol_map(db)
    parsed_quantities = []
    for q in quantities:
        q = _l(q, locale, "name")
        si_html = render_default_unit_html(q["default_unit"],
                     unit_url_func=lambda uid: f"/unit/{uid}",
                     unit_name_func=lambda uid: unit_names.get(uid, uid.replace("_", " ").title()),
                     locale=locale)
        si_sym = render_default_unit_symbol(q["default_unit"],
                     unit_symbol_func=lambda uid: render_symbol(unit_symbols.get(uid, uid)))
        parsed_quantities.append(dict(q, default_unit_html=Markup(si_html), default_unit_symbol_latex=si_sym))
    _ensure_dim_caches()
    dims = get_formula_primary_dimensions(db, formula_id)
    dim_latex = render_dimensions_latex(*dims,
        var_latex_map=_dim_var_latex_map or {},
        unit_symbol_map=_dim_unit_symbol_map or {},
        dim_latex_map=_dim_latex_map or {},
        mode=g.get("dim_mode", "dim")) if any(dims) else ""
    return render_template(
        "formula.html",
        formula=row, latex=latex, conds=conds,
        relations=relations, quantities=parsed_quantities,
        dim_latex=dim_latex,
    )


# ---------------------------------------------------------------------------
# Quantity
# ---------------------------------------------------------------------------

@app.route("/quantity/<quantity_id>")
def quantity_detail(quantity_id):
    db = get_db()
    locale = g.locale
    q = get_quantity_detail(db, quantity_id)
    if not q:
        return "Quantity not found", 404
    q = _l(q, locale, "name", "description")
    q["science_id"] = q.get("science", "")
    q["branch_id"] = q.get("branch", "")
    q["subbranch_id"] = q.get("subbranch", "")
    q["topic_id"] = q.get("topic", "")
    q["science"] = _get_science_name(q["science_id"], locale)
    q["branch"] = _get_branch_name(q["branch_id"], locale)
    q["subbranch"] = _get_subbranch_name(q["subbranch_id"], locale)
    q["topic"] = _get_topic_name(q["topic_id"], locale)
    unit_names = _unit_name_map(db, locale)
    units = [_l(u, locale, "name") for u in get_quantity_units(db, quantity_id)]
    primary_f, nonprimary_f = get_quantity_formulas_split(db, quantity_id)
    related_f = get_quantity_related_formulas(db, quantity_id)

    show_offset = any(u.get("offset", 0) != 0 for u in units)

    si_row = db.execute(
        "SELECT symbol FROM unit WHERE quantity_id=? AND default_unit=1 LIMIT 1",
        (quantity_id,)
    ).fetchone()
    si_unit_symbol = si_row["symbol"] if si_row else "SI"

    _ensure_dim_caches()
    dim_latex = render_dimensions_latex(
        q["dim_M"], q["dim_L"], q["dim_T"], q["dim_I"], q["dim_Θ"], q["dim_N"], q["dim_J"],
        var_latex_map=_dim_var_latex_map or {},
        unit_symbol_map=_dim_unit_symbol_map or {},
        dim_latex_map=_dim_latex_map or {},
        mode=g.get("dim_mode", "dim")) if any([q["dim_M"], q["dim_L"], q["dim_T"], q["dim_I"], q["dim_Θ"], q["dim_N"], q["dim_J"]]) else ""
    return render_template(
        "quantity.html",
        q=q,
        units=units,
        primary_formulas=primary_f,
        nonprimary_formulas=nonprimary_f,
        related_formulas=related_f,
        si_unit_symbol=si_unit_symbol,
        show_offset=show_offset,
        dim_latex=dim_latex,
    )


# ---------------------------------------------------------------------------
# Unit
# ---------------------------------------------------------------------------

@app.route("/unit/<unit_id>")
def unit_detail(unit_id):
    db = get_db()
    u = get_unit_detail(db, unit_id)
    if not u:
        return "Unit not found", 404
    if is_composite_unit(unit_id):
        return redirect(f"/quantity/{u['quantity_id']}")
    u = _l(u, g.locale, "name")
    u["science"] = _get_science_name(u.get("science_id", ""), g.locale)
    u["branch"] = _get_branch_name(u.get("branch_id", ""), g.locale)
    u["subbranch"] = _get_subbranch_name(u.get("subbranch_id", ""), g.locale)
    u["topic"] = _get_topic_name(u.get("topic_id", ""), g.locale)
    si_unit_symbol = get_si_unit_symbol(db, u["quantity_id"])
    return render_template("unit.html", unit=u, si_unit_symbol=si_unit_symbol)


# ---------------------------------------------------------------------------
# Search
# ---------------------------------------------------------------------------

@app.route("/search")
def search_page():
    q = request.args.get("q", "")
    if not q:
        return render_template("search.html", query="", results=[])
    results = search(get_db(), q)
    return render_template("search.html", query=q, results=results)


# ---------------------------------------------------------------------------
# All Quantities
# ---------------------------------------------------------------------------

@app.route("/quantities")
def all_quantities():
    db = get_db()
    locale = g.locale
    unit_names = _unit_name_map(db, locale)
    unit_symbols = _unit_symbol_map(db)

    sciences_param = request.args.get("science", "")
    active_science_ids = _get_science_ids_from_params(sciences_param)
    diff_min = request.args.get("diff_min", 0, type=int)
    diff_max = request.args.get("diff_max", 10, type=int)
    branches_param = request.args.get("branch", "")
    active_branch_ids = branches_param.split(",") if branches_param else []
    subbranches_param = request.args.get("subbranch", "")
    active_subbranch_ids = subbranches_param.split(",") if subbranches_param else []
    topics_param = request.args.get("topic", "")
    active_topic_ids = topics_param.split(",") if topics_param else []

    # Dimension filter
    dim_filter = {}
    for dsym in DIM_ORDER:
        op = request.args.get(f"dim_{dsym}_op", "eq")
        val = request.args.get(f"dim_{dsym}_val", None, type=int)
        dim_filter[dsym] = {"op": op if op in ("eq", "gte", "lte") else "eq", "val": val}
    has_dim_filter = any(df["val"] is not None for df in dim_filter.values())

    is_dim = request.args.get("is_dim", 0, type=int)

    qty_param = request.args.get("qty", "")
    active_qty_ids = qty_param.split(",") if qty_param else []

    raw_quantities = get_all_quantities(db)

    filtered = []
    for q in raw_quantities:
        q = _l(q, locale, "name")

        if active_science_ids and q.get("science_id") not in active_science_ids:
            continue

        if active_branch_ids and q.get("branch_id") not in active_branch_ids:
            continue

        if active_subbranch_ids and q.get("subbranch_id") not in active_subbranch_ids:
            continue

        if active_topic_ids and q.get("topic_id") not in active_topic_ids:
            continue

        if has_dim_filter:
            def _q_dim_match(q):
                for dsym, df in dim_filter.items():
                    v = df["val"]
                    if v is None:
                        continue
                    col = f"dim_{dsym}"
                    actual = q.get(col, 0)
                    op = df["op"]
                    if op == "eq" and actual != v:
                        return False
                    elif op == "gte" and actual < v:
                        return False
                    elif op == "lte" and actual > v:
                        return False
                return True
            if not _q_dim_match(q):
                continue

        if active_qty_ids and q["id"] not in active_qty_ids:
            continue

        if is_dim and not q.get("is_dim"):
            continue

        # Apply locale to default_unit_name
        if q.get("default_unit_name"):
            dun = json.loads(q["default_unit_name"]) if isinstance(q["default_unit_name"], str) else {}
            q["default_unit_name"] = dun.get(locale, dun.get("en-us", q["default_unit_name"]))

        si_html = render_default_unit_html(q["default_unit"],
                     unit_url_func=lambda uid: f"/unit/{uid}",
                     unit_name_func=lambda uid: unit_names.get(uid, uid.replace("_", " ").title()),
                     locale=locale)
        si_sym = render_default_unit_symbol(q["default_unit"],
                     unit_symbol_func=lambda uid: render_symbol(unit_symbols.get(uid, uid)))
        q["default_unit_html"] = Markup(si_html)
        q["default_unit_symbol_latex"] = si_sym
        filtered.append(q)

    heading_dim_symbols, heading_dim_unit_symbols, heading_dim_dim_symbols = get_dimension_symbol_maps(db)
    dim_mode = g.get("dim_mode", "dim")
    if dim_mode == "dim":
        heading_dim_sym_map = heading_dim_dim_symbols
    elif dim_mode == "var":
        heading_dim_sym_map = heading_dim_symbols
    else:
        heading_dim_sym_map = heading_dim_unit_symbols
    heading = _make_heading("quantities", active_science_ids, active_branch_ids, active_subbranch_ids,
                             active_topic_ids, diff_min, diff_max, locale, _get_sciences_tree(),
                             dim_filter=dim_filter if has_dim_filter else None,
                             dim_symbol_map=heading_dim_sym_map,
                             dim_unit_symbol_map=heading_dim_unit_symbols,
                             dim_var_symbol_map=heading_dim_symbols,
                             force_var_left=(dim_mode == "unit"))
    if is_dim:
        heading = "Base quantities"
    return render_template("quantities.html", quantities=filtered, heading=heading)


# ---------------------------------------------------------------------------
# All Formulas
# ---------------------------------------------------------------------------

@app.route("/formulas")
def all_formulas():
    db = get_db()
    locale = g.locale

    sciences_param = request.args.get("science", "")
    active_science_ids = _get_science_ids_from_params(sciences_param)
    diff_min = request.args.get("diff_min", 0, type=int)
    diff_max = request.args.get("diff_max", 10, type=int)
    branches_param = request.args.get("branch", "")
    active_branch_ids = branches_param.split(",") if branches_param else []
    subbranches_param = request.args.get("subbranch", "")
    active_subbranch_ids = subbranches_param.split(",") if subbranches_param else []
    topics_param = request.args.get("topic", "")
    active_topic_ids = topics_param.split(",") if topics_param else []

    # Dimension filter params
    dim_filter = {}
    for dsym in DIM_ORDER:
        op = request.args.get(f"dim_{dsym}_op", "eq")
        val = request.args.get(f"dim_{dsym}_val", None, type=int)
        dim_filter[dsym] = {"op": op if op in ("eq", "gte", "lte") else "eq", "val": val}

    # Quantity filter params
    qty_param = request.args.get("qty", "")
    active_qty_ids = qty_param.split(",") if qty_param else []

    formulas = get_all_formulas(db)
    formulas = [_l(f, locale, "name") for f in formulas]

    # Filter by science (compare IDs directly)
    if active_science_ids:
        formulas = [f for f in formulas if f.get("science_id") in active_science_ids]

    # Filter by branch (compare IDs directly)
    if active_branch_ids:
        formulas = [f for f in formulas if f.get("branch_id") in active_branch_ids]

    # Filter by subbranch (compare IDs directly)
    if active_subbranch_ids:
        formulas = [f for f in formulas if f.get("subbranch_id") in active_subbranch_ids]

    # Filter by topic (compare IDs directly)
    if active_topic_ids:
        formulas = [f for f in formulas if f.get("topic_id") in active_topic_ids]

    # Filter by difficulty
    formulas = [f for f in formulas if diff_min <= (f.get("difficulty") or 0) <= diff_max]

    # Filter by dimension
    has_dim_filter = any(
        df["val"] is not None for df in dim_filter.values()
    )
    if has_dim_filter:
        dim_map = get_formula_dimension_map(db)
        def _dim_match(fid):
            dims = dim_map.get(fid, {})
            for dsym, df in dim_filter.items():
                v = df["val"]
                if v is None:
                    continue
                col = f"dim_{dsym}"
                actual = dims.get(col, 0)
                op = df["op"]
                if op == "eq" and actual != v:
                    return False
                elif op == "gte" and actual < v:
                    return False
                elif op == "lte" and actual > v:
                    return False
            return True
        formulas = [f for f in formulas if _dim_match(f["id"])]

    # Filter by quantity (formula must contain ALL selected quantities)
    if active_qty_ids:
        matching_ids = get_formulas_containing_all_quantities(db, active_qty_ids)
        if matching_ids is not None:
            formulas = [f for f in formulas if f["id"] in matching_ids]

    # Pre-compute LaTeX for each formula and set display names
    for f in formulas:
        f["science"] = _get_science_name(f.get("science_id", ""), locale)
        f["branch"] = _get_branch_name(f.get("branch_id", ""), locale)
        f["subbranch"] = _get_subbranch_name(f.get("subbranch_id", ""), locale)
        f["topic"] = _get_topic_name(f.get("topic_id", ""), locale)
        items = get_formula_items(db, f["id"])
        f["latex"] = render_formula_items(items, locale=locale) if items else ""

    # Quantity names for heading
    qty_names = []
    if active_qty_ids:
        all_q = get_all_quantities(db)
        for q in all_q:
            if q["id"] in active_qty_ids:
                n = q["name"]
                if isinstance(n, str):
                    try:
                        n = json.loads(n)
                    except Exception:
                        pass
                if isinstance(n, dict):
                    n = n.get(locale, n.get("en-us", q["id"]))
                elif not n:
                    n = q["id"]
                qty_names.append(n)
    heading_dim_symbols, heading_dim_unit_symbols, heading_dim_dim_symbols = get_dimension_symbol_maps(db)
    dim_mode = g.get("dim_mode", "dim")
    if dim_mode == "dim":
        heading_dim_sym_map = heading_dim_dim_symbols
    elif dim_mode == "var":
        heading_dim_sym_map = heading_dim_symbols
    else:
        heading_dim_sym_map = heading_dim_unit_symbols
    heading = _make_heading("formulas", active_science_ids, active_branch_ids, active_subbranch_ids,
                             active_topic_ids, diff_min, diff_max, locale, _get_sciences_tree(),
                             dim_filter=dim_filter if has_dim_filter else None,
                             dim_symbol_map=heading_dim_sym_map,
                             dim_unit_symbol_map=heading_dim_unit_symbols,
                             dim_var_symbol_map=heading_dim_symbols,
                             force_var_left=(dim_mode == "unit"),
                             active_qty_names=qty_names)
    return render_template("formulas.html", formulas=formulas, heading=heading)


# ---------------------------------------------------------------------------
# Export & Import
# ---------------------------------------------------------------------------

@app.route("/export")
def export():
    fmt = request.args.get("format", "csv")
    db = get_db()

    if fmt == "xlsx":
        buf = io.BytesIO()
        export_xlsx(db, buf)
        buf.seek(0)
        return Response(
            buf.getvalue(),
            mimetype="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            headers={"Content-Disposition": "attachment; filename=formulas.xlsx"},
        )

    if fmt == "ods":
        buf = io.BytesIO()
        export_ods(db, buf)
        buf.seek(0)
        return Response(
            buf.getvalue(),
            mimetype="application/vnd.oasis.opendocument.spreadsheet",
            headers={"Content-Disposition": "attachment; filename=formulas.ods"},
        )

    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w", zipfile.ZIP_DEFLATED) as zf:
        with tempfile.TemporaryDirectory() as tmp:
            export_csv_dir(db, tmp)
            for p in Path(tmp).iterdir():
                zf.write(p, p.name)
    buf.seek(0)
    return Response(
        buf.getvalue(),
        mimetype="application/zip",
        headers={"Content-Disposition": "attachment; filename=formulas_csv.zip"},
    )


def _safe_import(db, raw, ext, filename):
    """Try to import a file; return (success_bool, message)."""
    try:
        if ext == ".xlsx":
            buf = io.BytesIO(raw)
            counts = import_xlsx(db, buf)
        elif ext == ".ods":
            buf = io.BytesIO(raw)
            counts = import_ods(db, buf)
        elif ext == ".zip":
            with tempfile.TemporaryDirectory() as tmp:
                with zipfile.ZipFile(io.BytesIO(raw)) as zf:
                    zf.extractall(tmp)
                counts = import_csv_dir(db, tmp)
        elif ext == ".csv":
            csv_str = raw.decode("utf-8")
            counts = import_csv(db, csv_str)
        else:
            return False, f"Unsupported file extension: {ext}. Use .csv, .zip, .xlsx, or .ods."
        rebuild_fts(db)
        parts = [f"{k}: {v}" for k, v in counts.items() if v > 0]
        return True, f"Imported {len(parts)} table(s): {', '.join(parts)}" if parts else (True, "No data imported.")
    except Exception as e:
        return False, f"Import failed: {str(e)}"


@app.route("/import", methods=["POST"])
def import_file():
    file = request.files.get("file")
    if not file or file.filename == "":
        flash("No file selected.", "error")
        return redirect("/")

    filename = file.filename or ""
    ext = Path(filename).suffix.lower()
    raw = file.stream.read()

    if ext not in (".csv", ".xlsx", ".ods", ".zip"):
        flash(f"Unsupported file type '{ext}'. Allowed: .csv, .zip, .xlsx, .ods", "error")
        return redirect("/")

    db = get_db()
    ok, msg = _safe_import(db, raw, ext, filename)
    flash(msg, "success" if ok else "error")
    return redirect("/")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
