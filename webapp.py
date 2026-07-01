#!/usr/bin/env python3
"""Scifind web app — Flask interface to the formula database."""

import html as html_module
import hmac
import io
import json
import logging
import os
import re
import secrets
import sqlite3
import sys
import tempfile
import zipfile
from dataclasses import dataclass, field
from pathlib import Path

from flask import Flask, render_template, request, g, Response, redirect, session, flash
from markupsafe import Markup

_PROJECT_DIR = Path(__file__).resolve().parent
if str(_PROJECT_DIR) not in sys.path:
    sys.path.insert(0, str(_PROJECT_DIR))

from scifind_lib import (
    open_database,
    database_path,
    render_formula_items,
    format_dimensions_latex,
    format_default_unit_html,
    format_default_unit_symbol,
    localise,
    fetch_formula,
    fetch_formula_items,
    fetch_formula_conditions,
    fetch_formula_related,
    fetch_formula_quantities,
    fetch_quantity,
    fetch_quantity_units,
    fetch_quantity_formulas_by_side,
    fetch_quantity_related_formulas,
    compute_formula_dimensions,
    compute_all_formula_dimensions,
    fetch_formulas_with_all_quantities,
    fetch_formulas_with_any_quantity,
    fetch_si_unit_symbol,
    fetch_unit,
    build_dimension_symbol_maps,
    fetch_all_quantities,
    fetch_all_formulas,
    search_database,
    rebuild_search_indexes,
    export_to_csv_directory,
    export_to_xlsx,
    export_to_ods,
    import_from_csv,
    import_from_csv_directory,
    import_from_xlsx,
    import_from_ods,
    DIMENSION_SYMBOLS,
)

app = Flask(__name__)
app.secret_key = os.environ.get("SCIFIND_SECRET_KEY") or secrets.token_hex(24)
app.config["MAX_CONTENT_LENGTH"] = (
    int(os.environ.get("SCIFIND_MAX_UPLOAD_MB", "32")) * 1024 * 1024
)

IMPORT_TOKEN = os.environ.get("SCIFIND_IMPORT_TOKEN", "")

MIN_DIFFICULTY = 0
MAX_DIFFICULTY = 10
SEARCH_QUERY_MAX_LENGTH = 200

logger = logging.getLogger("scifind")


# ---------------------------------------------------------------------------
# Filter parsing
# ---------------------------------------------------------------------------

@dataclass
class FilterState:
    ids: list = field(default_factory=list)
    ids_provided: bool = False
    exclude_all: bool = False
    quantity_ids: list = field(default_factory=list)
    quantity_mode: str = "and"
    diff_min: int = MIN_DIFFICULTY
    diff_max: int = MAX_DIFFICULTY
    dimension_filter: dict = field(default_factory=dict)
    base_quantity_only: int = 0

    @property
    def has_dimension_filter(self) -> bool:
        return any(d.get("val") is not None for d in self.dimension_filter.values())


def _safe_int(value, default=None):
    if value is None or value == "":
        return default
    try:
        return int(value)
    except (TypeError, ValueError):
        return default


def _csv_list(value):
    """Split a comma-separated query value into a list of stripped non-empty parts."""
    return [part.strip() for part in value.split(",") if part.strip()]


def parse_filter_state(args) -> FilterState:
    dimension_filter = {}
    for symbol in DIMENSION_SYMBOLS:
        op = args.get(f"{symbol}_o", "eq")
        if op not in ("eq", "gte", "lte"):
            op = "eq"
        dimension_filter[symbol] = {"op": op, "val": _safe_int(args.get(f"{symbol}_v"))}

    quantity_mode = args.get("qty_mode", "and")
    if quantity_mode not in ("and", "or"):
        quantity_mode = "and"

    ids_raw = args.get("ids")
    return FilterState(
        ids=_csv_list(ids_raw) if ids_raw is not None else [],
        ids_provided=ids_raw is not None,
        exclude_all=args.get("exclude_all") == "1",
        quantity_ids=_csv_list(args.get("qty", "")),
        quantity_mode=quantity_mode,
        diff_min=_safe_int(args.get("diff_min"), MIN_DIFFICULTY),
        diff_max=_safe_int(args.get("diff_max"), MAX_DIFFICULTY),
        dimension_filter=dimension_filter,
        base_quantity_only=_safe_int(args.get("is_dim"), 0) or 0,
    )


# ---------------------------------------------------------------------------
# Science tree helpers
# ---------------------------------------------------------------------------

SCIENCES_PATH = _PROJECT_DIR / "sciences.json"
_tree_cache = None


def _sciences_tree():
    global _tree_cache
    if _tree_cache is None:
        try:
            with open(SCIENCES_PATH) as f:
                _tree_cache = json.load(f).get("sciences", [])
        except (OSError, ValueError) as exc:
            logger.warning("Failed to load sciences.json: %s", exc)
            _tree_cache = []
    return _tree_cache


def _all_ids(tree):
    """Return every id anywhere in the sciences tree."""
    out = set()
    def walk(node):
        out.add(node["id"])
        for child in (node.get("children") or []):
            walk(child)
    for root in tree:
        walk(root)
    return out


def _leaf_ids(node):
    """Return every leaf id under a node (a leaf has no children)."""
    if not node.get("children"):
        return {node["id"]}
    leaves = set()
    for child in node["children"]:
        leaves |= _leaf_ids(child)
    return leaves


def _all_descendant_ids(node):
    """Return all descendant node ids including the node itself."""
    ids = {node["id"]}
    for child in (node.get("children") or []):
        ids |= _all_descendant_ids(child)
    return ids


def _expand_to_topics(tree, ids):
    """Expand a set of tree-level ids to all leaf ids they cover.

    Unknown ids in the input are silently dropped.
    """
    idset = set(ids)
    covered = set()

    def walk(node):
        nonlocal covered
        if node["id"] in idset:
            covered |= _all_descendant_ids(node)
            return
        for child in (node.get("children") or []):
            walk(child)

    for root in tree:
        walk(root)
    return covered


def _compress_selection(tree, ids):
    """Replace a set of leaf ids with the minimal ancestor covering set."""
    idset = set(ids)
    covered_leaves = set()

    def gather(node):
        nonlocal covered_leaves
        if node["id"] in idset:
            covered_leaves |= _leaf_ids(node)
            return
        for child in (node.get("children") or []):
            gather(child)

    for root in tree:
        gather(root)

    out = set()

    def collapse(node):
        nonlocal out
        leaves = _leaf_ids(node)
        if leaves <= covered_leaves:
            out.add(node["id"])
            return
        for child in (node.get("children") or []):
            collapse(child)

    for root in tree:
        collapse(root)
    return out


def _tree_name_map(tree, locale):
    """Flatten (id → localised name) using the current locale."""
    out = {}
    def walk(node):
        out[node["id"]] = localise(
            node.get("translations") or {}, locale, default=node["id"],
        )
        for child in (node.get("children") or []):
            walk(child)
    for root in tree:
        walk(root)
    return out


def _topic_path(tree, topic):
    """Return the ids along the path to a topic, or None if not in the tree."""
    def find(node, ancestors=()):
        if node["id"] == topic:
            return ancestors + (topic,)
        for child in (node.get("children") or []):
            result = find(child, ancestors + (node["id"],))
            if result:
                return result
    for root in tree:
        result = find(root)
        if result:
            return result
    return None


def _jstree_data(tree, name_map, compressed, exclude_all=False, ids_provided=False):
    """Build JSON for the sidebar's jsTree widget."""
    if not compressed and not exclude_all and not ids_provided:
        compressed = {r["id"] for r in tree} if tree else set()
    def conv(node):
        return {
            "id": node["id"],
            "text": name_map.get(node["id"], node["id"]),
            "state": {"checked": node["id"] in compressed, "opened": True},
            "children": [conv(c) for c in (node.get("children") or [])],
        }
    return [conv(r) for r in tree] if tree else []


def _attach_breadcrumbs(row, locale):
    """Add science/branch/subbranch/topic ids and names to a row."""
    tree = _sciences_tree()
    name_map = _tree_name_map(tree, locale)
    topic = row.get("topic_id") or row.get("topic")
    path = _topic_path(tree, topic)
    if path:
        levels = list(path) + [None] * (4 - len(path))
    else:
        levels = [None] * 4
    row["science_id"] = levels[0] or ""
    row["branch_id"] = levels[1] or ""
    row["subbranch_id"] = levels[2] or ""
    row["topic_id"] = levels[3] or topic or ""
    row["science"] = name_map.get(levels[0], "") if levels[0] else ""
    row["branch"] = name_map.get(levels[1], "") if levels[1] else ""
    row["subbranch"] = name_map.get(levels[2], "") if levels[2] else ""
    row["topic"] = name_map.get(levels[3] or topic, "") if (levels[3] or topic) else ""
    return row


