# Scifind

A physics formula database with a CLI tool and web app.

## Quick Start

```bash
git clone <repo>
cd Scifind
pip install -r requirements.txt
python formula init       # initialize the database
python formula init --force  # wipe and re-initialise if it already exists
python formula list       # browse formulas
python webapp.py          # start web app at http://localhost:5000
```

## Project Structure

| Path | Purpose |
| ---- | ------- |
| `formula` | CLI entry point |
| `formula_lib.py` | Database, rendering, i18n, import/export |
| `webapp.py` | Flask web application |
| `schema.sql` | Database schema (6 tables, 3 FTS5 indexes) |
| `seed.sql` | Core seed data (formulas, quantities, units) |
| `seed_units.sql` | Additional SI and non-SI units |
| `seed_formulas.sql` | Extended formulas across sciences |
| `views.sql` | SQL views for common queries |
| `sciences.json` | Science/branch/topic tree with translations |
| `templates/` | Jinja2 templates |
| `wiki/` | Documentation |
| `requirements.txt` | Python dependencies |

## Docs

See the [wiki](wiki/Home.md) for detailed documentation on the CLI, web app, database schema, and development workflow.
