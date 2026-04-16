---
name: snow-cli
description: Use when interacting with Snowflake data warehouse - running SQL queries, inspecting schemas/tables, managing stages/objects, or any Snowflake operation. Triggers on "query snowflake", "check snowflake", "run SQL on snowflake", "snowflake schema", "snow sql", or any Snowflake data warehouse interaction.
model: sonnet
allowed-tools: Read, Grep, Glob, Bash(snow *)
---

# Snowflake with snow CLI

## Prerequisites

Requires the `snow` CLI. If it's not installed, point the user to `SETUP.md` at the plugin root (section: **snow-cli**) and stop until it's available.

## User Preferences

Load preferences at the start of every run:

1. If `${CLAUDE_PLUGIN_DATA}/preferences/snow-cli.md` does not exist, seed it:
   ```bash
   mkdir -p "${CLAUDE_PLUGIN_DATA}/preferences"
   cp "${CLAUDE_PLUGIN_ROOT}/skills/snow-cli/preferences.template.md" \
      "${CLAUDE_PLUGIN_DATA}/preferences/snow-cli.md"
   ```
   Mention it once: "Seeded preferences at `${CLAUDE_PLUGIN_DATA}/preferences/snow-cli.md` — edit anytime to customize."
2. Read it. Substitute `default_connection` wherever this doc shows `<connection>` and pass it as `-c <connection>`. When `default_database` is set, use it as the qualifier for bare table names. When `default_warehouse` is set, use it in `USE WAREHOUSE` statements or as needed. Read any `context_files` paths for schema/table context. Empty fields mean "no default — ask the user or fully qualify every reference."

All examples below use `<connection>` — substitute with your `default_connection` from preferences.

## Overview

`snow` is the Snowflake CLI. Use it for SQL queries, schema inspection, stage operations, and any Snowflake platform interaction.

## Auth Setup

Snow connections are pre-configured in `~/.snowflake/config.toml` (or via `snow connection add`). **Always pass `-c <connection>`** — do not rely on a default connection.

Verify auth: `snow connection test -c <connection>`

List connections: `snow connection list`

## Quick Reference

| Task | Command |
|------|---------|
| Run query | `snow sql -q "SELECT ..." -c <connection>` |
| Run SQL file | `snow sql -f query.sql -c <connection>` |
| Query from stdin | `cat q.sql \| snow sql -i -c <connection>` |
| JSON output | `snow sql -q "..." -c <connection> --format json` |
| List databases | `snow sql -q "SHOW DATABASES" -c <connection>` |
| List schemas | `snow sql -q "SHOW SCHEMAS IN DATABASE <DB>" -c <connection>` |
| List tables | `snow sql -q "SHOW TABLES IN SCHEMA <DB>.<SCHEMA>" -c <connection>` |
| Describe table | `snow sql -q "DESCRIBE TABLE <DB>.<SCHEMA>.<TABLE>" -c <connection>` |
| Test connection | `snow connection test -c <connection>` |
| List connections | `snow connection list` |
| Generate JWT | `snow connection generate-jwt -c <connection>` |
| List stages | `snow stage list -c <connection>` |
| List stage files | `snow stage list-files @stage_name -c <connection>` |
| Download from stage | `snow stage copy @stage_name/file.csv ./local/ -c <connection>` |
| List objects | `snow object list <type> -c <connection>` |
| Describe object | `snow object describe <type> <name> -c <connection>` |

## Output Formats

```bash
snow sql -q "..." -c <connection> --format table    # default, human-readable
snow sql -q "..." -c <connection> --format json     # use when parsing
snow sql -q "..." -c <connection> --format csv      # use for export
```

**Always use `--format json` when parsing results.**

## Read vs Write Operations

Even on a read-only role, `snow` can still issue destructive SQL. Treat these as write operations requiring user confirmation:

**Read (safe):** `SELECT`, `SHOW`, `DESCRIBE`, `EXPLAIN`, `snow connection test`, `snow object list/describe`, `snow stage list/list-files`, `snow logs`, `snow sql` with read-only queries, `snow cortex` (LLM calls)

**Write (require confirmation):**
- Any `INSERT`, `UPDATE`, `DELETE`, `MERGE`, `CREATE`, `ALTER`, `DROP`, `TRUNCATE`, `GRANT`, `REVOKE`, `USE`
- `snow object create/drop`
- `snow stage create/drop/copy` (uploads), `snow stage remove`
- `snow snowpark deploy/drop`
- `snow streamlit deploy/drop`
- `snow app deploy/teardown`