def _filtered_ids_for_query(tree, ids):
    """Convert a set of tree-level ids into the full set of leaf topic ids."""
    valid = [i for i in ids if i in _all_ids(tree)]
    return _expand_to_topics(tree, valid)


# ---------------------------------------------------------------------------
# Heading text
# ---------------------------------------------------------------------------

SUPERSCRIPT_DIGITS = str.maketrans("0123456789-", "⁰¹²³⁴⁵⁶⁷⁸⁹⁻")

import unicodeit as _unicodeit

_LATEX_MATHCAL_RE = re.compile(r"\\(?:mathrm|text)\{([^}]*)\}")


def _latex_to_unicode(text):
    text = _LATEX_MATHCAL_RE.sub(r"\1", text)
    return _unicodeit.replace(text)


def _join_names(names):
    if not names:
        return ""
    if len(names) == 1:
        return names[0]
    if len(names) == 2:
        return f"{names[0]} and {names[1]}"
    return f"{', '.join(names[:-1])} and {names[-1]}"


def _heading_from_compressed(view_label, compressed, name_map, locale, fs,
                             dim_mode="dim", dimension_caches=None,
                             active_quantity_names=None):
    """Render the page heading from a compressed selection set."""
    parts = [view_label]
    tree = _sciences_tree()
    order = {}
    counter = [0]

    def index(node):
        order[node["id"]] = counter[0]
        counter[0] += 1
        for child in (node.get("children") or []):
            index(child)

    for root in tree:
        index(root)

    seen = set()
    names = []
    for nid in sorted(compressed, key=lambda x: order.get(x, 9 ** 9)):
        n = name_map.get(nid, nid)
        if n not in seen:
            names.append(n)
            seen.add(n)
    if names:
        parts.append(f"from {_join_names(names)}")

    dim_caches = dimension_caches or {}
    x_map = dim_caches.get("var" if dim_mode == "unit" else dim_mode, {})
    y_map = dim_caches.get("unit", {})

    op_syms = {"eq": "=", "gte": "\u2265", "lte": "\u2264"}

    extra = []
    for symbol in DIMENSION_SYMBOLS:
        d = fs.dimension_filter.get(symbol, {})
        value = d.get("val")
        if value is None:
            continue
        op = d.get("op", "eq")
        x_sym = _latex_to_unicode(x_map.get(symbol, symbol))
        y_sym = _latex_to_unicode(y_map.get(symbol, symbol))
        dv = str(value).translate(SUPERSCRIPT_DIGITS)
        extra.append(f"{x_sym} {op_syms[op]} {y_sym}{dv}")
    if active_quantity_names:
        extra.append(_join_names(active_quantity_names))
    if fs.diff_min > MIN_DIFFICULTY or fs.diff_max < MAX_DIFFICULTY:
        if fs.diff_min == fs.diff_max:
            extra.append(f"difficulty {fs.diff_min}")
        else:
            extra.append(f"difficulty {fs.diff_min}\u2013{fs.diff_max}")
    if extra:
        parts.append("with " + _join_names(extra))
    text = " ".join(parts)
    return text[0].upper() + text[1:] if text else f"All {view_label}"


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


# ---------------------------------------------------------------------------
# Database lifecycle
# ---------------------------------------------------------------------------

_NOT_INITIALISED = (
    "<h1>Database not initialised</h1>"
    "<p>The SQLite database at <code>{}</code> could not be opened or has no tables.</p>"
    "<p>Run <code>python scifind_cli.py init</code> to create and seed it, "
    "then refresh this page.</p>"
)


def _database_is_initialised(db):
    try:
        row = db.execute(
            "SELECT 1 FROM sqlite_master WHERE type='table' AND name='formula'"
        ).fetchone()
    except sqlite3.OperationalError:
        return False
    return bool(row)


