# Skills

Claude Code skills I build and use day to day. I'll post new ones here as I create them.

Each directory is a self-contained skill: drop it into `~/.claude/skills/` and Claude Code
picks it up automatically.

## Skills

| Skill | What it does |
|---|---|
| [claude-grill-me](./claude-grill-me) | Stress-tests a plan by grilling you, using Claude Code's native multiple-choice question UI. A fork of [mattpocock/skills](https://github.com/mattpocock/skills)' `grill-me`. |

## Installing

```bash
git clone https://github.com/ManishJain0/skills.git
cp -r skills/claude-grill-me ~/.claude/skills/
```

## Credits

`claude-grill-me` is derived from the `grill-me` skill in
[mattpocock/skills](https://github.com/mattpocock/skills) (MIT, Copyright (c) 2026 Matt Pocock).
See [claude-grill-me/README.md](./claude-grill-me/README.md) for what changed.

## Licence

[MIT](./LICENSE).
