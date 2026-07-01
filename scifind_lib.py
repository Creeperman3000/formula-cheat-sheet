"""Shared library for Scifind.

Database access, LaTeX rendering, dimension formatting, default unit parsing,
and CSV/XLSX/ODS export.
"""

import csv
import html
import json
import os
import sqlite3
from collections import defaultdict
from fractions import Fraction
from io import StringIO
from pathlib import Path


DEFAULT_DATABASE_PATH = str(Path(__file__).resolve().parent / "formulas.db")

DIMENSION_SYMBOLS = ["M", "L", "T", "I", "Θ", "N", "J"]
DIMENSION_COLUMNS = ["dim_M", "dim_L", "dim_T", "dim_I", "dim_Θ", "dim_N", "dim_J"]


# ---------------------------------------------------------------------------
# Locale helpers
# ---------------------------------------------------------------------------

def localise(value, locale, default="en-us"):
    """Resolve a value that may be a JSON i18n string, a dict, or plain text.

    Returns the localised string, falling back to ``default`` and finally to
    the raw value if neither key is present.
    """
    if not value:
        return ""
    if isinstance(value, dict):
        return value.get(locale) or value.get(default) or ""
    s = value.strip()
    if s.startswith("{"):
        try:
            d = json.loads(s)
            if isinstance(d, dict):
                return d.get(locale) or d.get(default) or s
            return s
        except (json.JSONDecodeError, TypeError):
            return s
    return s


def localise_english(value):
    return localise(value, "en-us")


# ---------------------------------------------------------------------------
# Database connection
# ---------------------------------------------------------------------------

def database_path():
    return os.environ.get("FORMULA_DB", DEFAULT_DATABASE_PATH)


def open_database():
    path = database_path()
    parent = os.path.dirname(path)
    if parent:
        os.makedirs(parent, exist_ok=True)
    conn = sqlite3.connect(path)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON")
    conn.execute("PRAGMA journal_mode = WAL")
    conn.execute("PRAGMA busy_timeout = 5000")
    conn.execute("PRAGMA synchronous = NORMAL")
    return conn


def rebuild_search_indexes(conn):
    """Rebuild FTS5 indexes from the source tables in a single transaction."""
    conn.execute("BEGIN")
    try:
        conn.execute("DELETE FROM formula_fts")
        formula_rows = conn.execute("""
            SELECT f.id, f.name, f.description,
                   COALESCE(group_concat(q.name_en, ' '), '') AS vars
            FROM formula f
            LEFT JOIN formula_item fi ON fi.formula_id = f.id
            LEFT JOIN (
                SELECT DISTINCT id, json_extract(name, '$.en-us') AS name_en FROM quantity
            ) q ON q.id = fi.quantity_id
            GROUP BY f.id
        """).fetchall()
        for r in formula_rows:
            conn.execute(
                "INSERT INTO formula_fts (formula_id, name, description, quantities) VALUES (?, ?, ?, ?)",
                (r["id"], r["name"], r["description"], r["vars"]),
            )

        conn.execute("DELETE FROM quantity_fts")
        for r in conn.execute("""
            SELECT id, json_extract(name, '$.en-us') AS name_en, symbol FROM quantity
        """):
            conn.execute(
                "INSERT INTO quantity_fts (quantity_id, name, symbol) VALUES (?, ?, ?)",
                (r["id"], r["name_en"], r["symbol"]),
            )

        conn.execute("DELETE FROM unit_fts")
        for r in conn.execute("""
            SELECT id, json_extract(name, '$.en-us') AS name_en, symbol FROM unit
        """):
            conn.execute(
                "INSERT INTO unit_fts (unit_id, name, symbol) VALUES (?, ?, ?)",
                (r["id"], r["name_en"], r["symbol"]),
            )

        conn.commit()
    except Exception:
        conn.rollback()
        raise
    return len(formula_rows)


# ---------------------------------------------------------------------------
# Number formatting
# ---------------------------------------------------------------------------

def format_number(n):
    if n == int(n):
        return str(int(n))
    s = f"{n:.10f}".rstrip("0")
    return s.rstrip(".")


# ---------------------------------------------------------------------------
# Dimensions
# ---------------------------------------------------------------------------

def dimension_quantity_ids(conn):
    """Build {dim_symbol: quantity_id} from base SI quantities.

    Each dimension column is matched independently so a data error like two
    quantities with dim_M=1 doesn't collide.
    """
    result = {}
    for symbol, column in zip(DIMENSION_SYMBOLS, DIMENSION_COLUMNS):
        row = conn.execute(
            f"SELECT id FROM quantity WHERE is_dim = 1 AND {column} != 0 LIMIT 1"
        ).fetchone()
        if row:
            result[symbol] = row["id"]
    return result


