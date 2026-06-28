# Scifind Wiki

Scifind is a structured physics formula database with a CLI tool and Flask web application. Formulas are stored in a normalized SQL schema with full LaTeX rendering, i18n (en-US/en-UK), dimension analysis, and multiple export formats (CSV, XLSX, ODS).

## Pages

- **[CLI Tool](CLI)** — Command-line interface reference
- **[Web App](Web-App)** — Flask web application features and routes
- **[Database](Database)** — Schema, views, and seed data specification
- **[Development](Development)** — Setup, migration, contributing

## Tech Stack

| Component | Tech |
|-----------|------|
| Backend | Python 3 + Flask |
| Database | SQLite with FTS5 full-text search |
| Rendering | KaTeX via CDN |
| Export | CSV, XLSX (openpyxl), ODS (odfpy) |
| Frontend | Vanilla JS, no framework |
