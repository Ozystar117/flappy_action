import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flappy_action/components/birds/bird.dart';
import 'package:flappy_action/components/birds/enemy.dart';
import 'package:flappy_action/components/bullet.dart';
import 'package:flappy_action/components/obstacles/pipe.dart';
import 'package:flappy_action/game/flappy_action_game.dart';
import 'package:flappy_action/util/gameUtil.dart';
import 'package:flappy_action/util/sprite_util.dart';

class FlappyBird extends Bird with HasGameReference<FlappyActionGame> {
  late final JoystickComponent joystick;

  late Vector2 velocity = Vector2.all(0);
  // late Vector2 acceleration = Vector2(0, GameUtil.getRelativeHeight(10));

  final double gravity = GameUtil.getRelativeX(5);

  // Shooting properties
  double _lastShotTime = 0.0;
  final double _shootCooldown =
      0.05; // 50ms between shots (20 shots per second)

  FlappyBird({
    required super.size,
    required super.position,
    required super.animationTime,
    required this.joystick,
  });

  @override
  FutureOr<void> onLoad() {
    sprites = [
      SpriteUtil.yellowBird1,
      SpriteUtil.yellowBird2,
      SpriteUtil.yellowBird3,
    ];
    super.onLoad();
  }

  @override
  update(double dt) {
    if (position.y > GameUtil.bottom - size.y / 2) {
      game.isGameOver = true;
      return;
    }
    velocity.y += gravity * dt;
    position.y += velocity.y * dt;

    // Update rotation based on joystick
    if (joystick.delta.length > 0.1) {
      angle = atan2(joystick.delta.y, joystick.delta.x);

      // Shoot continuously while joystick is active
      shoot();
    } else {
      angle = 0;
    }

    super.update(dt);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Enemy || other is Pipe) {
      game.isGameOver = true;
    }
  }

  void jump() {
    velocity.y = -GameUtil.getRelativeHeight(1.5);
  }

  void shoot() {
    final currentTime = game.currentTime();
    if (currentTime - _lastShotTime >= _shootCooldown) {
      _lastShotTime = currentTime;

      // Create bullet in the direction the bird is facing
      final bulletDirection = Vector2(cos(angle), sin(angle));
      final bullet = Bullet(
        position: position.clone(), // Bullet comes from center of bird
        direction: bulletDirection,
        speed: GameUtil.getRelativeX(15),
      );

      // Add bullet to the world
      parent?.add(bullet);
    }
  }
}
