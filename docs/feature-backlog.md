# Feature backlog

Maintained by the `plan-feature` skill. Ideas are evaluated on Fit, Fun, Effort, Risk, and Readiness (1–5 each; higher is better) and given a verdict: **Build now**, **Defer**, or **Drop**.

Statuses: `Idea` → `Evaluated` → `Ready` (specced) → `In progress` → `Done`, or `Dropped`.

## Product direction

- Target audience / difficulty: casual — short, forgiving runs
- Goal: YouTube tutorial series — favour self-contained, visible features that make clear episodes and readable code
- Platforms: not decided (iOS Simulator is the current test target)

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
- `assets/images/spritesheet.png` is WebP data with a `.png` extension. Flutter decodes it fine; macOS `sips` needs `-s format png` before cropping.

## Ideas

| Idea | Status | Fit | Fun | Effort | Risk | Ready | Verdict | Notes |
|------|--------|-----|-----|--------|------|-------|---------|-------|
| Sprite-sheet score digits | Ready | 3 | 3 | 5 | 5 | 5 | Build now | See [spec](#sprite-sheet-score-digits) |
| Score for enemy kills / pipes passed | Idea | | | | | | | Combat currently has no reward |
| Enemy death effect | Idea | | | | | | | Enemies just vanish at 0 HP |
| Persistent high score | Idea | | | | | | | Likely needs `shared_preferences` |
| Difficulty ramp over time | Idea | | | | | | | Spawn period and speeds are constant |
| Sound effects | Idea | | | | | | | Needs `flame_audio` and assets |

## Specs

### Sprite-sheet score digits

**Goal:** the in-game score shows the classic outlined Flappy Bird digits from the spritesheet instead of plain text.

**Acceptance criteria**
- [ ] The score renders with `SpriteUtil` digit sprites, horizontally centred at its current position (top centre, 1 grid unit down).
- [ ] Each digit keeps its source aspect ratio — no stretching on any screen size.
- [ ] The narrow `1` (8 px wide vs 12 px for other digits) uses its own width, so spacing looks even in scores like `11` or `101`.
- [ ] Digit components are rebuilt only when the score changes, not every frame.
- [ ] Score starts at `0` on every new run, restart, and return from the main menu.
- [ ] Scoring rules are unchanged (+1 per second).
- [ ] `TextComponent` / `TextPaint` and their imports are removed from `ScoreDisplay`; no commented-out code remains.

**Design**
- Change only `lib/components/huds/score_display.dart`. `ScoreDisplay` stays in the viewport with `Anchor.topCenter`.
- Replace `initScore()` and `scoreText` with a single digit-rendering method (rework the existing `updateScoreDisplay()`), called from `onLoad` and `incrementScore`.
- Size each digit from a fixed height: `height = GameUtil.getRelativeY(0.6)`, `width = height * sprite.srcSize.x / sprite.srcSize.y`.
- Gap between digits: `height * 0.1`.
- After laying out the digits, set the component's `size` to `(totalWidth, height)` and position children from `x = 0`, so `Anchor.topCenter` does the centring.
- No new `FlappyActionGame` methods, overlays, sprites, or packages.

**Testable logic** (first use of `flame_test` — follow `write-tests`)
- Score `0` → 1 digit child; `10` → 2; `100` → 3.
- After `incrementScore()`, the children reflect the new score.
- The total width of `111` is less than that of `888`.
- Each digit child's `size.x / size.y` matches its sprite's `srcSize.x / srcSize.y`.

**Manual simulator checklist**
1. Start a run → `0` appears top centre, crisp and not stretched.
2. Watch it pass `9 → 10` and `10 → 11` → stays centred; the `1`s are evenly spaced.
3. Wait past 30 s for the night background → digits remain readable.
4. Pause → score is visible and frozen under the dimmed menu; resume → countdown → continues from the same value.
5. Die → restart → score resets to `0`. Die → main menu → play → `0`.
6. Repeat step 1 on a small (iPhone SE) and a large (Pro Max) simulator → no distortion.

**Out of scope**
- The small digits for the game-over score panel.
- Best/high score.
- Changing scoring rules.
- Replacing `SpriteUtil.getDigitSprite`'s `switch` with a list.

## Decisions log

_Newest first. One line per decision: date, idea, verdict, reason._

- 2026-10-20 — Sprite-sheet score digits — Build now — one-file, low-risk polish visible every run; digits already on the sheet and in `SpriteUtil`; good standalone tutorial segment.
