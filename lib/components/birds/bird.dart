import 'dart:async';

import 'package:flame/components.dart';

class Bird extends SpriteAnimationComponent {
  final double animationTime;
  late final List<Sprite> sprites;

  Bird({
    required super.size,
    required super.position,
    required this.animationTime,
  });

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    animation = SpriteAnimation.spriteList(sprites, stepTime: animationTime);
  }
}
