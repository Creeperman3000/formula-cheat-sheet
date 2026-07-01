#!/usr/bin/env python3
"""Scifind CLI — explore and manage the formula database from the terminal.

Usage:
    scifind_cli init                            Create and seed the database
    scifind_cli list [options]                  List formulas
    scifind_cli show <id>                       Show formula details
    scifind_cli search <query>                  Full-text search
    scifind_cli quantities [--formula F]        List quantities
    scifind_cli quantity <id>                   Show quantity details
    scifind_cli units [--quantity Q]            List units
    scifind_cli browse                          Browse branch/topic tree
    scifind_cli export [options]                Export all tables
    scifind_cli import <file>                   Import tables from file
"""

import argparse
import os
import sqlite3
import sys
import textwrap
from pathlib import Path

_PROJECT_DIR = Path(__file__).resolve().parent
if str(_PROJECT_DIR) not in sys.path:
    sys.path.insert(0, str(_PROJECT_DIR))

from scifind_lib import (
    database_path,
    open_database,
    rebuild_search_indexes,
    render_formula_items,
    format_dimensions_plain,
    extract_dimensions_from_row,
    parse_default_unit,
    difficulty_to_stars,
    localise_english,
    fetch_formula,
    fetch_formula_items,
    fetch_formula_conditions,
    fetch_formula_related,
    fetch_formula_quantities,
    fetch_quantity,
    fetch_quantity_units,
    fetch_quantity_formulas,
    search_database,
    export_to_csv,
    export_to_csv_directory,
    export_to_xlsx,
    export_to_ods,
    import_from_csv,
    import_from_csv_directory,
    import_from_xlsx,
    import_from_ods,
)


def _exit_with_error(message, code=1):
    print(f"error: {message}", file=sys.stderr)
    sys.exit(code)


_USE_COLOUR = sys.stdout.isatty()


def _bold(text):
    return f"\033[1m{text}\033[0m" if _USE_COLOUR else text


def _dim(text):
    return f"\033[2m{text}\033[0m" if _USE_COLOUR else text


def _yellow(text):
    return f"\033[33m{text}\033[0m" if _USE_COLOUR else text


def _cyan(text):
    return f"\033[36m{text}\033[0m" if _USE_COLOUR else text


# ---------------------------------------------------------------------------
# Commands
# ---------------------------------------------------------------------------

def command_init(args):
    schema_path = _PROJECT_DIR / "schema.sql"
    if schema_path.exists() and not args.force:
        existing = open_database()
        try:
            row = existing.execute(
                "SELECT count(*) AS c FROM sqlite_master WHERE type='table' AND name='formula'"
            ).fetchone()
        finally:
            existing.close()
        if row and row["c"]:
            _exit_with_error(
                "database already initialised. Pass --force to re-initialise "
                "(this will wipe existing data).",
                code=2,
            )

    conn = open_database()
    try:
        if args.force:
            conn.execute("PRAGMA foreign_keys = OFF")
            for table in (
                "formula_relation", "condition", "formula_item",
                "formula", "unit", "quantity",
            ):
                conn.execute(f"DROP TABLE IF EXISTS {table}")
            for fts in ("formula_fts", "quantity_fts", "unit_fts"):
                conn.execute(f"DROP TABLE IF EXISTS {fts}")
            conn.execute("PRAGMA foreign_keys = ON")

        conn.executescript(schema_path.read_text(encoding="utf-8"))
        conn.executescript((_PROJECT_DIR / "seed.sql").read_text(encoding="utf-8"))

        # seed_formulas.sql defines many quantities that seed_units.sql
        # references via FK constraints, so load formulas first.
        extra_seeds = [
            _PROJECT_DIR / "seed_formulas.sql",
            _PROJECT_DIR / "seed_units.sql",
        ]
        for seed_path in extra_seeds:
            if seed_path.exists():
                conn.executescript(seed_path.read_text(encoding="utf-8"))

        indexed_formula_count = rebuild_search_indexes(conn)
        change_count = conn.total_changes
    except (sqlite3.Error, OSError) as exc:
        try:
            conn.rollback()
        except sqlite3.Error:
            pass
        _exit_with_error(f"initialisation failed: {exc}")
    finally:
        conn.close()

    print(f"Database initialised at {database_path()}")
    print(f"  {change_count} SQL statements executed, {indexed_formula_count} formulas indexed for search.")