def format_dimensions_plain(
    dim_M=0, dim_L=0, dim_T=0, dim_I=0, dim_Θ=0, dim_N=0, dim_J=0,
):
    """Render dimension exponents as a human-readable string like M·L²·T⁻¹."""
    values = [dim_M, dim_L, dim_T, dim_I, dim_Θ, dim_N, dim_J]
    parts = []
    for symbol, exponent in zip(DIMENSION_SYMBOLS, values):
        if exponent is None:
            exponent = 0
        if exponent == 0:
            continue
        part = symbol if exponent == 1 else f"{symbol}^{format_number(exponent)}"
        parts.append(part)
    return " · ".join(parts) if parts else "dimensionless"


def format_dimensions_latex(
    dim_M=0, dim_L=0, dim_T=0, dim_I=0, dim_Θ=0, dim_N=0, dim_J=0,
    variable_symbols=None, unit_symbols=None, dimension_symbols=None, mode="var",
):
    """Render dimension exponents as LaTeX.

    variable_symbols: {M/L/T/I/Θ/N/J: quantity-symbol LaTeX}
    unit_symbols:     {M/L/T/I/Θ/N/J: unit-symbol LaTeX}
    dimension_symbols:{M/L/T/I/Θ/N/J: dimension-symbol LaTeX}
    mode: "dim", "var" (default), or "unit"
    """
    values = [dim_M, dim_L, dim_T, dim_I, dim_Θ, dim_N, dim_J]
    if mode == "dim" and dimension_symbols:
        lookup = dimension_symbols
    elif mode == "var" and variable_symbols:
        lookup = variable_symbols
    else:
        lookup = unit_symbols
    parts = []
    for symbol, exponent in zip(DIMENSION_SYMBOLS, values):
        if not exponent:
            continue
        sym = lookup.get(symbol) if lookup else None
        if sym is None:
            sym = symbol
        if exponent == 1:
            parts.append(sym)
        else:
            e = str(int(exponent)) if exponent == int(exponent) else str(exponent)
            parts.append(f"{sym}^{{{e}}}")
    if not parts:
        return "\\text{dimensionless}"
    return " \\cdot ".join(parts)


def extract_dimensions_from_row(row):
    """Return the seven dimension values from a row (dict or sqlite3.Row)."""
    return [row[c] or 0 if c in row.keys() else 0 for c in DIMENSION_COLUMNS]


# ---------------------------------------------------------------------------
# Default unit
# ---------------------------------------------------------------------------

def parse_default_unit(json_text):
    """Parse default_unit JSON and return [(unit_id, exponent)]."""
    if not json_text:
        return []
    try:
        parts = json.loads(json_text)
        return [(p["unit"], p["exponent"]) for p in parts]
    except (json.JSONDecodeError, KeyError, TypeError):
        return []


def expand_default_unit(json_text):
    """Parse default_unit JSON and return [(unit_id, exponent)]."""
    return parse_default_unit(json_text)


def split_numerator_denominator(parts):
    numerators, denominators = [], []
    for unit_id, exponent in parts:
        if exponent >= 0:
            numerators.append((unit_id, exponent))
        else:
            denominators.append((unit_id, -exponent))
    return numerators, denominators


def format_default_unit_html(
    json_text, unit_url=None, unit_name=None, locale="en-us",
):
    """Render default_unit JSON as HTML with optional unit links."""
    parts = expand_default_unit(json_text)
    if not parts:
        return ""
    words = locale_words(locale)
    numerators, denominators = split_numerator_denominator(parts)
    num_html = render_unit_group(numerators, unit_url, unit_name, locale)
    if not denominators:
        return num_html
    den_html = render_unit_group(denominators, unit_url, unit_name, locale)
    if not num_html:
        return f"{words['reciprocal']} {den_html}"
    return f"{num_html} {words['per']} {den_html}"


def format_default_unit_symbol(json_text, unit_symbol=None):
    """Render default_unit JSON as a LaTeX symbol expression."""
    parts = expand_default_unit(json_text)
    if not parts:
        return ""
    numerators, denominators = split_numerator_denominator(parts)

    def render(parts_):
        items = []
        for unit_id, exponent in parts_:
            sym = unit_symbol(unit_id) if unit_symbol else unit_id
            items.append(sym if exponent == 1 else f"{sym}^{{{int(exponent)}}}")
        return " \\cdot ".join(items) if items else ""

    num_str = render(numerators)
    den_str = render(denominators)
    if not den_str:
        return num_str
    if not num_str:
        return f"1 / ({den_str})" if len(denominators) > 1 else f"1 / {den_str}"
    return f"{num_str} / ({den_str})" if len(denominators) > 1 else f"{num_str} / {den_str}"


