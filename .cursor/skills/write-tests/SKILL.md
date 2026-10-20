---
name: write-tests
description: Adds or updates flame_test and flutter_test tests for Flappy Action game logic, components, and overlays. Use when the user asks for tests, coverage, regression tests, or to test a specific component, state transition, or overlay.
---

# Write tests

## When to use

- Testing state transitions, components, collisions, scoring, spawners, or overlays
- Turning a bug repro into a lasting test

## When not to use

- Visual or feel checks (animation smoothness, sprite crops) — give a manual simulator checklist instead

## Instructions

1. **Set up once** — If `flame_test` isn't in `pubspec.yaml`, add it under `dev_dependencies` (`flutter pub add --dev flame_test`). Replace the commented-out `test/widget_test.dart` with real tests rather than leaving it.
2. **Identify the target** — Behaviour to cover, and which file mirrors it under `test/` (`lib/x/y.dart` → `test/x/y_test.dart`).
3. **Write focused tests**
   - Game logic: `testWithGame<FlappyActionGame>(...)` or `FlameTester`; advance time with `game.update(dt)`.
   - State transitions: call the `FlappyActionGame` method, then assert `game.overlays.isActive(...)`, `game.paused`, and expected children.
   - Overlays: `testWidgets` with the overlay widget and a test game.
   - Cover the happy path plus the key edge case (e.g. pause during countdown, restart after game over).
4. **Keep production code stable** — Only change production code if needed for testability, and call it out.
5. **Run** — Focused file first, then `flutter test`.
6. **Summarize** — What is covered and how to run it.

## Failure behaviour

- Fix flaky or incorrect new tests before finishing.
- Never skip or weaken a failing test without explicit approval.

## Examples

- "Test that pauseGame shows the pause menu and pauses the engine"
- "Test that pipes are removed after leaving the screen"