def command_list(args):
    conn = open_database()
    where_clauses = []
    params = []
    if args.topic:
        where_clauses.append("f.topic = ?")
        params.append(args.topic)

    if args.difficulty:
        parts = args.difficulty.split("-")
        if len(parts) == 1:
            where_clauses.append("f.difficulty = ?")
            params.append(int(parts[0]))
        else:
            where_clauses.append("f.difficulty BETWEEN ? AND ?")
            params.extend([int(parts[0]), int(parts[1])])

    sql = """
        SELECT f.id, json_extract(f.name, '$.en-us') AS name_en,
               f.topic AS topic_id, f.difficulty
        FROM formula f
    """
    if where_clauses:
        sql += " WHERE " + " AND ".join(where_clauses)
    sql += " ORDER BY f.topic, f.difficulty, f.id"

    rows = conn.execute(sql, params).fetchall()
    conn.close()
    if not rows:
        print("No formulas found.")
        return

    by_topic = {}
    for row in rows:
        topic = row["topic_id"] or "general"
        by_topic.setdefault(topic, []).append(row)

    for topic, topic_formulas in by_topic.items():
        print(f"\n  {_yellow(topic.replace('_', ' ').title())}:")
        for f in topic_formulas:
            stars = difficulty_to_stars(f["difficulty"])
            print(f"    {f['id']:40s} {stars}  {f['name_en']}")
    print()


def command_show(args):
    conn = open_database()
    row = fetch_formula(conn, args.id)
    if not row:
        print(f"Formula '{args.id}' not found.")
        sys.exit(1)
    items = fetch_formula_items(conn, args.id)
    conditions = fetch_formula_conditions(conn, args.id)
    related = fetch_formula_related(conn, args.id)
    quantities = fetch_formula_quantities(conn, args.id)
    conn.close()

    name = localise_english(row["name"])
    description = localise_english(row["description"])
    difficulty = row["difficulty"]
    topic = localise_english(row["topic"])
    stars = difficulty_to_stars(difficulty)

    print(f"\n  {_bold(name)}  {stars}")
    if topic:
        print(f"  {_cyan(topic)}  (difficulty {difficulty}/10)")

    if items:
        latex = render_formula_items(items)
        print(f"\n  $$")
        print(f"  {latex}")
        print(f"  $$")

    if description:
        wrapped = textwrap.fill(
            description, width=72,
            initial_indent="  ", subsequent_indent="  ",
        )
        print(f"\n  {_dim(wrapped)}")

    if conditions:
        print(f"\n  {_bold('Conditions:')}")
        for c in conditions:
            state = "\u2611" if c["default_on"] else "\u2610"
            print(f"    {state} {c['name_en']}  \u2192  {c['replacement_formula_id']}")

    if quantities:
        print(f"\n  {_bold('Quantities:')}")
        for q in quantities:
            print(f"    ${q['symbol']}$  {q['name_en']}  ({_dim(q['id'])})")

    if related:
        print(f"\n  {_bold('Related:')}")
        for r in related:
            print(f"    {_dim(r['relation_type'])} \u2192 {r['related_id']}  ({r['related_name']})")
    print()


def command_search(args):
    conn = open_database()
    rows = search_database(conn, args.query, args.limit or 20)
    conn.close()
    if not rows:
        print("No results.")
        return

    print(f"\n  {_bold(f'{len(rows)} result(s)')} for {_yellow(repr(args.query))}\n")
    for r in rows:
        stars = difficulty_to_stars(r["difficulty"]) if "difficulty" in r.keys() else ""
        name_en = r["name_en"] or ""
        extra = r["extra"] or ""
        kind = r["kind"]
        if kind == "formula":
            print(f"  {_cyan(kind):10s} {r['id']:40s} {stars}  {name_en}")
        else:
            print(f"  {_yellow(kind):10s} {r['id']:40s} {name_en} ($\\{extra}$)")
    print()


def command_quantities(args):
    conn = open_database()
    if args.formula:
        rows = fetch_formula_quantities(conn, args.formula)
    else:
        rows = conn.execute("""
            SELECT q.id, q.symbol, json_extract(q.name, '$.en-us') AS name_en,
                   q.default_unit,
                   q.dim_M, q.dim_L, q.dim_T, q.dim_I, q.dim_Θ, q.dim_N, q.dim_J
            FROM quantity q ORDER BY q.id
        """).fetchall()
    conn.close()
    if not rows:
        print("No quantities found.")
        return

    header = f"\n  {_bold('Quantities')}"
    if args.formula:
        header += f" for {_yellow(args.formula)}"
    print(header + "\n")

    for q in rows:
        dimensions = format_dimensions_plain(*extract_dimensions_from_row(q))
        unit_parts = parse_default_unit(q["default_unit"])
        unit_str = "\u00b7".join(f"{uid}^{exp}" for uid, exp in unit_parts) if unit_parts else ""
        print(f"  ${q['symbol']}$  {_bold(q['name_en'])}  ({_dim(q['id'])})")
        if unit_str:
            print(f"      Dimensions: {_dim(dimensions)}  default unit: {unit_str}")
        else:
            print(f"      Dimensions: {_dim(dimensions)}")
    print()