def render_unit_group(parts, url_func, name_func=None, locale="en-us"):
    """Render [(unit_id, exponent)] as HTML with natural-language exponents."""
    items = []
    for unit_id, exponent in parts:
        label = name_func(unit_id) if name_func else unit_id.replace("_", " ").title()
        word = exponent_word(exponent, locale)
        if url_func:
            text = f'<a href="{html.escape(url_func(unit_id))}">{html.escape(label)}</a>'
        else:
            text = html.escape(label)
        if word:
            text += " " + html.escape(word)
        items.append(text)
    return "-".join(items)


# ---------------------------------------------------------------------------
# Locale words and ordinals
# ---------------------------------------------------------------------------

LOCALE_WORDS = {
    "en-us": {
        "squared": "squared", "cubed": "cubed", "inverse": "inverse",
        "to_the": "to the", "per": "per", "reciprocal": "Reciprocal",
    },
    "en-uk": {
        "squared": "squared", "cubed": "cubed", "inverse": "inverse",
        "to_the": "to the", "per": "per", "reciprocal": "Reciprocal",
    },
}

ORDINAL_TEEN_SUFFIXES = {11: "th", 12: "th", 13: "th"}
ORDINAL_DIGIT_SUFFIXES = {0: "th", 1: "st", 2: "nd", 3: "rd",
                          4: "th", 5: "th", 6: "th", 7: "th", 8: "th", 9: "th"}


def locale_words(locale):
    return LOCALE_WORDS.get(locale, LOCALE_WORDS["en-us"])


def _ordinal(n):
    last_two = n % 100
    if last_two in ORDINAL_TEEN_SUFFIXES:
        suffix = ORDINAL_TEEN_SUFFIXES[last_two]
    else:
        suffix = ORDINAL_DIGIT_SUFFIXES[n % 10]
    return f"{n}{suffix}"


def exponent_word(exp, locale="en-us"):
    """Return the natural-language word for a unit exponent."""
    words = locale_words(locale)
    if exp == 2:
        return words["squared"]
    if exp == 3:
        return words["cubed"]
    if exp == 1:
        return ""
    if exp == -1:
        return words["inverse"]
    if exp > 3:
        return f"{words['to_the']} {_ordinal(exp)}"
    return ""


def difficulty_to_stars(difficulty, max_dots=5):
    """Render a difficulty (1-10) as a string of filled + empty stars."""
    filled = min(int(difficulty or 0), max_dots)
    return "\u2605" * filled + "\u2606" * (max_dots - filled)


def format_unit_with_links(unit_id, name_func, url_func=None, locale="en-us"):
    """Render a unit name with optional links."""
    name = name_func(unit_id) if name_func else unit_id.replace("_", " ").title()
    if url_func:
        return f'<a href="{html.escape(url_func(unit_id))}">{html.escape(name)}</a>'
    return html.escape(name)


# ---------------------------------------------------------------------------
# LaTeX rendering
# ---------------------------------------------------------------------------

def _render_with_exponent(exponent, base):
    """Render a base string with an exponent in LaTeX form."""
    if exponent is None or exponent == 1:
        return base

    if exponent == int(exponent):
        integer_exp = int(exponent)
        if integer_exp < 0:
            inner = base
            if integer_exp != -1:
                inner += "^{" + format_number(-integer_exp) + "}"
            return "\\frac{1}{" + inner + "}"
        return base + "^{" + format_number(integer_exp) + "}"

    try:
        fraction = Fraction(exponent).limit_denominator(100)
        num, den = fraction.numerator, fraction.denominator
    except Exception:
        return base + "^{" + format_number(exponent) + "}"

    if num == 1:
        if den == 2:
            return "\\sqrt{" + base + "}"
        return "\\sqrt[" + str(den) + "]{" + base + "}"
    if num == -1:
        if den == 2:
            return "\\frac{1}{\\sqrt{" + base + "}}"
        return "\\frac{1}{\\sqrt[" + str(den) + "]{" + base + "}}"
    inner = base + "^{" + format_number(num) + "}"
    if den == 2:
        return "\\sqrt{" + inner + "}"
    return "\\sqrt[" + str(den) + "]{" + inner + "}"


_CMD_LETTER_SEP = "{}"


