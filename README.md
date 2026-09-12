# Skills

Agent skills I build and use day to day. I'll post new ones here as I create them.

Each directory is a self-contained skill. Drop it where your agent looks for skills and it gets
picked up automatically.

## Skills

| Skill | What it does |
|---|---|
| [grill-me-native](./grill-me-native) | Stress-tests a plan by grilling you through the agent's native multiple-choice question UI. Works in Claude Code and Cursor. A fork of [mattpocock/skills](https://github.com/mattpocock/skills)' `grill-me`. |
| [session-discipline](./session-discipline) | Gates any 2+ file change behind a `grill-me-native` session, and calls compact-vs-new-chat with a handoff prompt once the session passes ~150k tokens. Ships a `UserPromptSubmit` hook for the token tripwire. |

## Installing

Copy the skills you want:

```bash
git clone https://github.com/ManishJain0/skills.git
cp -r skills/grill-me-native ~/.claude/skills/   # Claude Code
cp -r skills/grill-me-native ~/.agents/skills/   # Cursor
```

Copy individual skills rather than symlinking the whole repo to `~/.claude/skills`. Recent Claude
Code builds ship their own `grill-me-native` and `session-discipline` under the `anthropic-skills:`
prefix, and a repo-wide symlink registers a second copy of each — both show up in the skills list
and the built-in one wins.

Skills that ship a hook need one extra step — see that skill's own README. Wire hooks by absolute
path in `~/.claude/settings.json`, not through a symlink, so they survive the skill moving.

## Adding a skill to claude.ai

Skills also run on claude.ai (Settings → Capabilities → Skills → Upload). Zip the skill
directory so the folder itself is the archive root:

```bash
zip -r session-discipline.zip session-discipline -x '*.DS_Store'
```

Hooks are Claude Code only and do not run there, so any skill that ships one must still
work without it. If a skill delegates to another skill, upload both.

## Credits

`grill-me-native` is derived from the `grill-me` skill in
[mattpocock/skills](https://github.com/mattpocock/skills) (MIT, Copyright (c) 2026 Matt Pocock).
See [grill-me-native/README.md](./grill-me-native/README.md) for what changed.

## Licence

[MIT](./LICENSE).
