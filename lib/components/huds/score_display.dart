import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flappy_action/util/gameUtil.dart';
import 'package:flappy_action/util/sprite_util.dart';
import 'package:flutter/material.dart';

class ScoreDisplay extends PositionComponent {
  int score = 0;
  late TextComponent scoreText;
  final List<SpriteComponent> digits = [];

  ScoreDisplay()
    : super(
        position: Vector2(GameUtil.width / 2, GameUtil.getRelativeY(1)),
        anchor: Anchor.topCenter,
      );

  @override
  FutureOr<void> onLoad() {
    // initScore();
    updateScoreDisplay();
  }

  @override
  void update(double dt) {
    super.update(dt);
    incrementScore();
    updateScoreDisplay();
  }

  void initScore() {
    scoreText = TextComponent(
      text: '0',
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(scoreText);
  }

  void incrementScore() {
    score++;
    // scoreText.text = score.toString();
    updateScoreDisplay();
  }

  void updateScoreDisplay() {
    // Remove old digit components
    for (final digit in digits) {
      digit.removeFromParent();
    }
    digits.clear();

    // Convert score to string and create digit sprites
    final scoreString = score.toString();
    final digitWidth = GameUtil.getRelativeX(0.3); // Adjust size as needed
    final digitHeight = GameUtil.getRelativeY(0.3);

    // Calculate total width to center the score
    final totalWidth = digitWidth * scoreString.length;
    final startX =
        -totalWidth / 2; // Center relative to this component's position

    for (int i = 0; i < scoreString.length; i++) {
      final digit = int.parse(scoreString[i]);
      final digitComponent = SpriteComponent(
        sprite: SpriteUtil.getDigitSprite(digit),
        size: Vector2(digitWidth, digitHeight),
        position: Vector2(
          startX + (i * digitWidth),
          0, // Relative to this component's position
        ),
      );

      add(digitComponent);
      digits.add(digitComponent);
    }
  }
}
