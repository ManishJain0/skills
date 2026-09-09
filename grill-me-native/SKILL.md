---
name: grill-me-native
description: Grills a plan, design, or decision through the agent's native interactive multiple-choice UI (Claude Code or Cursor) — one question at a time, each with a recommended option. Assumes an expert user at standard pressure; focuses on requirements and implementation, not edge cases. Use when the user says "grill me", "grill me native", "stress-test this", "challenge my plan", or invokes /grill-me-native.
---

# Grill Me Native

Interview the user until the task requirements and implementation path are clear and defensible.

This is not hostile debate. It is calibrated pressure at a fixed setting: **expert knowledge, standard pressure**. Do not ask the user to calibrate — assume they understand the system and go straight at the plan.

## Core Rules

- Ask one question at a time, via the host's ask-questions tool — `AskUserQuestion` in Claude Code, the equivalent ask questions tool in Cursor. Never print questions as prose (see Escape Hatches for the exceptions).
- Every question carries a recommended answer as its first option.
- If the answer is in files, code, docs, issues, or logs, read those first instead of asking. Read the implementation surface **to find what to ask about**, not only to avoid asking.
- Skip domain basics. The user knows the terrain — pressure-test tradeoffs and the implementation path instead.
- **Do not dwell on error handling, edge cases, or failure modes.** Ask about them only when they change the shape of the plan, or when the user raises them — but a contract mismatch is not an edge case; raise it.
- **Validation and verification steps are off by default.** Do not ask how it will be verified, tested, or proven unless the user asks for that.
- Track unresolved decisions, assumptions, and dependencies privately.
- Let the user change intensity any time with "softer", "harder", or "skip ahead".

## Asking A Question

Each question is one ask-questions call carrying a single question. Map the pieces onto whatever the host's tool calls them; the field names below are Claude Code's:

| Piece | Field |
|---|---|
| The question | `question` |
| Ladder rung — e.g. `Goal fit`, `Scope`, `Approach` | `header`, max 12 chars |
| Recommended answer | first option, label ends `(Recommended)` |
| Why it matters, in one sentence | that option's `description` |
| Realistic alternatives | remaining options |
| Single-answer (always, for grilling) | `multiSelect: false` — required field |

Constraints: 2–4 options, labels 1–5 words, nuance goes in `description` not the label. Never add an "Other" option — free text is always offered automatically.

Offer "softer" / "harder" / "that's enough" as options when the session has run long or the user's answers are getting terse.

## Phase 1: Frame The Target

If the target is not clear, ask what to grill. If context already contains the plan, summarize it in 3-6 bullets and confirm with a question whose options are "Yes, grill that" and "Adjust — I'll describe it".

## Phase 2: Decision Map

Build this privately, one question at a time. Use it to choose the next question; do not dump it unless asked.

- Goal — what success means.
- Requirements — what the thing must actually do, stated concretely.
- Constraints — time, stack, team, policy, existing schema.
- Options — the obvious alternatives and why this one wins.
- Dependencies — what must be true or built first.
- Implementation — the order of work and what lands first.

## Phase 2.5: Ground Pass

Not optional, and it happens before question one. Open every file the plan says it will edit,
delete or extend, plus the base class or vendor contract of anything it subclasses, overrides or
registers against. Record privately:

- Symbols the plan names that do not exist, or exist with a different signature.
- What the base class already does that the plan duplicates, or must not override.
- A second producer or consumer of any shape the plan changes.
- Anything the plan asserts without a `file:line` you were able to confirm.

Findings here feed the Contract Reality rung. A plan that reads clean at spec level routinely
fails here.

## Phase 3: Question Ladder

Move through the ladder. Stop early once the plan is concrete enough.

### 1. Goal Fit
- What outcome matters most?
- What would make this not worth doing?
- Who is this for?

### 2. Requirements
- What exactly must this do, in observable terms?
- What is explicitly out of scope?
- Which requirement is vaguest right now?

### 3. Constraint Reality
- What hard constraint cannot move?
- What assumption would kill the plan if false?
- What in the existing system does this have to fit into?

### 4. Contract Reality

Questions on this rung come **only** from the Ground Pass, never from the plan's own text.

- Does the named class or method exist with that signature?
- What does the base class already do here that this duplicates or must not override?
- Who else produces or consumes this shape?
- Which asserted path or line number is wrong now?

### 5. Option Pressure
- What are the top two alternatives?
- Why this over the boring approach?
- What is being optimized for: speed, quality, cost, or reach?

### 6. Implementation Path
- What is the smallest useful version?
- What has to happen first?
- What order do the pieces land in?
- What can be deferred without harming the goal?

## Standard Pressure

- Challenge assumptions and tradeoffs directly.
- Name weak reasoning when you see it.
- Challenge vague words: "simple", "scalable", "clean", "fast".
- Keep moving until the implementation path is concrete.

## Escape Hatches

Fall back to prose instead of the tool when:

- The question is genuinely open-ended and options would distort it — e.g. "what should I grill?" with no context in the session.
- You need to state a correction or an observation rather than ask something.

## When To Stop

Stop when the user says stop, when the plan has a clear goal, requirements, chosen approach and first step, or when what's missing can only come from reading code or external research.

End with:

- Current best plan.
- Remaining open questions.
- Next concrete action.

Every finding you report cites `file:line`. Anything you could not verify is labelled unverified
rather than stated.
