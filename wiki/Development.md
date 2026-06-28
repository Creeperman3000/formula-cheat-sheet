# Development

## Setup

```bash
git clone <repo>
cd Scifind
pip install -r requirements.txt
python formula init
```

The database is created at `~/.local/share/formula/formulas.db` (override with `--db` or `FORMULA_DB`).

## Running

**Web app:**
```bash
python webapp.py
```

**CLI:**
```bash
python formula list
python formula show kinetic_energy
python formula search "force"
```

## Tests

```bash
python3 -c "
from webapp import app
app.config['TESTING'] = True
with app.test_client() as c:
    for route in ['/formulas', '/quantities', '/formula/circle_area', '/quantity/area', '/search?q=circle']:
        r = c.get(route)
        print(f'{route}: {\"OK\" if r.status_code == 200 else \"FAIL\"} ({r.status_code})')
"
```

## I18n

All user-facing text fields (`name`, `description`, `label`, `symbol_overwrite`, `quantity_name_overwrite`) use JSON i18n:
```json
{"en-us": "...", "en-uk": "..."}
```

The `_resolve_i18n()` and `en()` functions handle both plain text and JSON, falling back to `en-us` if the requested locale isn't present. Plain text is deprecated; all seed data now uses JSON i18n format for these fields. Supported locales: `en-us`, `en-uk`.

## Adding a Formula

1. Insert a row into `formula` with a unique `id`, name, science/branch/topic, and difficulty.
2. Insert rows into `formula_item` for each variable — LHS items (`is_primary=1`) and RHS items (`is_primary=0`).
3. If the formula uses a quantity with the same dimensions as another (e.g., rotational energy uses `energy` with a subscript), set `label` (JSON i18n) and `quantity_name_overwrite` (JSON i18n) on the LHS item.
4. If the formula has assumptions, add `condition` rows linking to replacement formulas.
5. Link related formulas via `formula_relation`.
6. Rebuild FTS: `python formula init` or run `formula_lib.rebuild_fts()`.

## Adding Seed Data

Edit `seed.sql`, `seed_units.sql`, and/or `seed_formulas.sql`. Re-initialize with:
```bash
python formula init  # drops and recreates DB
```

## Export/Import

```bash
python formula export --format csv --output formulas.csv
python formula import formulas.csv
```

Supported formats: `csv`, `csvdir`, `xlsx`, `ods`.

## Edge Cases

- **LaTeX command-letter collision**: `\pir` → `\pi{}r`. The `_join_parts()` function inserts `{}` between a command and a following letter.
- **symbol_overwrite empty/null**: Falls back to the quantity's default symbol, then to the quantity ID.
- **label empty/null**: No subscript is rendered.
- **quantity_name_overwrite**: Overrides the displayed quantity name in formula detail views; falls back to quantity `name` if not set.
- **JSON i18n vs plain text**: All `label`, `symbol_overwrite`, `quantity_name_overwrite` fields in seed data use JSON i18n format. `_resolve_i18n()` handles both formats for backward compatibility.
- **sqlite3.Row vs dict**: Access columns by `item["col"]` using `or ""` fallback (works with both).
- **Missing locale key**: Falls back to `en-us` value in `_resolve_i18n()`.
- **Composite unit IDs**: Units with `_per_`, `square_`, `cubic_`, or `reciprocal_` prefixes are decomposed into base components for display.