def render_variable(item, flipped, locale="en-us"):
    """Render a formula_item variable as LaTeX."""
    raw_overwrite = item["symbol_overwrite"] or ""
    var = localise(raw_overwrite, locale) or item["quantity_symbol"] or item["quantity_id"] or "?"
    prefix = item["latex_prefix"] or ""
    suffix = item["latex_suffix"] or ""

    if prefix:
        # Insert {} between prefix and var if both are alphabetic, so LaTeX
        # doesn't read the variable as part of the command name.
        if prefix[-1].isalpha() and var[0].isalpha():
            var = prefix + _CMD_LETTER_SEP + var
        else:
            var = prefix + var

    if suffix:
        if var[-1].isalpha() and suffix[0].isalpha():
            var = var + _CMD_LETTER_SEP + suffix
        else:
            var = var + suffix

    label = localise(item["label"] or "", locale)
    if label and "_" not in var:
        var += "_{" + label + "}"

    exponent = item["var_exponent"] if item["var_exponent"] is not None else 1
    if flipped:
        exponent = -exponent

    return _render_with_exponent(exponent, var)


def render_coefficient(item, is_first_in_term):
    """Render a formula_item coefficient as LaTeX. Returns (body, is_negative)."""
    body = None
    is_negative = False
    latex_coef = item["latex_coef"] or None
    coeff_value = item["coeff_value"]
    coeff_exponent = item["coeff_exponent"] if item["coeff_exponent"] is not None else 1

    if latex_coef:
        body = latex_coef
    elif coeff_value is not None:
        value = coeff_value
        if value < 0:
            is_negative = True
            value = abs(value)
        body = format_number(value) if value != 1 else None
    else:
        body = None

    if body is not None:
        body = _render_with_exponent(coeff_exponent, body)
        if not latex_coef and body == "1":
            body = None
    elif coeff_exponent not in (None, 1):
        body = _render_with_exponent(coeff_exponent, "1")

    if is_first_in_term and is_negative and body in (None, "", "1"):
        body = ""
        is_negative = False

    return (body if body else None), is_negative


def _join_latex_parts(parts):
    """Join LaTeX fragments, adding {} between a command and a following letter."""
    result = []
    for p in parts:
        if result and result[-1] and p:
            last = result[-1]
            i = len(last) - 1
            while i >= 0 and last[i].isalpha():
                i -= 1
            if i >= 0 and last[i] == "\\" and i < len(last) - 1 and p[0].isalpha():
                result.append("{}")
        result.append(p)
    return "".join(result)


def _render_items_group(items, flipped, locale="en-us"):
    """Render a list of items as (numerator_latex, denominator_latex)."""
    num_parts = []
    den_parts = []
    for i, item in enumerate(items):
        coefficient, is_negative = render_coefficient(item, is_first_in_term=(i == 0))

        if item["quantity_id"]:
            exponent = item["var_exponent"] if item["var_exponent"] is not None else 1
            if flipped:
                exponent = -exponent
            if is_negative and coefficient:
                coefficient = "-" + coefficient
            if exponent < 0:
                rendered_var = render_variable(
                    dict(item, var_exponent=abs(exponent)),
                    flipped=False,
                    locale=locale,
                )
                if coefficient:
                    den_parts.append(coefficient)
                den_parts.append(rendered_var)
            else:
                rendered_var = render_variable(item, flipped=flipped, locale=locale)
                if coefficient:
                    num_parts.append(coefficient)
                num_parts.append(rendered_var)
        elif coefficient:
            if is_negative:
                den_parts.append(coefficient)
            else:
                num_parts.append(coefficient)

    return _join_latex_parts(num_parts), _join_latex_parts(den_parts)


def render_formula_items(items, locale="en-us"):
    """Build a LaTeX string from formula_item rows. Handles fractions for negatives."""
    by_term = defaultdict(list)
    for item in items:
        by_term[item["term"]].append(item)

    left_hand_terms = []
    right_hand_terms = []

    for term_number in sorted(by_term):
        term_items = sorted(
            by_term[term_number],
            key=lambda x: (not x["is_primary"], x["sort_order"]),
        )
        primary = [item for item in term_items if item["is_primary"]]
        non_primary = [item for item in term_items if not item["is_primary"]]

        num, den = _render_items_group(primary, flipped=True, locale=locale)
        if num or den:
            if den:
                has_neg = num.startswith("-")
                clean_num = num.lstrip("-")
                if has_neg:
                    term_str = f"-\\frac{{{clean_num}}}{{{den}}}"
                else:
                    term_str = f"\\frac{{{num}}}{{{den}}}" if num else f"\\frac{{1}}{{{den}}}"
                if term_str == "\\frac{}{}":
                    term_str = "\\frac{1}{" + den + "}"
            else:
                term_str = num
            if term_str:
                left_hand_terms.append(term_str)

        num, den = _render_items_group(non_primary, flipped=False, locale=locale)
        if num or den:
            if den:
                has_neg = num.startswith("-")
                clean_num = num.lstrip("-")
                if has_neg:
                    term_str = f"-\\frac{{{clean_num}}}{{{den}}}"
                else:
                    term_str = f"\\frac{{{num}}}{{{den}}}" if num else f"\\frac{{1}}{{{den}}}"
                if term_str == "\\frac{}{}":
                    term_str = "\\frac{1}{" + den + "}"
            else:
                term_str = num
            if term_str:
                sign = "+"
                for item in non_primary:
                    coeff = item["coeff_value"]
                    if coeff is not None and coeff < 0:
                        sign = "-"
                        break
                right_hand_terms.append((sign, term_str))

    left_hand = " + ".join(left_hand_terms) if left_hand_terms else "1"
    right_parts = []
    for i, (sign, term_str) in enumerate(right_hand_terms):
        if i == 0:
            right_parts.append(f"- {term_str}" if sign == "-" else term_str)
        else:
            right_parts.append(f"{sign} {term_str}")
    right_hand = " ".join(right_parts)
    return f"{left_hand} = {right_hand}"


