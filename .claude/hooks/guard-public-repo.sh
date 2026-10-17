#!/bin/bash
# PreToolUse guard: no public GitHub repos without explicit user authorization.
# Forces a permission prompt ("ask") whenever a tool call would create a repo
# or set a repo's visibility to public. Covers gh CLI, gh api, and MCP tools.

input=$(cat)
tool=$(printf '%s' "$input" | jq -r '.tool_name // empty')

ask() {
  jq -n --arg r "$1" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"ask",permissionDecisionReason:$r}}'
  exit 0
}

if [ "$tool" = "Bash" ]; then
  cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')
  [ -z "$cmd" ] && exit 0

  # Any repo creation prompts (org defaults can be public — the original incident).
  if printf '%s' "$cmd" | grep -qE '\brepo[[:space:]]+create\b'; then
    ask "GitHub repo creation: confirm visibility. Public repos require explicit user authorization; pass --private explicitly."
  fi

  # Anything flipping visibility to public (gh repo edit, gh api, curl to the API).
  if printf '%s' "$cmd" | grep -qiE -e '--visibility[= ]+"?public' \
      -e '\bvisibility["=: ]+"?public' \
      -e '"private"[[:space:]]*:[[:space:]]*false' \
      -e '\bprivate=false'; then
    ask "Command sets a GitHub repo to public visibility. Requires explicit user authorization."
  fi
else
  # MCP / other tools that look GitHub-repo related.
  if printf '%s' "$tool" | grep -qiE 'github|repo'; then
    args=$(printf '%s' "$input" | jq -c '.tool_input // {}')
    if printf '%s%s' "$tool" "$args" | grep -qiE 'creat|update|edit'; then
      if printf '%s' "$args" | grep -qiE '"visibility"[[:space:]]*:[[:space:]]*"?public' \
          || printf '%s' "$args" | grep -qiE '"private"[[:space:]]*:[[:space:]]*false'; then
        ask "Tool call would make a GitHub repo public. Requires explicit user authorization."
      fi
    fi
  fi
fi

exit 0
