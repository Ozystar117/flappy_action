# AGENTS.md — Flappy Action

Instructions for AI coding agents working in this repository.

## Product

Flappy Action is a Flappy Bird–style action game: the player flies through pipes, steers with a joystick, and fights enemy birds with bullets. Built with Flutter and the Flame engine (`flame: ^1.32.0`). Portrait-only; primary test target is the iOS Simulator.

## Layout

| Path | Role |
|------|------|
| `lib/main.dart` | `GameWidget` setup and the overlay registry (`overlayBuilderMap`) |
| `lib/game/flappy_action_game.dart` | `FlappyActionGame` — owns all game state and transitions |
| `lib/components/` | Flame components: `birds/`, `obstacles/`, `huds/`, plus `background.dart`, `bullet.dart` |
| `lib/overlays/` | Flutter widget overlays: main menu, pause menu, game over, countdown |
| `lib/util/gameUtil.dart` | `GameUtil` — 10×10 screen grid for responsive sizing/positioning |
| `lib/util/sprite_util.dart` | `SpriteUtil` — every sprite, cut from `assets/images/spritesheet.png` |
| `test/` | Tests (none yet — see `write-tests`) |
| `docs/feature-backlog.md` | Feature ideas, evaluations, decisions, and current game state |

## Commands

```bash
flutter pub get
flutter run            # launches on the booted simulator
flutter analyze
flutter test
dart format .
```

There is no CI. `flutter analyze` + `flutter test` are the local gate.

## Architecture

- **State lives in `FlappyActionGame`.** Transitions go through its methods: `startGame`, `restartGame`, `pauseGame`, `resumeGame`, `countdown`, `countdownComplete`, `gameOver`, `goToMainMenu`, `reset`. Components and overlays call these; they do not touch `overlays` or `pauseEngine`/`resumeEngine` directly.
- **Overlay names** (`mainMenu`, `pauseMenu`, `gameOverMenu`, `countdown`) must match the keys in `main.dart`.
- **World vs viewport:** gameplay objects (bird, pipes, background) go in `world`; HUD (score, pause button, joystick) goes in `cameraComponent.viewport`.
- **Sizing:** use `GameUtil` grid helpers, never raw pixel values. `GameUtil` is initialised in `FlappyActionGame.onLoad`.
- **Sprites:** use `SpriteUtil` only. The spritesheet is loaded in `FlappyActionGame.onLoad`, so access sprites from a component's `onLoad`, not from top-level code.

## Working agreements

- One feature branch + PR per feature (matches existing history). Human merges.
- Prefer the smallest change that meets the request; match existing patterns.
- Delete superseded code instead of commenting it out — git keeps history.
- New files use `snake_case.dart` (`gameUtil.dart` is a legacy exception).
- Do not hand-edit `ios/`, `android/`, or other platform folders unless asked; Flutter's automatic migrations are fine but commit them separately.
- Detailed conventions: `.cursor/rules/`.

## Agent roster

| Task | How |
|------|-----|
| Brainstorm, evaluate, or spec a feature | Skill `plan-feature` (records in `docs/feature-backlog.md`) |
| New gameplay feature | Skill `implement-feature` |
| Bug / regression | Skill `fix-bug` |
| New sprite from the spritesheet | Skill `add-sprite` |
| New menu / screen overlay | Skill `add-overlay` |
| Tests | Skill `write-tests` |
| Checks + commit message + PR description | `/prepare-pr` |
| Post-change verification | Subagent `verifier` (readonly) |
| Diff review | Subagent `code-reviewer` (readonly) |
| Broad codebase search | Built-in Explore subagent |

## Definition of done

- Change matches the request and the architecture above
- `flutter analyze` is clean and `flutter test` passes
- `verifier` has run after any change under `lib/`; `code-reviewer` has run for substantial diffs
- Gameplay changes come with a short manual simulator checklist
- Summary of what changed and how to verify
