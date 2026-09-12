#!/usr/bin/env bash
# UserPromptSubmit hook: silent until the session's context passes a threshold,
# then tells Claude to run the session-discipline skill.
#
# Install in ~/.claude/settings.json:
#   "hooks": {
#     "UserPromptSubmit": [
#       { "hooks": [ { "type": "command",
#                      "command": "bash \"$HOME/.claude/skills/session-discipline/hooks/context-tripwire.sh\"" } ] }
#     ]
#   }
set -uo pipefail

THRESHOLD=${SESSION_DISCIPLINE_THRESHOLD:-150000}

input=$(cat)
transcript=$(printf '%s' "$input" | jq -r '.transcript_path // empty' 2>/dev/null)

# No transcript, no jq, or unreadable file: stay silent rather than error.
[ -n "$transcript" ] && [ -r "$transcript" ] || exit 0

# Context size = the last assistant turn's input footprint.
tokens=$(jq -s '
  [ .[]
    | select(.message.usage != null)
    | .message.usage
    | (.input_tokens // 0)
      + (.cache_creation_input_tokens // 0)
      + (.cache_read_input_tokens // 0)
  ] | last // 0
' "$transcript" 2>/dev/null)

case "$tokens" in ''|*[!0-9]*) exit 0 ;; esac
[ "$tokens" -ge "$THRESHOLD" ] || exit 0

# Once per session past the line — a nag every turn gets tuned out.
session=$(printf '%s' "$input" | jq -r '.session_id // "unknown"' 2>/dev/null)
flag="${TMPDIR:-/tmp}/session-discipline-tripped-${session}"
[ -e "$flag" ] && exit 0
: > "$flag"

printf 'CONTEXT TRIPWIRE: this session is at ~%s tokens (threshold %s). Invoke the `session-discipline` skill and run its Context Trip procedure before doing the work in this message.\n' \
  "$tokens" "$THRESHOLD"