def _bootstrap_database():
    """Apply schema and seed data on first run when the DB has no tables."""
    conn = open_database()
    try:
        if _database_is_initialised(conn):
            return
        conn.executescript((_PROJECT_DIR / "schema.sql").read_text(encoding="utf-8"))
        for seed in ("seed.sql", "seed_units.sql", "seed_formulas.sql"):
            conn.executescript((_PROJECT_DIR / seed).read_text(encoding="utf-8"))
        rebuild_search_indexes(conn)
        conn.commit()
        logger.info("Database initialised at %s", database_path())
    finally:
        conn.close()


# Run once at import time so a fresh clone just works.
_bootstrap_database()


def get_db():
    if "db" not in g:
        g.db = open_database()
    return g.db


@app.teardown_appcontext
def close_db(exc):
    db = g.pop("db", None)
    if db is not None:
        db.close()


@app.before_request
def ensure_db_open():
    if request.endpoint in (None, "static"):
        return
    try:
        db = get_db()
    except sqlite3.DatabaseError as exc:
        logger.warning("Database open failed: %s", exc)
        return _NOT_INITIALISED.format(
            os.environ.get("FORMULA_DB", "formulas.db")
        ), 503
    if not _database_is_initialised(db):
        return _NOT_INITIALISED.format(
            os.environ.get("FORMULA_DB", "formulas.db")
        ), 503


# ---------------------------------------------------------------------------
# Template globals
# ---------------------------------------------------------------------------

@app.template_global()
def locale_text(data):
    loc = g.locale if hasattr(g, "locale") else "en-us"
    return localise(data, loc)


def _unit_name_map(db, locale):
    """Build {unit_id: localised_name} from the current DB."""
    rows = db.execute("SELECT id, name FROM unit").fetchall()
    return {r["id"]: localise(r["name"], locale) for r in rows}


def _unit_symbol_map(db):
    """Build {unit_id: symbol} from the current DB."""
    rows = db.execute("SELECT id, symbol FROM unit").fetchall()
    return {r["id"]: r["symbol"] for r in rows}


@app.template_global()
def unit_name(unit_id):
    loc = g.locale if hasattr(g, "locale") else "en-us"
    db = g.db if "db" in g else get_db()
    names = _unit_name_map(db, loc)
    if unit_id in names:
        return Markup(f'<a href="/unit/{html_module.escape(unit_id)}">{html_module.escape(names[unit_id])}</a>')
    return Markup(html_module.escape(unit_id.replace("_", " ").title()))


@app.template_global()
def render_symbol(symbol):
    """Wrap a bare unit symbol in \\mathrm{}. Pass LaTeX strings through unchanged."""
    if not symbol:
        return ""
    s = symbol.strip()
    if not s or "\\" in s:
        return s
    return re.sub(r"[A-Za-z]+", lambda m: f"\\mathrm{{{m.group(0)}}}", s)


# ---------------------------------------------------------------------------
# Context processor
# ---------------------------------------------------------------------------

@app.context_processor
def inject_globals():
    locale = g.get("locale", "en-us")
    fs = parse_filter_state(request.args)
    tree = _sciences_tree()
    name_map = _tree_name_map(tree, locale)
    compressed = _compress_selection(tree, fs.ids)
    tree_json = _jstree_data(tree, name_map, compressed, fs.exclude_all, ids_provided=fs.ids_provided)
    path = request.path
    current_view = (
        "quantities"
        if path == "/quantities" or path.startswith("/quantity/") or path.startswith("/unit/")
        else "formulas"
    )

    all_quantities_for_filter = []
    dimension_caches = {"var": {}, "unit": {}, "dim": {}}
    db = None
    try:
        db = get_db()
    except sqlite3.OperationalError as exc:
        logger.warning("Database unavailable: %s", exc)
    if db is not None:
        try:
            for q in fetch_all_quantities(db):
                all_quantities_for_filter.append({
                    "id": q["id"],
                    "name": localise(q["name"], locale, default=q["id"]),
                    "symbol": q["symbol"] or "",
                })
        except sqlite3.OperationalError as exc:
            logger.warning("Quantity table unavailable: %s", exc)
        try:
            var_map, unit_map, dim_map = build_dimension_symbol_maps(db)
            dimension_caches = {"var": var_map, "unit": unit_map, "dim": dim_map}
        except sqlite3.OperationalError as exc:
            logger.warning("Dimension symbol lookup failed: %s", exc)

    dim_mode = g.get("dim_mode", "dim")
    dim_symbols = dimension_caches.get(dim_mode, dimension_caches.get("dim", {}))

    node_depth = {}
    def index_depth(nodes, depth=0):
        for node in nodes:
            node_depth[node["id"]] = depth
            index_depth(node.get("children") or [], depth + 1)
    index_depth(tree)

    return dict(
        tree=tree,
        tree_json=tree_json,
        active_science_ids=[i for i in compressed if node_depth.get(i) == 0],
        active_branch_ids=[i for i in compressed if node_depth.get(i) == 1],
        active_subbranch_ids=[i for i in compressed if node_depth.get(i) == 2],
        active_topic_ids=[i for i in compressed if node_depth.get(i) == 3],
        all_none=fs.exclude_all,
        diff_min=fs.diff_min,
        diff_max=fs.diff_max,
        current_view=current_view,
        dim_filter=fs.dimension_filter,
        active_qty_ids=fs.quantity_ids,
        all_quantities_for_filter=all_quantities_for_filter,
        dim_symbols=dim_symbols,
    )


