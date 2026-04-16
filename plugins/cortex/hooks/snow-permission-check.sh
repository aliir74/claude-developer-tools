#!/bin/bash
# Snowflake CLI (snow) permission hook — Pattern A (read/write gating)
# Whitelists read-only subcommands; gates all writes with "ask".
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

# Exit silently for non-snow commands
if ! echo "$COMMAND" | grep -q '^snow\b'; then
  exit 0
fi

# Always safe: auth, connection, help, version, info, helpers, completion
if echo "$COMMAND" | grep -qE 'snow\s+(auth|connection|helpers|--help|-h|--version|--info|--install-completion|--show-completion)\b'; then
  exit 0
fi

# Cortex is entirely read-only (AI inference: complete, summarize, translate, sentiment, extract-answer)
if echo "$COMMAND" | grep -qE 'snow\s+cortex\b'; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "allow",
      permissionDecisionReason: "Snowflake cortex read-only AI operation"
    }
  }'
  exit 0
fi

# Read-only verbs (whitelist): list, describe, get-url, list-files, list-branches, list-tags, validate, events, open, logs, build, bundle, package
if echo "$COMMAND" | grep -qE 'snow\s+\S+\s+(list|describe|get-url|list-files|list-branches|list-tags|validate|events|open)\b'; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "allow",
      permissionDecisionReason: "Snowflake read-only operation"
    }
  }'
  exit 0
fi

# Top-level read-only: snow logs
if echo "$COMMAND" | grep -qE 'snow\s+logs\b'; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "allow",
      permissionDecisionReason: "Snowflake read-only logs"
    }
  }'
  exit 0
fi

# Local-only build operations (no Snowflake side effects)
if echo "$COMMAND" | grep -qE 'snow\s+\S+\s+(build|bundle|package)\b'; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "allow",
      permissionDecisionReason: "Snowflake local build operation"
    }
  }'
  exit 0
fi

# Everything else is a write (sql, create, drop, deploy, execute, copy, remove, run, teardown, publish, setup, share, fetch, init) — ask
jq -n '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "ask",
    permissionDecisionReason: "Snowflake write/execute operation — confirm before proceeding"
  }
}'