# ---------------------------------------------------------------------------
# Common queries
# ---------------------------------------------------------------------------

def fetch_formula(conn, formula_id):
    return conn.execute(
        """
        SELECT *, json_extract(name, '$.en-us') AS name_en,
               topic AS topic_id,
               json_extract(description, '$.en-us') AS description_en
        FROM formula WHERE id = ?
        """,
        (formula_id,),
    ).fetchone()


def fetch_formula_items(conn, formula_id):
    return conn.execute(
        """
        SELECT fi.*, q.symbol AS quantity_symbol
        FROM formula_item fi
        LEFT JOIN quantity q ON q.id = fi.quantity_id
        WHERE fi.formula_id = ?
        ORDER BY fi.term, fi.is_primary DESC, fi.sort_order
        """,
        (formula_id,),
    ).fetchall()


def fetch_formula_conditions(conn, formula_id):
    return conn.execute(
        """
        SELECT c.default_on, json_extract(c.name, '$.en-us') AS name_en,
               c.replacement_formula_id,
               json_extract(f2.name, '$.en-us') AS replacement_name
        FROM condition c
        JOIN formula f2 ON f2.id = c.replacement_formula_id
        WHERE c.formula_id = ?
        ORDER BY c.sort_order
        """,
        (formula_id,),
    ).fetchall()


def fetch_formula_related(conn, formula_id):
    return conn.execute(
        """
        SELECT fr.relation_type, fr.related_id,
               json_extract(f2.name, '$.en-us') AS related_name
        FROM formula_relation fr
        JOIN formula f2 ON f2.id = fr.related_id
        WHERE fr.formula_id = ?
        ORDER BY fr.relation_type
        """,
        (formula_id,),
    ).fetchall()


def fetch_formula_quantities(conn, formula_id):
    rows = conn.execute(
        """
        SELECT DISTINCT q.id, q.name, q.symbol,
               json_extract(q.name, '$.en-us') AS name_en,
               COALESCE(json_extract(fi.quantity_name_overwrite, '$.en-us'),
                        json_extract(q.name, '$.en-us')) AS display_name,
               q.default_unit,
               q.dim_M, q.dim_L, q.dim_T, q.dim_I, q.dim_Θ, q.dim_N, q.dim_J
        FROM formula_item fi
        JOIN quantity q ON q.id = fi.quantity_id
        WHERE fi.formula_id = ?
        """,
        (formula_id,),
    ).fetchall()
    return sort_quantities_by_dimension(rows)


def fetch_quantity(conn, quantity_id):
    return conn.execute(
        """
        SELECT *, json_extract(name, '$.en-us') AS name_en,
               json_extract(description, '$.en-us') AS description_en
        FROM quantity WHERE id = ?
        """,
        (quantity_id,),
    ).fetchone()


def fetch_quantity_units(conn, quantity_id):
    return conn.execute(
        """
        SELECT u.*, json_extract(u.name, '$.en-us') AS name_en
        FROM unit u WHERE u.quantity_id = ?
        ORDER BY u.default_unit DESC, u.unit_system
        """,
        (quantity_id,),
    ).fetchall()


def fetch_quantity_formulas(conn, quantity_id):
    return conn.execute(
        """
        SELECT DISTINCT f.id, json_extract(f.name, '$.en-us') AS name_en,
               f.topic AS topic_id, f.difficulty
        FROM formula_item fi
        JOIN formula f ON f.id = fi.formula_id
        WHERE fi.quantity_id = ?
        ORDER BY f.topic, f.difficulty, f.id
        """,
        (quantity_id,),
    ).fetchall()


