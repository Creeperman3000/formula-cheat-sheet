# CLI Tool

Entry point: `python formula` or `./formula`

## Usage

```
python formula <command> [options]
```

## Commands

### `init`
Initialize the database — runs `schema.sql`, `seed.sql`, `views.sql`, `seed_units.sql`, and `seed_formulas.sql`, then applies migrations and rebuilds FTS indexes.

```bash
python formula init [--db <path>]
```

### `list`
List all formulas with branch/topic.

```bash
python formula list [--branch <name>] [--topic <name>] [--difficulty <min-max>]
```

### `show <formula_id>`
Display a formula with its variables, description, conditions, and related formulas.

### `search <query>`
Full-text search across formula names, descriptions, quantities, and unit names/symbols.

```bash
python formula search "kinetic energy"
```

### `quantities`
List all quantities (optionally filtered by formula).

```bash
python formula quantities [--formula <id>]
```

### `quantity <quantity_id>`
Show quantity details including dimensions and compatible units.

### `units`
List all units with their symbols and conversion factors.

```bash
python formula units [--quantity <id>]
```

### `browse`
Interactive tree browser for exploring formulas by branch/topic.

### `export`
Export the entire database.

```bash
python formula export --format csv|csvdir|xlsx|ods [--output <path>]
```

### `import`
Import data from file or directory.

```bash
python formula import <file_or_directory>
```

## Options

| Flag | Description |
|------|-------------|
| `--db <path>` | Override database path |
| `--format <fmt>` | Export format (csv, csvdir, xlsx, ods) |
| `--output <path>` | Export output path |
| `--branch <name>` | Filter by branch |
| `--topic <name>` | Filter by topic |
| `--difficulty <range>` | Difficulty range: N or N-M |
| `--formula <id>` | Filter by formula ID |
| `--quantity <id>` | Filter by quantity ID |

Default database path: `~/.local/share/formula/formulas.db`, overridable via `FORMULA_DB` env var.
