import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flappy_action/util/gameUtil.dart';
import 'package:flappy_action/util/sprite_util.dart';
import 'package:flutter/animation.dart';

class ScoreDisplay extends PositionComponent {
  int score = 0;
  final List<SpriteComponent> digits = [];
  // Timer to track seconds
  double _timeAccumulator = 0.0;
  static const double _scoreInterval = 1.0; // 1 second

  // Pop effect when the score increases; bigger pulse on milestones
  static const double _popScale = 1.1;
  static const double _popHalfDuration = 0.075;
  static const double _milestoneScale = 1.3;
  static const double _milestoneHalfDuration = 0.125;
  static const int _milestoneEvery = 10;
  ScaleEffect? _popEffect;

  ScoreDisplay()
    : super(
        position: Vector2(GameUtil.width / 2, GameUtil.getRelativeY(1)),
        anchor: Anchor.topCenter,
      );

  @override
  FutureOr<void> onLoad() {
    updateScoreDisplay();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Accumulate time
    _timeAccumulator += dt;

    // Check if a second has passed
    if (_timeAccumulator >= _scoreInterval) {
      incrementScore();
      _timeAccumulator = 0.0; // Reset the timer
    }
  }

  void incrementScore() {
    score++;
    updateScoreDisplay();
    _pop();
  }

  void _pop() {
    // ScaleEffect.to with alternate returns to the scale it started from,
    // so reset first or overlapping pops would leave the score enlarged.
    // Pause the old effect too: removal is deferred, so it would otherwise
    // still apply one more update this frame on top of the reset.
    _popEffect
      ?..pause()
      ..removeFromParent();
    scale = Vector2.all(1);

    final isMilestone = score % _milestoneEvery == 0;
    _popEffect = ScaleEffect.to(
      Vector2.all(isMilestone ? _milestoneScale : _popScale),
      EffectController(
        duration: isMilestone ? _milestoneHalfDuration : _popHalfDuration,
        alternate: true,
        curve: Curves.easeOut,
      ),
    );
    add(_popEffect!);
  }

  void updateScoreDisplay() {
    // Remove old digit components
    for (final digit in digits) {
      digit.removeFromParent();
    }
    digits.clear();

    final digitHeight = GameUtil.getRelativeY(0.6);
    final gap = digitHeight * 0.1;
    var x = 0.0;

    for (final char in score.toString().split('')) {
      final sprite = SpriteUtil.getDigitSprite(int.parse(char));
      // Keep each digit's own aspect ratio; the '1' is narrower than the rest
      final digitWidth = digitHeight * sprite.srcSize.x / sprite.srcSize.y;
      final digitComponent = SpriteComponent(
        sprite: sprite,
        size: Vector2(digitWidth, digitHeight),
        position: Vector2(x, 0),
      );

      add(digitComponent);
      digits.add(digitComponent);
      x += digitWidth + gap;
    }

    // Size to the digits so Anchor.topCenter centres the whole score
    size = Vector2(x - gap, digitHeight);
  }
}
