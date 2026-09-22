---
name: session-discipline
description: Enforces efficient AI use on two triggers. (1) Scope gate — any request that will touch 2 or more files, or add a new file, gets grilled with grill-me-native before a single edit is made. (2) Context trip — when the session grows past ~150k tokens, judge compact vs new chat, recommend one, and emit a paste-ready handoff block. Use at the start of any add, build, implement, refactor, migrate, wire-up, or redesign request, and whenever a CONTEXT TRIPWIRE notice appears, the session feels long, or the user says compact, handoff, new chat, or asks whether they are using Claude well.
---

# Session Discipline

Stops two specific failures: drip-feeding small asks instead of one batched scope, and riding a bloated session past the point where output quality and cost both degrade.

Two independent triggers. They do not interact.

---

## Trigger 1 — Scope Gate

**Fires when** the request will touch **2 or more files**, or create a new file.

Judge this from the request plus a quick look at the code — before editing anything. The estimate will sometimes be wrong; when in doubt, gate.

**Does not fire for:** read-only questions, single-file edits, or anything already gated earlier in this session.

### Procedure

1. Read the relevant code first. Never grill about something answerable from the repo.
2. State the scope in four lines:

```
GOAL:      <end state, one sentence>
IN SCOPE:  <files and behaviors expected to change>
OUT:       <explicitly not doing>
DONE WHEN: <observable check>
```

3. **Invoke the `grill-me-native` skill against that block.** Do not hand-roll questions — delegate. If `grill-me-native` is unavailable, run the grill inline using `AskUserQuestion`, one question per call, recommended option first.
4. Execute the whole batch. Do not stop after each bullet for approval.

### Escape

The user says **"skip grill"** (or skip gate / no grill). Honor it silently for that request only — no acknowledgement, no lecture. It does not carry to the next request.

---

## Trigger 2 — Context Trip

**Fires when** a `CONTEXT TRIPWIRE` line appears in the prompt, or the session is plainly long and bloated.

### Procedure

Judge from what is actually in flight, then give **one** recommendation with its reason. Never present a neutral menu.

| Situation | Call |
|---|---|
| Mid-debug, mid-refactor, history carries the thread | **Compact.** Say which detail gets lost. |
| Scope just completed | **New chat.** |
| Topic pivoted to an unrelated area | **New chat.** Old context is pure cost. |
| Unsure | **New chat.** Cheaper and sharper; the handoff covers the gap. |

When recommending a new chat, emit this, ready to paste:

```
CONTEXT:  <repo, branch, what was just done — 2 lines max>
STATE:    <committed vs uncommitted, what works, what does not>
NEXT:     <the next scope, in GOAL/IN SCOPE/OUT/DONE WHEN form>
GOTCHAS:  <hard-won facts a fresh session cannot cheaply rediscover>
```

Under 15 lines. It is a seed, not a transcript.

Then do the work in the current message anyway. The recommendation is for the user's next move, not a refusal to proceed.

---

## Rules

- Never raise the same trigger twice in one session.
- The gate is a question, not a lecture. No essays on efficiency.
- Once gated, execute fully. Re-asking mid-build defeats the purpose.

## Without the hook

The hook is Claude Code only. On claude.ai, or with the hook uninstalled, Trigger 1 works unchanged and Trigger 2 fires on judgment — long session, many turns, repeated topic shifts — rather than a measured token count.
