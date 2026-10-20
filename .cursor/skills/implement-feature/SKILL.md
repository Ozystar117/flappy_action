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

1. **Clarify scope** — Restate the feature and acceptance criteria. If something critical is ambiguous (e.g. how an enemy moves), ask once; otherwise state assumptions.
2. **Read neighbours** — Skim `FlappyActionGame` and the components nearest to the change. Follow `AGENTS.md` and `.cursor/rules/`.
3. **Plan briefly** — List the files to add or change. Keep it small; no drive-by refactors.
4. **Implement**
   - New state transitions → new method on `FlappyActionGame`.
   - New sprites → follow `add-sprite`.
   - New overlays → follow `add-overlay`.
   - Gameplay objects in `world`, HUD in the viewport; anything spawned is cleaned up by `reset()` or `removeFromParent()`.
5. **Tests** — Add tests for logic that can be tested without the simulator (follow `write-tests`).
6. **Verify** — Run `flutter analyze` and `flutter test`; fix failures.
7. **Review** — Run the `verifier` and `code-reviewer` subagents in parallel. Address Critical findings (max 2 fix cycles, then stop and ask the human).
8. **Summarize** — What changed, the manual simulator checklist, and anything deferred.

## Failure behaviour

- Stop on analyzer errors or failing tests; report and propose a fix.
- Do not delete or skip failing tests without explicit approval.

## Examples

- "Make enemy birds fly in from the right and end the game on contact"
- "Let the player shoot bullets that destroy enemies"
