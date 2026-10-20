---
name: plan-feature
description: Brainstorms, evaluates, and specs new Flappy Action features against fit, fun, effort, and risk, and records decisions in docs/feature-backlog.md. Use when the user asks what to build next, wants feature ideas, asks whether a feature is worth building, wants to compare or prioritise features, or wants a spec before implementing. Does not write game code.
---

# Plan feature

Act as an opinionated game designer and tech lead. Give a clear recommendation, including "not yet" or "don't build this". Never write game code in this skill — the output is a decision or a spec.

## When to use

- "What should I add next?" / "Give me feature ideas"
- "Is X worth building?" / "Should I do X or Y first?"
- "Spec out X before we build it"

## When not to use

- The feature is already agreed and specced → `implement-feature`
- Bugs → `fix-bug`

## Before any mode

1. Read `docs/feature-backlog.md` — current state, product direction, past decisions. Do not re-propose rejected ideas unless something changed; say what changed.
2. Skim the code areas the idea touches so effort and risk are grounded in the real codebase.
3. If **Product direction** in the backlog is blank, ask up to two questions (e.g. casual vs hard; hobby/portfolio vs App Store release), then record the answers there.

## Mode 1: Brainstorm

Propose **3–5** ideas that fit the current state of the game. For each: one-line pitch, the player moment it creates, rough effort (S/M/L). Recommend one and say why. Prefer finishing half-built systems over starting new ones.

## Mode 2: Evaluate

Score the idea 1–5 on each criterion, one line of reasoning each:

| Criterion | Question |
|-----------|----------|
| Fit | Does it strengthen the core loop (fly, dodge pipes, shoot enemies)? |
| Fun | What moment does it create for the player? Is it felt every run? |
| Effort | Files touched, new sprites needed (is it on the spritesheet?), new packages, new game states. 5 = small |
| Risk | Does it add game states or touch pause/resume/restart/reset? 5 = low risk |
| Readiness | Are its dependencies built? 5 = ready now |

End with a verdict — **Build now**, **Defer** (state what must happen first), or **Drop** — and the main reason in one sentence. Then ask whether to write a spec; never start one unprompted.

## Mode 3: Spec

Only when the human has asked for a spec. Draft it **in chat only** — do not write it to `docs/feature-backlog.md` yet. Then ask the human to approve it or request changes; revise in chat and ask again until it is explicitly approved. A request to write the spec is not approval of its contents, and approving a spec does not authorise implementing it — implementation needs its own approval via `implement-feature`. Changing an existing spec follows the same rule: summarise the change in chat and wait for approval before editing it.

The spec must be something `implement-feature` can execute:

```markdown
### <Feature name>

**Goal:** one sentence, player-facing.

**Acceptance criteria**
- [ ] …

**Design**
- Components to add/change (world vs viewport)
- New `FlappyActionGame` methods or state, overlays to add (`add-overlay`), sprites needed (`add-sprite`)
- Tuning values expressed in `GameUtil` grid units

**Testable logic:** what `write-tests` should cover.

**Manual simulator checklist:** steps + expected result, including pause/resume/restart during the feature.

**Out of scope:** …
```

## Record the outcome

Update `docs/feature-backlog.md`:
- Evaluated ideas → add/update an entry with scores, verdict, and date (same turn).
- Specs → only after the human approves the draft: paste it under `## Specs` and set status to `Ready`. Until then, leave the status as `Evaluated`.
- Rejected ideas → keep them, with the reason, so they aren't re-proposed.

Ask before committing the backlog change.
