import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flappy_action/components/birds/bird.dart';
import 'package:flappy_action/util/sprite_util.dart';

class FlappyBird extends Bird {
  late final List<Sprite> sprites;
  late final JoystickComponent joystick;

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
    // Update rotation based on joystick
    if (joystick.delta.length > 0.1) {
      angle = atan2(joystick.delta.y, joystick.delta.x);
    } else {
      angle = 0;
    }

    super.update(dt);
  }
}