# ---------------------------------------------------------------------------
# Pages
# ---------------------------------------------------------------------------

@app.route("/")
def index():
    return redirect("/formulas")


@app.route("/base-units")
def base_units_page():
    return redirect("/quantities?is_dim=1")


def _dimension_matches(row_dimensions, dimension_filter):
    """Check a row's dimension dict against the user's filter."""
    for symbol, df in dimension_filter.items():
        value = df["val"]
        if value is None:
            continue
        actual = row_dimensions.get(f"dim_{symbol}") or 0
        op = df["op"]
        if op == "eq" and actual != value:
            return False
        if op == "gte" and actual < value:
            return False
        if op == "lte" and actual > value:
            return False
    return True


@app.route("/formula/<formula_id>")
def formula_detail(formula_id):
    db = get_db()
    locale = g.locale
    row = fetch_formula(db, formula_id)
    if not row:
        return "Formula not found", 404
    row = dict(row)
    _attach_breadcrumbs(row, locale)
    items = fetch_formula_items(db, formula_id)
    latex = render_formula_items(items, locale=locale) if items else ""
    conditions = fetch_formula_conditions(db, formula_id)
    related = fetch_formula_related(db, formula_id)
    quantities = fetch_formula_quantities(db, formula_id)
    unit_names_map = _unit_name_map(db, locale)
    unit_symbols_map = _unit_symbol_map(db)

    parsed_quantities = []
    for q in quantities:
        q = dict(q)
        default_unit_html = format_default_unit_html(
            q["default_unit"],
            unit_url=lambda uid: f"/unit/{uid}",
            unit_name=lambda uid: unit_names_map.get(uid, uid.replace("_", " ").title()),
            locale=locale,
        )
        default_unit_symbol = format_default_unit_symbol(
            q["default_unit"],
            unit_symbol=lambda uid: render_symbol(unit_symbols_map.get(uid, uid)),
        )
        parsed_quantities.append(dict(
            q,
            default_unit_html=Markup(default_unit_html),
            default_unit_symbol_latex=default_unit_symbol,
        ))

    var_map, unit_map, dim_map = build_dimension_symbol_maps(db)
    dim_caches = {"var": var_map, "unit": unit_map, "dim": dim_map}
    dimensions = compute_formula_dimensions(db, formula_id)
    dim_latex = (
        format_dimensions_latex(
            *dimensions,
            variable_symbols=dim_caches["var"],
            unit_symbols=dim_caches["unit"],
            dimension_symbols=dim_caches["dim"],
            mode=g.get("dim_mode", "dim"),
        )
        if any(dimensions) else ""
    )
    return render_template(
        "formula.html",
        formula=row, latex=latex, conds=conditions,
        relations=related, quantities=parsed_quantities,
        dim_latex=dim_latex,
    )


