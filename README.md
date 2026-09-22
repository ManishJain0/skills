# Skills

Agent skills I build and use day to day. I'll post new ones here as I create them.

Each directory is a self-contained skill: drop it into `~/.claude/skills/` for Claude Code, or
`~/.agents/skills/` for Cursor, and the agent picks it up automatically.

## Skills

| Skill | What it does |
|---|---|
| [grill-me-native](./grill-me-native) | Stress-tests a plan by grilling you through the agent's native multiple-choice question UI. Works in Claude Code and Cursor. A fork of [mattpocock/skills](https://github.com/mattpocock/skills)' `grill-me`. |
| [php-83-to-85](./php-83-to-85) | Scans a PHP 8.3 codebase for PHP 8.4 and 8.5 incompatible changes and deprecations, using grep, PHPStan and Rector against the official migration pages, and writes a compatibility report. Fixes only the items you confirm. |

## Installing

```bash
git clone https://github.com/ManishJain0/skills.git
cp -r skills/grill-me-native ~/.claude/skills/   # Claude Code
cp -r skills/grill-me-native ~/.agents/skills/   # Cursor
cp -r skills/php-83-to-85 ~/.claude/skills/     # Claude Code
cp -r skills/php-83-to-85 ~/.agents/skills/     # Cursor
```

## Credits

`grill-me-native` is derived from the `grill-me` skill in
[mattpocock/skills](https://github.com/mattpocock/skills) (MIT, Copyright (c) 2026 Matt Pocock).
See [grill-me-native/README.md](./grill-me-native/README.md) for what changed.

## Licence

[MIT](./LICENSE).
