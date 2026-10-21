import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flappy_action/components/birds/bird.dart';
import 'package:flappy_action/components/bullet.dart';
import 'package:flappy_action/components/score_popup.dart';
import 'package:flappy_action/game/flappy_action_game.dart';
import 'package:flappy_action/util/audio_util.dart';
import 'package:flappy_action/util/sprite_util.dart';

class Enemy extends Bird with HasGameReference<FlappyActionGame> {
  double health = 4;

  static const int killPoints = 5;
  static const double _deathDuration = 0.5;
  static const double _deathFadeDuration = 0.2;

  bool _isDying = false;
  bool get isDying => _isDying;
  OpacityEffect? _flash;

  Enemy({
    required super.size,
    required super.position,
    required super.animationTime,
  });

  @override
  FutureOr<void> onLoad() {
    sprites = [SpriteUtil.redBird1, SpriteUtil.redBird2, SpriteUtil.redBird3];
    super.onLoad();

    // Flip the enemy to face the opposite direction
    flipHorizontally();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (_isDying) return;
    if (other is Bullet) {
      health -= other.damage;

      if (health <= 0) {
        _die();
      } else {
        _flash?.removeFromParent();
        _flash = OpacityEffect.fadeOut(
          EffectController(alternate: true, duration: 0.1, repeatCount: 1),
        );
        add(_flash!);
      }
    }
  }

  void _die() {
    _isDying = true;

    // Held in a field because a flash added this same frame isn't in
    // `children` yet; it would otherwise fight the fade-out.
    _flash?.removeFromParent();
    // The killing shot usually lands mid-flash, while the enemy is dimmed.
    opacity = 1;
    removeAll(children.whereType<CircleHitbox>());

    game.scoreDisplay.addPoints(killPoints);
    AudioUtil.kill();
    parent?.add(ScorePopup(points: killPoints, position: position.clone()));

    // Fade only at the end so the spin and shrink stay visible.
    addAll([
      RotateEffect.by(2 * pi, EffectController(duration: _deathDuration)),
      OpacityEffect.fadeOut(
        EffectController(
          duration: _deathFadeDuration,
          startDelay: _deathDuration - _deathFadeDuration,
        ),
      ),
      ScaleEffect.to(
        Vector2.zero(),
        EffectController(duration: _deathDuration),
        onComplete: removeFromParent,
      ),
    ]);
  }
}
