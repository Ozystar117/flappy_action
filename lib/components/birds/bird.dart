import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

abstract class Bird extends SpriteAnimationComponent with CollisionCallbacks {
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

    add(CircleHitbox());
  }
}
