# Skills

Agent skills I build and use day to day. I'll post new ones here as I create them.

Each directory is a self-contained skill: drop it into `~/.claude/skills/` for Claude Code, or
`~/.agents/skills/` for Cursor, and the agent picks it up automatically.

## Skills

| Skill | What it does |
|---|---|
| [grill-me-native](./grill-me-native) | Stress-tests a plan by grilling you through the agent's native multiple-choice question UI. Works in Claude Code and Cursor. A fork of [mattpocock/skills](https://github.com/mattpocock/skills)' `grill-me`. |
| [session-discipline](./session-discipline) | Gates any 2+ file change behind a `grill-me-native` session, and calls compact-vs-new-chat with a handoff prompt once the session passes ~150k tokens. Ships a `UserPromptSubmit` hook for the token tripwire. |

## Installing

```bash
git clone https://github.com/ManishJain0/skills.git
cp -r skills/grill-me-native ~/.claude/skills/   # Claude Code
cp -r skills/grill-me-native ~/.agents/skills/   # Cursor
```

Or symlink the whole repo once and every skill in it loads:

```bash
ln -s "$PWD/skills" ~/.claude/skills
```

Skills that ship a hook need one extra step — see that skill's own README.

## Adding a skill to claude.ai

Skills also run on claude.ai (Settings → Capabilities → Skills → Upload). Zip the skill
directory so the folder itself is the archive root:

```bash
zip -r session-discipline.zip session-discipline -x '*.DS_Store'
```

Hooks are Claude Code only and do not run there, so any skill that ships one must still
work without it. If a skill delegates to another skill, upload both.

## House rules for new skills

Every skill added to this repo follows these. No exceptions without a reason written down.

1. **Grill before building.** Run `grill-me-native` on the idea first. Define the problem,
   the trigger, and the enforcement mechanism before a line of the skill is written.
2. **One directory, self-contained.** `SKILL.md` at its root, plus a `README.md` covering
   what it does and how to install it. Hooks and helper scripts live in `hooks/`.
3. **Frontmatter earns its trigger.** The `description` is the only thing the model sees
   when deciding to load the skill — spell out the concrete phrases and situations that
   should fire it, not a summary of the body.
4. **Degrade gracefully.** Assume no hook, no sibling skill, no shell. Say in `SKILL.md`
   what changes when a dependency is missing.
5. **Hooks stay silent and never block.** Exit 0 on every path — bad input, missing `jq`,
   unreadable transcript. Fire at most once per session. Test the silent, firing, repeat,
   and garbage-input cases before wiring it into `settings.json`.
6. **Ship the claude.ai path.** Verify the zip's root is the skill folder, and note in the
   README what is lost without hooks.
7. **Update this README** — the table above and, when the install story changes, the
   sections around it — in the same commit that adds the skill.

## Credits

`grill-me-native` is derived from the `grill-me` skill in
[mattpocock/skills](https://github.com/mattpocock/skills) (MIT, Copyright (c) 2026 Matt Pocock).
See [grill-me-native/README.md](./grill-me-native/README.md) for what changed.

## Licence

[MIT](./LICENSE).