def fetch_quantity_formulas_by_side(conn, quantity_id):
    """Return (primary_formulas, non_primary_formulas) for a quantity."""
    rows = conn.execute(
        """
        SELECT DISTINCT f.id, json_extract(f.name, '$.en-us') AS name_en,
               f.topic AS topic_id, f.difficulty, fi.is_primary
        FROM formula_item fi
        JOIN formula f ON f.id = fi.formula_id
        WHERE fi.quantity_id = ?
        ORDER BY f.topic, f.difficulty, f.id
        """,
        (quantity_id,),
    ).fetchall()
    primary = [r for r in rows if r["is_primary"]]
    non_primary = [r for r in rows if not r["is_primary"]]
    return primary, non_primary


def compute_formula_dimensions(conn, formula_id):
    """Compute dimensions from primary-term quantities."""
    items = conn.execute(
        """
        SELECT fi.var_exponent, q.dim_M, q.dim_L, q.dim_T,
               q.dim_I, q.dim_Θ, q.dim_N, q.dim_J
        FROM formula_item fi
        JOIN quantity q ON q.id = fi.quantity_id
        WHERE fi.formula_id = ? AND fi.is_primary = 1
        """,
        (formula_id,),
    ).fetchall()
    dims = [0.0] * 7
    for r in items:
        exp = abs(r["var_exponent"] or 1)
        for i, column in enumerate(DIMENSION_COLUMNS):
            dims[i] += r[column] * exp
    return [int(d) for d in dims]


def fetch_si_unit_symbol(conn, quantity_id):
    """Get the SI base unit symbol for a quantity."""
    row = conn.execute(
        """
        SELECT u.symbol FROM unit u
        WHERE u.quantity_id = ? AND u.default_unit = 1
        LIMIT 1
        """,
        (quantity_id,),
    ).fetchone()
    return row["symbol"] if row else ""


def fetch_quantity_related_formulas(conn, quantity_id):
    """Get formulas related via formula_relation that use this quantity."""
    return conn.execute(
        """
        SELECT DISTINCT f.id, json_extract(f.name, '$.en-us') AS name_en,
               fr.relation_type
        FROM formula_relation fr
        JOIN formula f ON f.id = fr.related_id
        JOIN formula_item fi ON fi.formula_id = f.id
        WHERE fi.quantity_id = ?
        ORDER BY fr.relation_type, f.id
        """,
        (quantity_id,),
    ).fetchall()


def fetch_unit(conn, unit_id):
    return conn.execute(
        """
        SELECT u.*, json_extract(q.name, '$.en-us') AS quantity_name,
               q.topic AS topic_id,
               json_extract(u.name, '$.en-us') AS name_en
        FROM unit u JOIN quantity q ON q.id = u.quantity_id
        WHERE u.id = ?
        """,
        (unit_id,),
    ).fetchone()


def search_database(conn, query, limit=30):
    """Full-text search across formulas, quantities, and units."""
    terms = " OR ".join(f'"{w}"*' for w in query.split())

    formulas = conn.execute(
        """
        SELECT 'formula' AS kind, fts.formula_id AS id,
               f.name AS name,
               json_extract(f.name, '$.en-us') AS name_en,
               f.branch AS branch_id, f.topic AS topic_id,
               f.difficulty, NULL AS extra
        FROM formula_fts fts
        JOIN formula f ON f.id = fts.formula_id
        WHERE formula_fts MATCH ?
        ORDER BY rank
        LIMIT ?
        """,
        (terms, limit),
    ).fetchall()

    quantities = conn.execute(
        """
        SELECT 'quantity' AS kind, fts.quantity_id AS id,
               q.name AS name, fts.name AS name_en, NULL, NULL, NULL,
               q.symbol AS extra
        FROM quantity_fts fts
        JOIN quantity q ON q.id = fts.quantity_id
        WHERE quantity_fts MATCH ?
        LIMIT ?
        """,
        (terms, limit),
    ).fetchall()

    units = conn.execute(
        """
        SELECT 'unit' AS kind, fts.unit_id AS id,
               u.name AS name, fts.name AS name_en, NULL, NULL, NULL,
               fts.symbol AS extra
        FROM unit_fts fts
        JOIN unit u ON u.id = fts.unit_id
        WHERE unit_fts MATCH ?
        LIMIT ?
        """,
        (terms, limit),
    ).fetchall()

    return list(formulas) + list(quantities) + list(units)