@app.route("/quantity/<quantity_id>")
def quantity_detail(quantity_id):
    db = get_db()
    locale = g.locale
    q = fetch_quantity(db, quantity_id)
    if not q:
        return "Quantity not found", 404
    q = dict(q)
    _attach_breadcrumbs(q, locale)
    primary_formulas, non_primary_formulas = fetch_quantity_formulas_by_side(db, quantity_id)
    related_formulas = fetch_quantity_related_formulas(db, quantity_id)

    unit_names_map = _unit_name_map(db, locale)
    unit_symbols_map = _unit_symbol_map(db)
    default_unit_html = Markup(
        format_default_unit_html(
            q["default_unit"],
            unit_url=lambda uid: f"/unit/{uid}",
            unit_name=lambda uid: unit_names_map.get(uid, uid.replace("_", " ").title()),
            locale=locale,
        )
    ) if q.get("default_unit") else ""

    default_unit_symbol_latex = Markup(
        format_default_unit_symbol(
            q["default_unit"],
            unit_symbol=lambda uid: render_symbol(unit_symbols_map.get(uid, uid)),
        )
    ) if q.get("default_unit") else ""

    # Build units table: default_unit row + any non-composite units in the unit table
    units = []
    du_ids = set()
    if q.get("default_unit"):
        try:
            du = json.loads(q["default_unit"])
        except (json.JSONDecodeError, TypeError):
            du = []
        du_ids = {e["unit"] for e in du}
        unit_system = "SI"
        for e in du:
            row = db.execute(
                "SELECT unit_system FROM unit WHERE id = ?", (e["unit"],)
            ).fetchone()
            if row and row["unit_system"] != "SI":
                unit_system = row["unit_system"]
        units.append({
            "symbol_latex": default_unit_symbol_latex,
            "name_html": default_unit_html,
            "unit_system": unit_system,
            "factor": 1,
            "offset": 0,
        })

    extra_units = [dict(u) for u in fetch_quantity_units(db, quantity_id) if u["id"] not in du_ids]
    for eu in extra_units:
        units.append({
            "symbol_latex": Markup(render_symbol(eu["symbol"])),
            "name_html": unit_name(eu["id"]),
            "unit_system": eu.get("unit_system") or "any",
            "factor": eu.get("factor", 1),
            "offset": eu.get("offset", 0),
        })
    show_offset = any(u.get("offset", 0) != 0 for u in units)
    show_factor = any(u.get("factor", 1) != 1 for u in units)

    var_map, unit_map, dim_map = build_dimension_symbol_maps(db)
    dim_caches = {"var": var_map, "unit": unit_map, "dim": dim_map}
    quantity_dims = [
        q["dim_M"], q["dim_L"], q["dim_T"], q["dim_I"],
        q["dim_Θ"], q["dim_N"], q["dim_J"],
    ]
    dim_latex = (
        format_dimensions_latex(
            *quantity_dims,
            variable_symbols=dim_caches["var"],
            unit_symbols=dim_caches["unit"],
            dimension_symbols=dim_caches["dim"],
            mode=g.get("dim_mode", "dim"),
        )
        if any(quantity_dims) else ""
    )
    return render_template(
        "quantity.html",
        q=dict(q, default_unit_html=default_unit_html),
        units=units,
        primary_formulas=primary_formulas,
        nonprimary_formulas=non_primary_formulas,
        related_formulas=related_formulas,
        dim_latex=dim_latex,
        show_factor=show_factor,
        show_offset=show_offset,
    )


@app.route("/unit/<unit_id>")
def unit_detail(unit_id):
    db = get_db()
    unit = fetch_unit(db, unit_id)
    if not unit:
        return "Unit not found", 404
    unit = dict(unit)
    _attach_breadcrumbs(unit, g.locale)
    si_unit_symbol = fetch_si_unit_symbol(db, unit["quantity_id"])
    return render_template("unit.html", unit=unit, si_unit_symbol=si_unit_symbol)


@app.route("/search")
def search_page():
    query = request.args.get("q", "").strip()[:SEARCH_QUERY_MAX_LENGTH]
    if not query:
        return render_template("search.html", query="", results=[])
    results = search_database(get_db(), query)
    return render_template("search.html", query=query, results=results)


