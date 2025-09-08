import 'dart:math';

import 'package:flame/components.dart';
import 'package:flappy_action/util/gameUtil.dart';
import 'package:flutter/material.dart';

class Bullet extends RectangleComponent with HasGameReference {
  final Vector2 direction;
  final double speed;
  late Vector2 velocity;

  Bullet({
    required super.position,
    required this.direction,
    required this.speed, // Suitable speed for bullets
  }) : super(
         size: GameUtil.getRelativeSize(0.15, 0.05), // Small rectangle bullet
       );

  @override
  Future<void> onLoad() async {
    // Set bullet color - using bright orange for visibility
    paint = Paint()..color = Colors.yellow;

    anchor = Anchor.center;

    // Set velocity based on direction
    velocity = direction.normalized() * speed;

    // Set bullet rotation to match shooting direction
    angle = atan2(direction.y, direction.x);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move the bullet
    position += velocity * dt;

    // Remove bullet if it goes off screen
    if (position.x < -size.x ||
        position.x > GameUtil.width + size.x ||
        position.y < -size.y ||
        position.y > GameUtil.height + size.y) {
      removeFromParent();
    }
  }
}