def build_dimension_symbol_maps(conn):
    """Return (variable_map, unit_map, dim_map) for dimension display."""
    dimension_qty_ids = dimension_quantity_ids(conn)
    variable_map, unit_map, dim_map = {}, {}, {}
    for symbol in DIMENSION_SYMBOLS:
        quantity_id = dimension_qty_ids.get(symbol)
        if not quantity_id:
            variable_map[symbol] = symbol
            unit_map[symbol] = symbol
            dim_map[symbol] = symbol
            continue
        row = conn.execute(
            "SELECT symbol, symbol_overwrite, default_unit FROM quantity WHERE id=?",
            (quantity_id,),
        ).fetchone()
        variable_map[symbol] = row["symbol"] if row and row["symbol"] else symbol

        unit_symbol = None
        if row and row["default_unit"]:
            try:
                default_unit = json.loads(row["default_unit"])
                if isinstance(default_unit, list) and default_unit:
                    uid = default_unit[0].get("unit", "")
                    if uid:
                        unit_row = conn.execute(
                            "SELECT symbol FROM unit WHERE id=?", (uid,),
                        ).fetchone()
                        if unit_row:
                            unit_symbol = unit_row["symbol"]
            except (ValueError, TypeError, IndexError):
                pass
        unit_map[symbol] = unit_symbol if unit_symbol else variable_map[symbol]

        quantity_row = conn.execute(
            "SELECT symbol_overwrite FROM quantity WHERE id=?", (quantity_id,),
        ).fetchone()
        if quantity_row and quantity_row["symbol_overwrite"]:
            try:
                overwrite = json.loads(quantity_row["symbol_overwrite"])
                dim_symbol = overwrite.get("dim")
                if dim_symbol:
                    dim_map[symbol] = dim_symbol
                    continue
            except (ValueError, TypeError):
                pass
        dim_map[symbol] = symbol

    return variable_map, unit_map, dim_map


_BASE_DIMENSION_ORDER = {
    "mass": 1, "length": 2, "time": 3, "current": 4,
    "temperature": 5, "amount": 6, "luminous_intensity": 7,
}


def sort_quantities_by_dimension(quantity_rows):
    """Sort quantities: 7 base dimensions in canonical order, rest by id."""
    def key(quantity):
        base_index = _BASE_DIMENSION_ORDER.get(quantity["id"], 99)
        return (0 if base_index < 99 else 1, base_index, quantity["id"])
    return sorted(quantity_rows, key=key)


def fetch_all_quantities(conn):
    """Return all quantities with default_unit parsed and dimensions."""
    rows = conn.execute(
        """
        SELECT q.id, q.name, q.symbol,
               json_extract(q.name, '$.en-us') AS name_en,
               q.topic AS topic_id, q.difficulty, q.is_dim, q.default_unit,
               q.dim_M, q.dim_L, q.dim_T, q.dim_I, q.dim_Θ, q.dim_N, q.dim_J
        FROM quantity q
        ORDER BY q.id
        """
    ).fetchall()
    return sort_quantities_by_dimension(rows)


def fetch_all_formulas(conn):
    """Return all formulas."""
    return conn.execute(
        """
        SELECT f.id, f.name, json_extract(f.name, '$.en-us') AS name_en,
               f.topic AS topic_id, f.difficulty
        FROM formula f
        ORDER BY f.topic, f.difficulty, f.id
        """
    ).fetchall()


def compute_all_formula_dimensions(conn):
    """Return {formula_id: {dim_M, dim_L, ...}} for all formulas."""
    rows = conn.execute(
        """
        SELECT fi.formula_id,
               CAST(SUM(ABS(COALESCE(fi.var_exponent, 1)) * q.dim_M) AS INTEGER) AS dim_M,
               CAST(SUM(ABS(COALESCE(fi.var_exponent, 1)) * q.dim_L) AS INTEGER) AS dim_L,
               CAST(SUM(ABS(COALESCE(fi.var_exponent, 1)) * q.dim_T) AS INTEGER) AS dim_T,
               CAST(SUM(ABS(COALESCE(fi.var_exponent, 1)) * q.dim_I) AS INTEGER) AS dim_I,
               CAST(SUM(ABS(COALESCE(fi.var_exponent, 1)) * q.dim_Θ) AS INTEGER) AS dim_Θ,
               CAST(SUM(ABS(COALESCE(fi.var_exponent, 1)) * q.dim_N) AS INTEGER) AS dim_N,
               CAST(SUM(ABS(COALESCE(fi.var_exponent, 1)) * q.dim_J) AS INTEGER) AS dim_J
        FROM formula_item fi
        JOIN quantity q ON q.id = fi.quantity_id
        WHERE fi.is_primary = 1
        GROUP BY fi.formula_id
        """
    ).fetchall()
    return {
        r["formula_id"]: {c: int(r[c] or 0) for c in DIMENSION_COLUMNS}
        for r in rows
    }


