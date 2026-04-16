# snow-cli preferences

Copy this file to `${CLAUDE_PLUGIN_DATA}/preferences/snow-cli.md` and fill in your values. The skill reads that copy, not this template, so your values survive plugin updates.

Any field left empty means "use the CLI's default" or "ask me each time."

## default_connection
<!--
Connection name from `~/.snowflake/config.toml` (or created via `snow connection add`).
Passed as `-c <value>` on every snow invocation. Find yours with: `snow connection list`.
-->
default_connection:

## default_warehouse
<!--
Snowflake warehouse to use when a query needs an explicit `USE WAREHOUSE` or the
connection config does not set one. Leave empty to rely on the connection's default.
-->
default_warehouse:

## default_database
<!--
Database used as the qualifier for bare table references (e.g., `PRODUCTION`).
Leave empty to require every query to fully qualify as DATABASE.SCHEMA.TABLE.
-->
default_database:

## context_files
<!--
Absolute paths Claude should read for additional schema/table context (e.g., a repo's
CLAUDE.md listing pipeline tables, a vault note with schema docs). One path per line.
Leave empty if none.
-->
context_files:
