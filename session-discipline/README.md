# session-discipline

Stops two ways of using Claude badly:

1. **Drip-feeding** — fifty small asks instead of one batched scope. Any change touching 2+ files gets grilled with [`grill-me-native`](https://github.com/ManishJain0/skills/tree/main/grill-me-native) before an edit is made.
2. **Bloated sessions** — riding one chat past the point where quality rots and token cost balloons. Past ~150k tokens, the skill calls compact vs new chat and writes the handoff prompt.

## Install — Claude Code

Skill loads automatically if this repo is at `~/.claude/skills`.

`grill-me-native` is a **separate skill, not bundled here** — install it alongside this one from
the same repo. Without it the scope gate still fires and runs the grill inline, just without the
sharper question ladder.

The token tripwire needs a hook. Add to `~/.claude/settings.json`:

```json
"hooks": {
  "UserPromptSubmit": [
    { "hooks": [ { "type": "command",
                   "command": "bash \"$HOME/.claude/skills/session-discipline/hooks/context-tripwire.sh\"" } ] }
  ]
}
```

Requires `jq`. Silent under threshold, fires once per session. Override with `SESSION_DISCIPLINE_THRESHOLD`.

## Install — claude.ai

Settings → Capabilities → Skills → Upload. Zip this folder:

```bash
cd .. && zip -r session-discipline.zip session-discipline -x '*.DS_Store'
```

Upload `grill-me-native` as its own skill too — this package does not contain it.

Hooks do not run on claude.ai. The scope gate works unchanged; the context trip fires on judgment instead of a measured count.
