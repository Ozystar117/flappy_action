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
- **Enemies:** one red bird spawns in each pipe gap; 4 HP, flashes when hit. At 0 HP it spins a full turn and shrinks over 0.5 s, fading only in the last 0.2 s (harmless while dying) and a "+5" floats up.
- **Shooting:** the joystick aims the bird and auto-fires (20 shots/s, 2 damage per bullet).
- **Score:** +1 per second survived and +5 per enemy kill, shown top centre with the spritesheet digits; pops on each gain and pulses bigger when crossing a multiple of 10. Passing pipes gives nothing.
- **Countdown:** "Get Ready" bobs while 3-2-1 each punch in from 2× (2 grid units tall at rest); 3 s total.
- **Flow:** main menu → countdown → play → pause menu (resume with countdown) → game over (restart or main menu).
- **Visuals:** background cycles day/night every 30 s. No audio.

## Known gaps and tech debt

- `flutter analyze` reports 1 issue: `gameUtil.dart` isn't snake_case.
- Test coverage is limited to `ScoreDisplay`, `Enemy`, `ScorePopup`, and the countdown overlay. `flame_test` is pinned to 2.0.x because 2.2.3+ requires Flame 1.36+; upgrading Flame is a separate decision.
- `pubspec.lock` is gitignored, so dependency versions aren't pinned across machines.
- `isGameOver` / `isGameStarted` on `FlappyActionGame` are never updated.
- `startGame` uses `Future.delayed` for timing.
- Possible bug (unconfirmed): pausing while the countdown is showing. The countdown's Flutter timer keeps running under the pause menu and `countdownComplete()` would resume the engine; `resumeGame()` then re-adds an already-active `countdown` overlay. Check whether the pause button is tappable through the countdown overlay.
- Possible bug (unconfirmed): nothing stops the bird flying above the screen, and top pipes start at `y = 0`, so the player may be able to sit above the pipes indefinitely.
- Leftover commented-out code in overlays, `PauseButton`, and `FlappyActionGame`.
- `assets/images/spritesheet.png` is WebP data with a `.png` extension. Flutter decodes it fine; macOS `sips` needs `-s format png` before cropping.

## Ideas