def fetch_formulas_with_any_quantity(conn, quantity_ids):
    """Return formula_ids that reference ANY of the given quantity IDs (OR)."""
    if not quantity_ids:
        return None
    placeholders = ",".join("?" for _ in quantity_ids)
    rows = conn.execute(
        f"""
        SELECT DISTINCT formula_id FROM formula_item
        WHERE quantity_id IN ({placeholders})
        """,
        quantity_ids,
    ).fetchall()
    return {r["formula_id"] for r in rows}


def fetch_formulas_with_all_quantities(conn, quantity_ids):
    """Return formula_ids that reference ALL of the given quantity IDs (AND)."""
    if not quantity_ids:
        return None
    n = len(quantity_ids)
    placeholders = ",".join("?" for _ in quantity_ids)
    rows = conn.execute(
        f"""
        SELECT formula_id, COUNT(DISTINCT quantity_id) AS match_count
        FROM formula_item
        WHERE quantity_id IN ({placeholders})
        GROUP BY formula_id
        HAVING match_count = ?
        """,
        quantity_ids + [n],
    ).fetchall()
    return {r["formula_id"] for r in rows}


# ---------------------------------------------------------------------------
# Export
# ---------------------------------------------------------------------------

EXPORT_TABLE_ORDER = [
    "quantity", "unit", "formula", "formula_item", "condition", "formula_relation",
]

EXPORT_TABLE_COLUMNS = {
    "formula": [
        "id", "name", "topic", "difficulty", "description", "links",
    ],
    "formula_item": [
        "formula_id", "term", "is_primary", "sort_order",
        "coeff_value", "latex_coef", "coeff_exponent",
        "quantity_id", "var_exponent", "label",
        "symbol_overwrite", "quantity_name_overwrite",
        "latex_prefix", "latex_suffix",
    ],
    "condition": [
        "name", "formula_id", "replacement_formula_id", "default_on", "sort_order",
    ],
    "formula_relation": [
        "formula_id", "related_id", "relation_type",
    ],
    "quantity": [
        "id", "name", "symbol", "symbol_overwrite", "topic",
        "difficulty", "description", "links", "is_dim", "default_unit",
        "dim_M", "dim_L", "dim_T", "dim_I", "dim_Θ", "dim_N", "dim_J",
    ],
    "unit": [
        "id", "name", "symbol", "quantity_id", "default_unit", "unit_system",
        "factor", "latex_factor", "offset",
    ],
}




def _each_table(conn):
    """Yield (table_name, columns, rows) for all tables in export order."""
    for table in EXPORT_TABLE_ORDER:
        columns = EXPORT_TABLE_COLUMNS[table]
        rows = conn.execute(
            f"SELECT {','.join(columns)} FROM {table} ORDER BY rowid"
        ).fetchall()
        yield table, columns, [[r[c] for c in columns] for r in rows]


def export_to_csv(conn):
    """Export all tables to a single CSV string with section headers."""
    buffer = StringIO()
    for table, columns, rows in _each_table(conn):
        buffer.write(f"=== {table} ===\n")
        writer = csv.writer(buffer)
        writer.writerow(columns)
        writer.writerows(rows)
        buffer.write("\n")
    return buffer.getvalue()


def export_to_csv_directory(conn, directory):
    """Export each table to a separate CSV file in a directory."""
    path = Path(directory)
    path.mkdir(parents=True, exist_ok=True)
    for table, columns, rows in _each_table(conn):
        with open(path / f"{table}.csv", "w", newline="") as f:
            writer = csv.writer(f)
            writer.writerow(columns)
            writer.writerows(rows)


def export_to_xlsx(conn, output):
    """Export all tables as sheets in an XLSX workbook (file path or file-like)."""
    from openpyxl import Workbook
    workbook = Workbook()
    first = True
    for table, columns, rows in _each_table(conn):
        if first:
            sheet = workbook.active
            sheet.title = table[:31]
            first = False
        else:
            sheet = workbook.create_sheet(title=table[:31])
        sheet.append(columns)
        for row in rows:
            sheet.append(row)
    workbook.save(output)


def export_to_ods(conn, output):
    """Export all tables as sheets in an ODS spreadsheet (file path or file-like)."""
    from odf.opendocument import OpenDocumentSpreadsheet
    from odf.table import Table, TableRow, TableCell
    from odf.text import P
    document = OpenDocumentSpreadsheet()
    for table, columns, rows in _each_table(conn):
        sheet = Table(name=table[:31])
        document.spreadsheet.addElement(sheet)
        for row_data in [columns] + rows:
            row = TableRow()
            for value in row_data:
                cell = TableCell()
                cell.addElement(P(text=str(value) if value is not None else ""))
                row.addElement(cell)
            sheet.addElement(row)

