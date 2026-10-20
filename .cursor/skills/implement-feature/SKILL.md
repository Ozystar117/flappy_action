---
name: implement-feature
description: Implements a Flappy Action gameplay feature (enemies, bullets, scoring, difficulty, HUD, game flow) with minimal diffs matching existing Flame patterns. Use when the user asks to implement, add, or build a feature or new game behaviour.
---

# Implement feature

## When to use

- New gameplay, components, HUD elements, or game-flow behaviour

## When not to use

- Bug fixes → `fix-bug`
- Only adding a sprite → `add-sprite`
- Only adding a menu/screen → `add-overlay`
- Tests only → `write-tests`

## Instructions

1. **Clarify scope** — If `docs/feature-backlog.md` has a spec for this feature, use it as the acceptance criteria. Otherwise restate the feature and criteria; if something critical is ambiguous (e.g. how an enemy moves), ask once or suggest `plan-feature` first.
2. **Read neighbours** — Skim `FlappyActionGame` and the components nearest to the change. Follow `AGENTS.md` and `.cursor/rules/`.
3. **Plan briefly** — List the files to add or change. Keep it small; no drive-by refactors.
4. **Get approval** — Give a concise summary of the changes (what, which files, approach — a few bullets) and stop until the human explicitly approves. A `Ready` spec or an earlier approval is not approval (see `project-core.mdc`).
5. **Implement**
   - New state transitions → new method on `FlappyActionGame`.
   - New sprites → follow `add-sprite`.
   - New overlays → follow `add-overlay`.
   - Gameplay objects in `world`, HUD in the viewport; anything spawned is cleaned up by `reset()` or `removeFromParent()`.
6. **Tests** — Add tests for logic that can be tested without the simulator (follow `write-tests`).
7. **Verify** — Run `flutter analyze` and `flutter test`; fix failures.
8. **Review** — Run the `verifier` and `code-reviewer` subagents in parallel. Address Critical findings (max 2 fix cycles, then stop and ask the human).
9. **Follow-up changes** — If the human gives feedback after testing (e.g. "it looks too small"), summarise the proposed change and wait for approval before editing.
10. **Summarize** — What changed, the manual simulator checklist, and anything deferred. If the feature is in `docs/feature-backlog.md`, update its status and the "Current state of the game" section.

## Failure behaviour

- Stop on analyzer errors or failing tests; report and propose a fix.
- Do not delete or skip failing tests without explicit approval.

## Examples

- "Make enemy birds fly in from the right and end the game on contact"
- "Let the player shoot bullets that destroy enemies"
