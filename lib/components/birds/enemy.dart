import 'dart:async';

import 'package:flame/effects.dart';
import 'package:flame/src/components/position_component.dart';
import 'package:flappy_action/components/birds/bird.dart';
import 'package:flappy_action/components/bullet.dart';
import 'package:flappy_action/util/sprite_util.dart';
import 'package:vector_math/vector_math.dart';

class Enemy extends Bird {
  double health = 4;

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
    if (other is Bullet) {
      health -= other.damage;

      add(
        OpacityEffect.fadeOut(
          EffectController(alternate: true, duration: 0.1, repeatCount: 1),
        ),
      );

      if (health <= 0) {
        removeFromParent();
      }
    }
  }
}
