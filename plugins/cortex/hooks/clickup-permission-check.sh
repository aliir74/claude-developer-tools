#!/bin/bash
# ClickUp CLI permission hook — Pattern A (read/write gating)
# Whitelists read-only subcommands; gates all writes with "ask".
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

# Exit silently for non-clickup commands
if ! echo "$COMMAND" | grep -q '^clickup\b'; then
  exit 0
fi

# Always safe: auth, help, version, completion
if echo "$COMMAND" | grep -qE 'clickup\s+(auth|help|version|completion)\b'; then
  exit 0
fi

# Read-only: whitelist of safe subcommand patterns
if echo "$COMMAND" | grep -qE 'clickup\s+(task\s+(view|list|search|recent|activity)|comment\s+list|status\s+list|field\s+list|tag\s+list|sprint\s+(list|current)|member\s+list|space\s+list|inbox)\b'; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "allow",
      permissionDecisionReason: "ClickUp read-only operation"
    }
  }'
  exit 0
fi

# Everything else is a write — ask for confirmation
jq -n '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "ask",
    permissionDecisionReason: "ClickUp write operation — confirm before proceeding"
  }
}'
