# Feature backlog

Maintained by the `plan-feature` skill. Ideas are evaluated on Fit, Fun, Effort, Risk, and Readiness (1–5 each; higher is better) and given a verdict: **Build now**, **Defer**, or **Drop**.

Statuses: `Idea` → `Evaluated` → `Ready` (specced) → `In progress` → `Done`, or `Dropped`.

## Product direction

_Not yet decided. `plan-feature` will ask and record answers here._

- Target audience / difficulty:
- Goal (hobby, portfolio, App Store release):
- Platforms:

## Current state of the game

- **Core loop:** tap to flap; gravity pulls the bird down. Hitting the ground, a pipe, or an enemy ends the run.
- **Pipes:** a pipe pair spawns every 4 s (first one immediately) with a random gap position.
- **Enemies:** one red bird spawns in each pipe gap; 4 HP, flashes when hit, removed at 0 HP.
- **Shooting:** the joystick aims the bird and auto-fires (20 shots/s, 2 damage per bullet).
- **Score:** +1 per second survived. Killing enemies and passing pipes give nothing.
- **Flow:** main menu → countdown → play → pause menu (resume with countdown) → game over (restart or main menu).
- **Visuals:** background cycles day/night every 30 s. No audio.

## Known gaps and tech debt

- `flutter analyze` reports 3 issues: `enemy.dart` imports `flame/src/...` and `vector_math` directly; `gameUtil.dart` isn't snake_case.
- No tests: `test/widget_test.dart` is fully commented out, so `flutter test` fails.
- `isGameOver` / `isGameStarted` on `FlappyActionGame` are never updated.
- `startGame` uses `Future.delayed` for timing.
- `ScoreDisplay.updateScoreDisplay` (spritesheet digits) is unused; the score renders as plain text.
- Leftover commented-out code in overlays, `PauseButton`, and `FlappyActionGame`.

## Ideas

| Idea | Status | Fit | Fun | Effort | Risk | Ready | Verdict | Notes |
|------|--------|-----|-----|--------|------|-------|---------|-------|
| Score for enemy kills / pipes passed | Idea | | | | | | | Combat currently has no reward |
| Enemy death effect | Idea | | | | | | | Enemies just vanish at 0 HP |
| Persistent high score | Idea | | | | | | | Likely needs `shared_preferences` |
| Difficulty ramp over time | Idea | | | | | | | Spawn period and speeds are constant |
| Sound effects | Idea | | | | | | | Needs `flame_audio` and assets |

## Decisions log

_Newest first. One line per decision: date, idea, verdict, reason._
