import 'package:flame/game.dart';
import 'package:flappy_action/game/flappy_action_game.dart';
import 'package:flappy_action/overlays/countdown.dart';
import 'package:flappy_action/overlays/game_over_menu.dart';
import 'package:flappy_action/overlays/main_menu.dart';
import 'package:flappy_action/overlays/pause_menu.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    GameWidget<FlappyActionGame>.controlled(
      gameFactory: FlappyActionGame.new,
      overlayBuilderMap: {
        'mainMenu': (_, FlappyActionGame game) => MainMenu(game: game),
        'pauseMenu': (_, FlappyActionGame game) => PauseMenu(game: game),
        'gameOverMenu': (_, FlappyActionGame game) => GameOverMenu(game: game),
        'countdown': (_, FlappyActionGame game) => CountdownOverlay(game: game),
      },
      initialActiveOverlays: ['mainMenu'],
    ),
  );
}
