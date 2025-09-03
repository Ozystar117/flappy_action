import 'package:flame/game.dart';
import 'package:flappy_action/game/flappy_action_game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    GameWidget<FlappyActionGame>.controlled(gameFactory: FlappyActionGame.new)
  );
}
