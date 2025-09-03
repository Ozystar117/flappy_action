import 'dart:async';

import 'package:flame/components.dart';
import 'package:flappy_action/util/sprite_util.dart';

class Background extends SpriteAnimationComponent {
  late final List<Sprite> sprites;
  final double animationTime; // seconds

  Background({
    required super.size,
    required super.position,
    required this.animationTime,
  });

  @override
  FutureOr<void> onLoad() {
    sprites = [
      SpriteUtil.backgroundDaySprite,
      SpriteUtil.backgroundNightSprite,
    ];

    animation = SpriteAnimation.spriteList(sprites, stepTime: animationTime);
  }
}