## Common Patterns

### Inspect a schema
```bash
snow sql -q "SHOW TABLES IN SCHEMA <DB>.<SCHEMA>" -c <connection> --format json
```

### Count rows in a table
```bash
snow sql -q "SELECT COUNT(*) FROM <DB>.<SCHEMA>.<TABLE>" -c <connection>
```

### Find recent records
```bash
snow sql -q "SELECT * FROM <DB>.<SCHEMA>.<TABLE> ORDER BY CREATED DESC LIMIT 10" -c <connection> --format json
```

### Variable substitution (client-side templating)
```bash
snow sql -q "SELECT * FROM {{ table }} LIMIT 5" -D "table=<DB>.<SCHEMA>.<TABLE>" -c <connection>
```

### Schema discovery for a new table
```bash
snow sql -q "DESCRIBE TABLE <DB>.<SCHEMA>.<TABLE>" -c <connection> --format json
```

## Database/Schema Context

Queries are NOT scoped by default (no default database/schema on the connection). **Always fully-qualify table names** as `DATABASE.SCHEMA.TABLE` or prepend `USE DATABASE <DB>; USE SCHEMA <SCHEMA>;` in the query.

```bash
# ✅ Good: fully qualified
snow sql -q "SELECT * FROM <DB>.<SCHEMA>.<TABLE> LIMIT 1" -c <connection>

# ❌ Bad: will fail with "Object does not exist"
snow sql -q "SELECT * FROM <TABLE> LIMIT 1" -c <connection>
```

For project-specific schema/database layout, see the target repo's `CLAUDE.md` or any `context_files` listed in preferences.

## Cortex (Snowflake's LLM)

```bash
snow cortex complete "Summarize this: ..." -c <connection>
snow cortex summarize "long text here" -c <connection>
snow cortex sentiment "I love this product" -c <connection>
snow cortex translate "Hello" --to es -c <connection>
```

Uses Snowflake's hosted models — queries go through the configured warehouse.

## Subcommands Overview

| Command | Use |
|---------|-----|
| `snow sql` | Execute SQL (most common) |
| `snow connection` | Manage connections, test, generate JWT |
| `snow object` | List/describe/create/drop Snowflake objects |
| `snow stage` | Upload/download files, manage stages |
| `snow snowpark` | Deploy Python procedures/functions |
| `snow streamlit` | Deploy Streamlit apps on Snowflake |
| `snow cortex` | LLM operations (summarize, translate, etc.) |
| `snow dbt` | Manage dbt on Snowflake projects |
| `snow git` | Manage git repos registered in Snowflake |
| `snow logs` | Stream logs for objects (tables, compute pools) |
| `snow notebook` | Manage Snowflake notebooks |
| `snow app` | Manage Snowflake Native Apps |

Run `snow <cmd> --help` for full flag list — don't guess syntax.

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `Connection not found` | Pass `-c <connection>` (no default set) |
| `JWT token is invalid` | Re-generate: `snow connection generate-jwt -c <connection>` |
| `Object does not exist` | Fully qualify: `DATABASE.SCHEMA.TABLE` |
| `Insufficient privileges` | Role is likely read-only on that schema — ask the Snowflake admin for elevated access |
| `Private key file not found` | Check `~/.snowflake/rsa_key.p8` exists and permissions are `600` |
| Warehouse suspended | Warehouse auto-resumes on query; first query may be slow (~5s cold start) |
| Hangs on large result | Add `LIMIT` clause or use `--format json` + stream |

## Safety Rules

1. **Always pass `-c <connection>`** — never rely on a default connection.
2. **Read-only by default** — if the user asks a question, use `SELECT`/`SHOW`/`DESCRIBE`, never `UPDATE`/`DELETE`/`DROP`.
3. **Fully qualify tables** — `DATABASE.SCHEMA.TABLE`, not bare table names.
4. **Don't run destructive SQL without user confirmation** — even with a read-only role, explicit write queries against granted schemas can damage data.
5. **Use `--format json` when piping to other tools** — default `table` format wraps long columns awkwardly.
6. **Avoid `SELECT *` on large tables** — always `LIMIT`, specify columns, or aggregate. Some pipeline tables have millions of rows and JSON blob columns.
