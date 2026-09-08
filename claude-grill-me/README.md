# claude-grill-me

A fork of [`grill-me`](https://github.com/mattpocock/skills/blob/main/skills/productivity/grill-me/SKILL.md)
by [Matt Pocock](https://github.com/mattpocock), tweaked so that **Claude Code asks its questions
natively** — as clickable multiple-choice cards with a free-text box, the same UI plan mode uses —
instead of printing questions as prose in the conversation.

## What changed from `grill-me`

**Questions go through the `AskUserQuestion` tool.** The original is written to be tool-agnostic so
it can run in other editors, so every question is emitted as text and you answer by typing. This
fork targets the Claude Code app specifically and calls the tool, one question at a time, with the
recommended answer as the first option and the "why it matters" line as that option's description.

**No calibration phase.** The original opens by asking how much you know about the topic and how
hard you want the pressure. This one is fixed at expert knowledge / standard pressure and goes
straight at the plan.

**Less edge-case grilling, more requirements.** The Failure Modes, Validation and Reversibility
rungs are gone. A Requirements rung replaces them, and the execution rung is widened into a full
implementation path. Verification and testing questions are off by default and only appear if you
ask for them.

## Why

Being handed three concrete options and clicking one is much faster than composing a paragraph,
and the options themselves do useful work — a well-built option set shows you the shape of the
decision before you've committed to an answer.

## Install

```bash
cp -r claude-grill-me ~/.claude/skills/
```

Then say "grill me" or run `/claude-grill-me`.

## Credit and licence

Derived from the `grill-me` skill in [mattpocock/skills](https://github.com/mattpocock/skills),
MIT licensed, Copyright (c) 2026 Matt Pocock. The ladder structure, the decision map and the
recommended-answer idea are all his; this fork changes the delivery mechanism and the emphasis.
If you want the original — including the companion `grilling` skill — install it with:

```bash
npx skills add https://github.com/mattpocock/skills --skill grill-me
```