def command_quantity(args):
    conn = open_database()
    q = fetch_quantity(conn, args.id)
    if not q:
        print(f"Quantity '{args.id}' not found.")
        sys.exit(1)
    units = fetch_quantity_units(conn, args.id)
    formulas = fetch_quantity_formulas(conn, args.id)
    conn.close()

    name = localise_english(q["name"])
    description = localise_english(q["description"])
    dimensions = format_dimensions_plain(
        q["dim_M"], q["dim_L"], q["dim_T"], q["dim_I"],
        q["dim_Θ"], q["dim_N"], q["dim_J"],
    )
    unit_parts = parse_default_unit(q["default_unit"])
    unit_str = "\u00b7".join(f"{uid}^{exp}" for uid, exp in unit_parts) if unit_parts else ""

    label = f"${q['symbol']}$ \u2014 {name}"
    print(f"\n  {_bold(label)}  ({_dim(q['id'])})")
    if dimensions:
        print(f"  Dimensions: {_dim(dimensions)}")
    if unit_str:
        print(f"  Default unit: {unit_str}")

    if description:
        wrapped = textwrap.fill(
            description, width=72,
            initial_indent="  ", subsequent_indent="  ",
        )
        print(f"\n  {_dim(wrapped)}")

    if units:
        print(f"\n  {_bold('Units:')}")
        for u in units:
            mark = "\u2713" if u["default_unit"] else " "
            offset_str = f" + {u['offset']}" if u["offset"] else ""
            print(f"    [{mark}] ${u['symbol']}$  {u['id']}  [{u['unit_system'] or 'any'}]  \u00d7{u['factor']}{offset_str} \u2192 SI")

    if formulas:
        print(f"\n  {_bold('Appears in formulas:')}")
        for f in formulas:
            stars = difficulty_to_stars(f["difficulty"])
            print(f"    {f['id']:40s} {stars}  {f['name_en']}")
    print()


def command_units(args):
    conn = open_database()
    base_query = """
        SELECT u.*, json_extract(q.name, '$.en-us') AS quantity_name
        FROM unit u JOIN quantity q ON q.id = u.quantity_id
    """
    if args.quantity:
        rows = conn.execute(
            base_query + " WHERE u.quantity_id = ? ORDER BY u.default_unit DESC, u.unit_system",
            (args.quantity,),
        ).fetchall()
    else:
        rows = conn.execute(
            base_query + " ORDER BY q.id, u.default_unit DESC, u.unit_system"
        ).fetchall()
    conn.close()
    if not rows:
        print("No units found.")
        return

    header = f"\n  {_bold('Units')}"
    if args.quantity:
        header += f" for {_yellow(args.quantity)}"
    print(header + "\n")

    for u in rows:
        mark = "\u2713" if u["default_unit"] else " "
        offset_str = f" + {u['offset']}" if u["offset"] else ""
        print(f"  [{mark}] ${u['symbol']}$  {_bold(u['id'])}  [{u['unit_system'] or 'any'}]  \u00d7{u['factor']}{offset_str} \u2192 SI")
    print()


def command_browse(args):
    conn = open_database()
    rows = conn.execute("""
        SELECT f.id, json_extract(f.name, '$.en-us') AS name_en,
               f.topic AS topic_id, f.difficulty
        FROM formula f ORDER BY f.topic, f.difficulty, f.id
    """).fetchall()
    conn.close()

    tree = {}
    for row in rows:
        topic = row["topic_id"] or "general"
        tree.setdefault(topic, []).append(row)

    for topic, topic_formulas in tree.items():
        print(f"\n  {_yellow(topic.replace('_', ' ').title())}")
        for f in topic_formulas:
            stars = difficulty_to_stars(f["difficulty"])
            print(f"      {f['id']:38s} {stars}  {f['name_en']}")
    print()


