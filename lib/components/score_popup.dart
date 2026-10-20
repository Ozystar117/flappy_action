import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flappy_action/util/gameUtil.dart';
import 'package:flappy_action/util/sprite_util.dart';
import 'package:flutter/animation.dart';

/// Floating "+N" shown where points were earned.
class ScorePopup extends PositionComponent {
  final int points;

  static const double _popInDuration = 0.15;
  static const double _lifetime = 0.6;
  static const double _rise = 0.5; // grid units
  static const double _digitHeight = 0.4; // grid units

  ScorePopup({required this.points, required super.position})
    : super(anchor: Anchor.center, scale: Vector2.all(0.5));

  @override
  FutureOr<void> onLoad() {
    _layOutSprites();

    addAll([
      ScaleEffect.to(
        Vector2.all(1),
        EffectController(duration: _popInDuration, curve: Curves.easeOutBack),
      ),
      MoveByEffect(
        Vector2(0, -GameUtil.getRelativeY(_rise)),
        EffectController(duration: _lifetime),
      ),
      RemoveEffect(delay: _lifetime),
    ]);
  }

  void _layOutSprites() {
    final digitHeight = GameUtil.getRelativeY(_digitHeight);
    final gap = digitHeight * 0.1;
    final sprites = [
      SpriteUtil.plusSign,
      for (final char in points.toString().split(''))
        SpriteUtil.getTinyDigitSprite(int.parse(char)),
    ];
    // One scale for every sprite keeps the plus at its pixel size relative
    // to the digits
    final pixelScale = digitHeight / SpriteUtil.tinyDigit0.srcSize.y;
    var x = 0.0;

    for (final sprite in sprites) {
      final spriteSize = sprite.srcSize * pixelScale;
      add(
        SpriteComponent(
          sprite: sprite,
          size: spriteSize,
          position: Vector2(x, (digitHeight - spriteSize.y) / 2),
        ),
      );
      x += spriteSize.x + gap;
    }

    // Size to the sprites so Anchor.center centres the whole "+N"
    size = Vector2(x - gap, digitHeight);
  }
}
