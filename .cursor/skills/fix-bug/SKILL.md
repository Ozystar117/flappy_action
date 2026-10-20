---
name: fix-bug
description: Reproduces, root-causes, and fixes Flappy Action bugs with a minimal change and a regression test when practical. Use when the user reports a bug, crash, exception, wrong gameplay behaviour, broken pause/resume/restart, collision issue, or failing test.
---

# Fix bug

## When to use

- Crashes, exceptions, wrong gameplay or UI behaviour, broken state transitions, failing tests

## When not to use

- New features → `implement-feature`
- Environment/tooling failures (disk space, Xcode, simulator) — diagnose directly, no code change

## Instructions

1. **Capture the symptom** — Expected vs actual, repro steps, error text or stack trace.
2. **Trace the state** — Most bugs here are state-transition bugs. Walk the path through `FlappyActionGame` methods: which overlays are active, whether the engine is paused, which components exist in `world` and the viewport.
3. **Root cause** — Identify the exact line or ordering problem; avoid speculative rewrites.
4. **Get approval** — Give a concise summary of the cause and the proposed fix (files and approach), then stop until the human explicitly approves. Steps 1–3 are read-only and need no approval.
5. **Minimal fix** — Change only what is required; match existing patterns.
6. **Regression test** — Add a `flame_test` test that would have caught it when practical (follow `write-tests`).
7. **Verify** — `flutter analyze` and `flutter test`; then run the `verifier` subagent.
8. **Summarize** — Cause, fix, test coverage, manual simulator repro to confirm, residual risk.

## Failure behaviour

- If the bug can't be reproduced or fixed after a reasonable attempt, stop with a diagnosis and next options.
- Do not silence failures by weakening tests or wrapping code in broad `try/catch`.

## Examples

- "After restarting from game over, two birds appear"
- "Score keeps increasing while the pause menu is open"