| Idea | Status | Fit | Fun | Effort | Risk | Ready | Verdict | Notes |
|------|--------|-----|-----|--------|------|-------|---------|-------|
| Sprite-sheet score digits | Done | 3 | 3 | 5 | 5 | 5 | Build now | See [spec](#sprite-sheet-score-digits) |
| Score for enemy kills / pipes passed | Done | 5 | 4 | 4 | 4 | 5 | Build now | Kills only. See [spec](#enemy-death-pop--kill-reward) |
| Enemy death effect | Done | 5 | 4 | 5 | 4 | 5 | Build now | See [spec](#enemy-death-pop--kill-reward) |
| Persistent high score | Idea | | | | | | | Likely needs `shared_preferences` |
| Difficulty ramp over time | Idea | | | | | | | Spawn period and speeds are constant |
| Sound effects | Idea | | | | | | | Needs `flame_audio` and assets |
| Score pop + milestone pulse | Done | 3 | 4 | 5 | 5 | 5 | Build now | See [spec](#score-pop--milestone-pulse) |
| Countdown punch-in | Done | 3 | 3 | 5 | 4 | 5 | Build now | See [spec](#countdown-punch-in) |
| Menu entrances + pressable buttons | Idea | | | | | | | M. Title slide/bounce, shared press-scale button widget across 4 overlays, idle tap-hand bob; can remove leftover commented-out code |
| Sprite "+5" popup | Idea | | | | | | | Swap the kill popup's plain text for spritesheet digits and the "+" sprite (both still to be extracted) |
| Bird tilt | Idea | | | | | | | S. Nose up on flap, nose down when falling; joystick aim still overrides. `flappy_bird.dart` only |
| Hit flash on death | Idea | | | | | | | S. White flash fading into the game-over dim, in `game_over_menu.dart` (engine is paused, so Flutter animation) |
| Game-over score tally | Idea | | | | | | | L. Count-up + NEW badge/medals. Needs a game-over score panel first; pairs with persistent high score |

## Specs

### Enemy death pop + kill reward

**Goal:** killing an enemy feels rewarding — it spins and shrinks away, a "+5" floats up where it died, and the score jumps by 5.

**Acceptance criteria**
- [ ] At 0 HP the enemy snaps back to full opacity (the killing shot usually lands mid-flash), spins a full turn and shrinks to 0 over 0.5 s, fading out only in the last 0.2 s, then is removed.
- [ ] A dying enemy can't end the run: its hitbox is removed and the bird ignores it, even in the frame it died.
- [ ] Bullets hitting a dying enemy are ignored — no second death animation, no flash, no extra points.
- [ ] The killing shot doesn't trigger the hit flash; any running flash is removed so it doesn't fight the fade-out.
- [ ] Each kill adds exactly 5 points, once.
- [ ] A "+5" (plain Flame text) appears where the enemy died, pops in from 0.5× to 1×, drifts up 0.5 grid units over 0.6 s, then is removed.
- [ ] The score pops on a kill; if the kill crosses a multiple of 10 (e.g. 8 → 13) it gets the milestone pulse instead.
- [ ] The +1-per-second timer, digit layout, and existing pop behaviour are unchanged.
- [ ] Pausing freezes the death animation and "+5"; they finish after resume. Restart and main menu leave neither behind.
- [ ] Enemies that leave the screen alive give no points; pipe-pair cleanup still works for living, dying, and dead enemies.

**Design**
- `lib/components/birds/enemy.dart`:
  - Add `HasGameReference<FlappyActionGame>`, a private `_isDying` flag, and `bool get isDying`.
  - In `onCollisionStart`: return early if dying; otherwise apply damage, then either show the existing flash (health > 0) or call `_die()`.
  - `_die()`: set `_isDying`; remove the running flash and the `CircleHitbox`; set `opacity = 1`; call `game.scoreDisplay.addPoints(killPoints)`; add a `ScorePopup` to `parent` at the enemy's position; add `RotateEffect.by(2 * pi)` and `ScaleEffect.to(Vector2.zero())` over 0.5 s (`onComplete: removeFromParent` on the scale effect), and `OpacityEffect.fadeOut` over 0.2 s with a 0.3 s start delay.
  - `static const int killPoints = 5;` `static const double _deathDuration = 0.5;` `static const double _deathFadeDuration = 0.2;`
  - Fix the `flame/src` and `vector_math` imports (clears 2 of the 3 analyzer issues).
- `lib/components/birds/flappy_bird.dart`: ignore `Enemy` collisions when `isDying`.
- `lib/components/huds/score_display.dart`:
  - Add `void addPoints(int points)`: remember the old score, add, redraw, then `_pop(isMilestone: score ~/ 10 > oldScore ~/ 10)`.
  - `incrementScore()` becomes `addPoints(1)` — milestone behaviour for +1 is unchanged.
- New `lib/components/score_popup.dart`:
  - `ScorePopup extends TextComponent` with text `+N`, `Anchor.center`, white bold text with a black shadow, font size 0.4 grid units.
  - Effects: `ScaleEffect.to(1)` from 0.5 over 0.15 s (`easeOutBack`), `MoveByEffect` 0.5 grid units up over 0.6 s, `RemoveEffect(delay: 0.6)`.
  - `TextComponent` has no `HasPaint` in Flame 1.32, so `OpacityEffect` can't fade it.
  - Lives in the world (not the viewport) so it stays where the kill happened.
- No new game states, overlays, sprites, or packages.

**Testable logic**
- `score_display_test`:
  - `addPoints(5)` from 0 → 5 with a normal pop.
  - From 8 → 13 with a milestone pulse.
  - From 10 → 15 with a normal pop.
  - Existing `incrementScore` tests still pass.
- New `test/components/birds/enemy_test.dart` (test game with a `ScoreDisplay`):
  - Two bullets kill the enemy.
  - After the killing hit: score +5, `isDying` true, no `CircleHitbox`, a `ScorePopup` exists.
  - Another bullet changes nothing.
  - Killed mid-flash, it is at full opacity with half a turn and half size at 0.25 s; after 0.5 s it is removed.
- `ScorePopup`: removed after 0.6 s; moved up by 0.5 grid units.

**Manual simulator checklist**
1. Shoot an enemy dead → it spins/shrinks/fades, "+5" floats up, the score jumps by 5 and pops.
2. Fly through a dying enemy → the run continues.
3. Keep firing at a dying enemy → nothing extra happens, no extra points.
4. Cross a multiple of 10 with a kill → bigger pulse.
5. Pause just after a kill → animation freezes; resume → it finishes.
6. Die → restart, and main menu → play → no leftover popups; score starts at 0.
7. Let an enemy scroll off alive → no points.

**Out of scope**
- Sprite digits or a sprite "+" for the popup (planned later).
- Points for passing pipes.
- Sound, particles, screen shake.
- High score.

### Score pop + milestone pulse

**Goal:** the score gives a small pop every time it goes up and a bigger pulse every 10 points, so survival feels like progress.

**Acceptance criteria**
- [ ] Each increment: `ScoreDisplay` scales to 1.1× and back to 1.0× over 0.15 s total.
- [ ] Every multiple of 10: scales to 1.3× and back over 0.25 s total instead.
- [ ] The pulse grows from the top centre (the component's anchor); the score doesn't drift sideways.
- [ ] Scale always settles at exactly 1.0, even if increments overlap — effects never stack.
- [ ] No pop when the score first appears at `0`.
- [ ] While paused, the effect freezes and finishes after resume. Restart and main menu show `0` at normal scale.
- [ ] Scoring rules and digit layout are unchanged.

**Design**
- Change only `lib/components/huds/score_display.dart`.
- In `incrementScore()`, after `updateScoreDisplay()`, call a private `_pop()`:
  - remove any running `ScaleEffect` children and reset `scale` to `Vector2.all(1)` (`ScaleEffect.to` with `alternate` returns to the scale it started from);
  - add `ScaleEffect.to(Vector2.all(target), EffectController(duration: half, alternate: true, curve: Curves.easeOut))`.
- Effect goes on `ScoreDisplay` itself, never on digit children — digits are rebuilt on every increment.
- Tuning as `static const` fields: pop 1.1× / 0.075 s each way; milestone 1.3× / 0.125 s each way; milestone every 10 points.

**Testable logic** (extend `test/components/huds/score_display_test.dart`)
- After `incrementScore()`, a `ScaleEffect` is attached.
- At 9 → 10, advancing by the milestone half-duration reaches ~1.3×; a normal increment reaches ~1.1×.
- After advancing past the effect duration, `scale` is 1.0 and no `ScaleEffect` remains.
- Two increments in quick succession still end at exactly 1.0.
- A freshly loaded `ScoreDisplay` has no `ScaleEffect`.

**Manual simulator checklist**
1. Start a run → `0` appears without a pop; at `1` a subtle pop.
2. Watch `9 → 10` and `19 → 20` → noticeably bigger pulse, digits stay centred.
3. Pause right as the score changes → resume → the pop finishes and size returns to normal.
4. Die → restart → `0` at normal size. Main menu → play → same.
5. Watch for 30+ s → pops feel lively but not distracting.

**Out of scope**
- Colour, glow, or rotation effects; sound.
- Effects on individual digits.
- Changing scoring rules.

### Countdown punch-in

**Goal:** the 3-2-1 countdown builds anticipation — each number punches in and "Get Ready" bobs gently.

**Acceptance criteria**
- [ ] Each number (3, 2, 1) enters by scaling from 2.0× to 1.0× with a slight overshoot while fading in, over 300 ms; the outgoing number fades out.
- [ ] "Get Ready" bobs up and down by 0.1 grid units on a 1 s loop (0.5 s each way).
- [ ] Countdown timing is unchanged: 3 s total, and `countdownComplete()` is called exactly once.
- [ ] Animations play every time the countdown appears: start, restart, and resume after pause.
- [ ] Animation controllers and timers are disposed with the overlay.

**Design**
- Change only `lib/overlays/countdown.dart`. Use Flutter animations — the engine is paused during the countdown, so Flame effects wouldn't run.
- Add `SingleTickerProviderStateMixin`; an `AnimationController` (500 ms, `repeat(reverse: true)`) drives the bob through `AnimatedBuilder` + `Transform.translate`, offset computed from `gridY * 0.1` inside the existing `LayoutBuilder`.
- Wrap the number in `AnimatedSwitcher` (300 ms) with a `transitionBuilder` combining `FadeTransition` and `ScaleTransition` (`Tween(2.0 → 1.0)`, `Curves.easeOutBack`). Key each number with `ValueKey(countdown)`.
- Keep the existing `Timer.periodic` and `_getCountdownSprite`; dispose the controller in `dispose()`.

**Testable logic** (new `test/overlays/countdown_test.dart`, `testWidgets`)
- Use a `FlappyActionGame` subclass that counts `countdownComplete()` calls instead of touching the engine; register a generated stand-in spritesheet as in the score tests.
- Shows `3` initially, `2` after 1 s, `1` after 2 s (advance with `tester.pump(duration)` — never `pumpAndSettle`, the bob repeats forever).
- `countdownComplete()` is called once after 3 s and not again after 4 s.
- No pending timers after the widget is removed (the test framework fails on leaks).

**Manual simulator checklist**
1. Main menu → tap → "Get Ready" bobs; 3, 2, 1 each punch in with a slight overshoot.
2. Countdown still feels like 3 s; the bird doesn't move until it ends.
3. Pause mid-run → resume → countdown animates again.
4. Die → restart → animates again. Main menu → play → animates again.
5. Small and large simulators → numbers stay centred, no clipping during the 2× scale.

**Out of scope**
- A "Go!" frame, sound.
- Moving the countdown to a Flame timer.
- Replacing `_getCountdownSprite`'s `switch`.

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

- 2026-10-20 — Enemy death effect + kill reward — Build now — combat is the game's hook but currently has no payoff; small, low-risk, reuses the score pop.

- 2026-10-20 — Score pop + milestone pulse — Build now — one-file Flame effects episode, felt every second, follows directly from the score-digits episode.
- 2026-10-20 — Countdown punch-in — Build now — one-file Flutter animations episode felt at every start and resume; risk is only in keeping countdown timing intact.
- 2026-10-20 — Pause button press effect — Drop — tapping pauses the engine immediately, so a Flame effect on the button would never play.
- 2026-10-20 — Sprite-sheet score digits — Build now — one-file, low-risk polish visible every run; digits already on the sheet and in `SpriteUtil`; good standalone tutorial segment.