def command_export(args):
    conn = open_database()
    fmt = (args.format or "csv").lower()

    if fmt == "csvdir":
        target = args.output or "."
        export_to_csv_directory(conn, target)
        print(f"Exported per-table CSV files to {target}/")
    elif fmt in ("xlsx", "ods"):
        output = args.output or f"formulas.{fmt}"
        if fmt == "xlsx":
            export_to_xlsx(conn, output)
        else:
            export_to_ods(conn, output)
        print(f"Exported to {output}")
    else:
        data = export_to_csv(conn)
        if args.output:
            Path(args.output).write_text(data, encoding="utf-8")
            print(f"Exported to {args.output}")
        else:
            sys.stdout.write(data)
    conn.close()


def command_import(args):
    conn = open_database()
    path = Path(args.file)
    ext = path.suffix.lower()

    if path.is_dir():
        counts = import_from_csv_directory(conn, str(path))
    elif ext == ".xlsx":
        counts = import_from_xlsx(conn, str(path))
    elif ext == ".ods":
        counts = import_from_ods(conn, str(path))
    else:
        data = path.read_text(encoding="utf-8") if args.file != "-" else sys.stdin.read()
        counts = import_from_csv(conn, data)

    rebuild_search_indexes(conn)
    conn.close()
    print("Imported:")
    for table, count in counts.items():
        print(f"  {table}: {count} rows")


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    default_database = database_path()
    parser = argparse.ArgumentParser(
        description="Scifind — structured physics formula database",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=textwrap.dedent("""
            Examples:
              scifind_cli init
              scifind_cli list --difficulty 1-3
              scifind_cli show newton_second_law_of_motion
              scifind_cli search "heat work"
              scifind_cli quantities
              scifind_cli quantity length
              scifind_cli units --quantity length
              scifind_cli export --output backup.csv
              scifind_cli export --format csvdir -o ./backup
              scifind_cli export --format xlsx -o formulas.xlsx
              scifind_cli export --format ods -o formulas.ods
              scifind_cli import backup.csv
              scifind_cli import ./backup
              scifind_cli import formulas.xlsx
        """),
    )
    parser.add_argument("--db", help=f"Database path (default: {default_database})")
    subcommands = parser.add_subparsers(dest="command", required=True)

    p_init = subcommands.add_parser("init", help="Create and seed the database")
    p_init.add_argument(
        "--force", action="store_true",
        help="Re-initialise even if database already exists (wipes existing data).",
    )

    p_list = subcommands.add_parser("list", help="List formulas")
    p_list.add_argument("--topic", "-t", help="Filter by topic")
    p_list.add_argument("--difficulty", "-d", help="Difficulty range: N or N-M")

    p_show = subcommands.add_parser("show", help="Show formula")
    p_show.add_argument("id", help="Formula ID")

    p_search = subcommands.add_parser("search", help="Full-text search")
    p_search.add_argument("query", help="Search terms")
    p_search.add_argument("--limit", "-l", type=int, default=20, help="Max results")

    p_quantities = subcommands.add_parser("quantities", help="List quantities")
    p_quantities.add_argument("--formula", help="Filter by formula ID")

    p_quantity = subcommands.add_parser("quantity", help="Show quantity details")
    p_quantity.add_argument("id", help="Quantity ID")

    p_units = subcommands.add_parser("units", help="List units")
    p_units.add_argument("--quantity", "-q", help="Filter by quantity ID")

    subcommands.add_parser("browse", help="Browse by branch/topic")

    p_export = subcommands.add_parser("export", help="Export all tables")
    p_export.add_argument(
        "--format", "-f", choices=["csv", "csvdir", "xlsx", "ods"],
        default="csv", help="Output format (default: csv)",
    )
    p_export.add_argument("--output", "-o", help="Output file or directory")

    p_import = subcommands.add_parser("import", help="Import tables from file or directory")
    p_import.add_argument("file", help="CSV/XLSX/ODS file or CSV directory")

    args = parser.parse_args()
    if args.db:
        os.environ["FORMULA_DB"] = args.db

    commands = {
        "init": command_init,
        "list": command_list,
        "show": command_show,
        "search": command_search,
        "quantities": command_quantities,
        "quantity": command_quantity,
        "units": command_units,
        "browse": command_browse,
        "export": command_export,
        "import": command_import,
    }
    try:
        commands[args.command](args)
    except sqlite3.Error as exc:
        _exit_with_error(f"database error: {exc}")
    except OSError as exc:
        _exit_with_error(f"file error: {exc}")
    except (KeyboardInterrupt, SystemExit):
        raise
    except Exception:
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