@app.route("/quantities")
def all_quantities():
    db = get_db()
    locale = g.locale
    fs = parse_filter_state(request.args)
    tree = _sciences_tree()

    if _compress_selection(tree, fs.ids) == {r["id"] for r in tree}:
        return redirect("/quantities")

    if fs.exclude_all or (fs.ids_provided and not fs.ids):
        return render_template(
            "quantities.html",
            quantities=[],
            heading="No quantities found matching the selected filters.",
        )

    raw_quantities = fetch_all_quantities(db)
    topic_filter = _filtered_ids_for_query(tree, fs.ids)
    unit_names_map = _unit_name_map(db, locale)
    unit_symbols_map = _unit_symbol_map(db)

    filtered = []
    for q in raw_quantities:
        q = dict(q)
        _attach_breadcrumbs(q, locale)

        if topic_filter and q.get("topic_id") not in topic_filter:
            continue
        if fs.has_dimension_filter and not _dimension_matches(q, fs.dimension_filter):
            continue
        if fs.quantity_ids and q["id"] not in fs.quantity_ids:
            continue
        if fs.base_quantity_only and not q.get("is_dim"):
            continue

        q["default_unit_html"] = Markup(
            format_default_unit_html(
                q["default_unit"],
                unit_url=lambda uid: f"/unit/{uid}",
                unit_name=lambda uid: unit_names_map.get(uid, uid.replace("_", " ").title()),
                locale=locale,
            )
        )
        q["default_unit_symbol_latex"] = format_default_unit_symbol(
            q["default_unit"],
            unit_symbol=lambda uid: render_symbol(unit_symbols_map.get(uid, uid)),
        )
        filtered.append(q)

    name_map = _tree_name_map(tree, locale)
    try:
        var_map, unit_map, dim_map = build_dimension_symbol_maps(db)
        dim_caches = {"var": var_map, "unit": unit_map, "dim": dim_map}
    except sqlite3.OperationalError:
        dim_caches = {"var": {}, "unit": {}, "dim": {}}
    heading = _heading_from_compressed(
        "Quantities", _compress_selection(tree, fs.ids), name_map, locale, fs,
        dim_mode=g.get("dim_mode", "dim"), dimension_caches=dim_caches,
    )
    if fs.base_quantity_only:
        heading = "Base quantities"
    return render_template("quantities.html", quantities=filtered, heading=heading)


@app.route("/formulas")
def all_formulas():
    db = get_db()
    locale = g.locale
    fs = parse_filter_state(request.args)
    tree = _sciences_tree()
    compressed = _compress_selection(tree, fs.ids)
    if compressed == {r["id"] for r in tree}:
        return redirect("/formulas")

    if fs.exclude_all or (fs.ids_provided and not fs.ids):
        return render_template(
            "formulas.html",
            formulas=[],
            heading="No formulas found matching the selected filters.",
        )

    formulas = [dict(f) for f in fetch_all_formulas(db)]
    topic_filter = _filtered_ids_for_query(tree, fs.ids)
    if topic_filter:
        formulas = [f for f in formulas if f.get("topic_id") in topic_filter]
    formulas = [
        f for f in formulas
        if fs.diff_min <= (f.get("difficulty") or 0) <= fs.diff_max
    ]

    if fs.has_dimension_filter:
        dim_map = compute_all_formula_dimensions(db)
        formulas = [
            f for f in formulas
            if _dimension_matches(dim_map.get(f["id"], {}), fs.dimension_filter)
        ]

    if fs.quantity_ids:
        quantity_match = (
            fetch_formulas_with_any_quantity
            if fs.quantity_mode == "or"
            else fetch_formulas_with_all_quantities
        )
        matching_ids = quantity_match(db, fs.quantity_ids)
        if matching_ids is not None:
            formulas = [f for f in formulas if f["id"] in matching_ids]

    for f in formulas:
        _attach_breadcrumbs(f, locale)
        items = fetch_formula_items(db, f["id"])
        f["latex"] = render_formula_items(items, locale=locale) if items else ""

    quantity_names = []
    if fs.quantity_ids:
        for q in fetch_all_quantities(db):
            if q["id"] in fs.quantity_ids:
                quantity_names.append(localise(q["name"], locale, default=q["id"]))

    name_map = _tree_name_map(tree, locale)
    try:
        var_map, unit_map, dim_map = build_dimension_symbol_maps(db)
        dim_caches = {"var": var_map, "unit": unit_map, "dim": dim_map}
    except sqlite3.OperationalError:
        dim_caches = {"var": {}, "unit": {}, "dim": {}}
    heading = _heading_from_compressed(
        "Formulas", compressed, name_map, locale, fs,
        dim_mode=g.get("dim_mode", "dim"), dimension_caches=dim_caches,
        active_quantity_names=quantity_names,
    )
    return render_template("formulas.html", formulas=formulas, heading=heading)


# ---------------------------------------------------------------------------
# Export
# ---------------------------------------------------------------------------

