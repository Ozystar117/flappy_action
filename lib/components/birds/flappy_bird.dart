import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flappy_action/components/birds/bird.dart';
import 'package:flappy_action/util/gameUtil.dart';
import 'package:flappy_action/util/sprite_util.dart';

class FlappyBird extends Bird {
  late final JoystickComponent joystick;

  late Vector2 velocity = Vector2.all(0);
  // late Vector2 acceleration = Vector2(0, GameUtil.getRelativeHeight(10));

  final double gravity = GameUtil.getRelativeX(5);

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
    // Prevent the bird from going off the screen: to be removed
    if (position.y > GameUtil.grid * 10) {
      position.y = GameUtil.grid * 10;
    }
    velocity.y += gravity * dt;
    position.y += velocity.y * dt;

    // Update rotation based on joystick
    if (joystick.delta.length > 0.1) {
      angle = atan2(joystick.delta.y, joystick.delta.x);
    } else {
      angle = 0;
    }

    super.update(dt);
  }

  void jump() {
    velocity.y = -GameUtil.getRelativeHeight(3);
  }
}
