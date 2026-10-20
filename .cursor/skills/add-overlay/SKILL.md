---
name: add-overlay
description: Creates a new Flutter overlay (menu, screen, dialog, HUD panel) for Flappy Action, registers it in main.dart, and wires it through FlappyActionGame methods. Use when the user wants a new menu, screen, settings page, dialog, or overlay.
---

# Add overlay

## When to use

- New menus or screens shown over the game (settings, high scores, level select, tutorial)

## When not to use

- In-game HUD drawn by Flame (score, pause button) → Flame component in `components/huds/` via `implement-feature`
- Changing an existing overlay's layout only → edit it directly

## Instructions

A new overlay is a feature: before creating or editing any file, give a concise summary (overlay name, files to change, the `FlappyActionGame` methods for entering and leaving it) and wait for the human's explicit approval. When this skill runs as a step of `implement-feature`, that skill's approval covers it.

1. **Pick a name** — camelCase overlay key (e.g. `settingsMenu`); file `lib/overlays/settings_menu.dart`; class `SettingsMenu`.
2. **Create the widget** — Copy the structure of the closest existing overlay (`pause_menu.dart` for a modal, `main_menu.dart` for a full screen): `StatelessWidget` with `final FlappyActionGame game`, `LayoutBuilder` 10×10 grid, `SafeArea`, `SpriteWidget` buttons.
3. **Register it** — Add the key to `overlayBuilderMap` in `lib/main.dart`.
4. **Add game methods** — For each way in and out of the overlay, add or reuse a `FlappyActionGame` method that sets overlays and the engine state together (see `pauseGame`, `goToMainMenu`). Overlay buttons call only these methods.
5. **Wire the entry point** — Call the new method from wherever the overlay is opened (another overlay's button or a component).
6. **Verify** — `flutter analyze`; run `verifier`. Give a simulator checklist covering open, every button, and returning to the previous state.

## Failure behaviour

- If the transition semantics are unclear (should the game pause? reset?), ask before implementing.

## Examples

- "Add a settings menu reachable from the main menu"
- "Show a 'new high score' screen before the game over menu"