@app.route("/export")
def export():
    fmt = request.args.get("format", "csv")
    db = get_db()

    if fmt == "xlsx":
        buffer = io.BytesIO()
        export_to_xlsx(db, buffer)
        buffer.seek(0)
        return Response(
            buffer.getvalue(),
            mimetype="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            headers={"Content-Disposition": "attachment; filename=formulas.xlsx"},
        )

    if fmt == "ods":
        buffer = io.BytesIO()
        export_to_ods(db, buffer)
        buffer.seek(0)
        return Response(
            buffer.getvalue(),
            mimetype="application/vnd.oasis.opendocument.spreadsheet",
            headers={"Content-Disposition": "attachment; filename=formulas.ods"},
        )

    buffer = io.BytesIO()
    with zipfile.ZipFile(buffer, "w", zipfile.ZIP_DEFLATED) as zf:
        with tempfile.TemporaryDirectory() as tmp:
            export_to_csv_directory(db, tmp)
            for p in Path(tmp).iterdir():
                zf.write(p, p.name)
    buffer.seek(0)
    return Response(
        buffer.getvalue(),
        mimetype="application/zip",
        headers={"Content-Disposition": "attachment; filename=formulas_csv.zip"},
    )


# ---------------------------------------------------------------------------
# Import
# ---------------------------------------------------------------------------

def _is_within(base, target):
    """True if target is inside base (used for zip-slip protection)."""
    base = Path(base).resolve()
    target = Path(target).resolve()
    try:
        target.relative_to(base)
        return True
    except ValueError:
        return False


_ALLOWED_IMPORT_EXTENSIONS = (".csv", ".xlsx", ".ods", ".zip")


def _import_by_extension(db, ext, raw):
    """Dispatch an import based on file extension. Returns a counts dict."""
    if ext == ".csv":
        return import_from_csv(db, raw.decode("utf-8"))
    if ext == ".xlsx":
        return import_from_xlsx(db, io.BytesIO(raw))
    if ext == ".ods":
        return import_from_ods(db, io.BytesIO(raw))
    if ext == ".zip":
        with tempfile.TemporaryDirectory() as tmp:
            tmp_path = Path(tmp)
            with zipfile.ZipFile(io.BytesIO(raw)) as zf:
                for member in zf.infolist():
                    dest = (tmp_path / member.filename).resolve()
                    if not _is_within(tmp_path, dest):
                        raise ValueError(f"Refused unsafe path in zip: {member.filename}")
                zf.extractall(tmp_path)
            return import_from_csv_directory(db, str(tmp_path))
    raise ValueError(
        f"Unsupported file extension: {ext}. Use .csv, .zip, .xlsx, or .ods."
    )


@app.route("/import", methods=["POST"])
def import_file():
    if not IMPORT_TOKEN:
        return "Import endpoint is disabled (SCIFIND_IMPORT_TOKEN not set).", 403

    file = request.files.get("file")
    if not file or not file.filename:
        flash("No file selected.", "error")
        return redirect("/")

    provided = (
        request.headers.get("X-Import-Token", "")
        or request.form.get("import_token", "")
    )
    if not hmac.compare_digest(provided, IMPORT_TOKEN):
        return "Forbidden: missing or invalid import token.", 403

    ext = Path(file.filename).suffix.lower()
    if ext not in _ALLOWED_IMPORT_EXTENSIONS:
        flash(
            f"Unsupported file type '{ext}'. Allowed: {', '.join(_ALLOWED_IMPORT_EXTENSIONS)}",
            "error",
        )
        return redirect("/")

    raw = file.stream.read()
    db = get_db()
    try:
        counts = _import_by_extension(db, ext, raw)
        rebuild_search_indexes(db)
        parts = [f"{k}: {v}" for k, v in counts.items() if v > 0]
        if parts:
            flash(f"Imported {len(parts)} table(s): {', '.join(parts)}", "success")
        else:
            flash("No data imported.", "success")
    except Exception as exc:
        logger.exception("Import failed: %s", exc)
        flash(f"Import failed: {exc}", "error")
    return redirect("/")


if __name__ == "__main__":
    host = os.environ.get("SCIFIND_HOST", "127.0.0.1")
    port = int(os.environ.get("SCIFIND_PORT", "5000"))
    debug = os.environ.get("SCIFIND_DEBUG", "").lower() in ("1", "true", "yes")
    app.run(host=host, port=port, debug=debug)
