import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flappy_action/util/gameUtil.dart';
import 'package:flutter/material.dart';

/// Floating "+N" shown where points were earned.
class ScorePopup extends TextComponent {
  static const double _popInDuration = 0.15;
  static const double _lifetime = 0.6;
  static const double _rise = 0.5; // grid units
  static const double _fontSize = 0.4; // grid units

  ScorePopup({required int points, required super.position})
    : super(
        text: '+$points',
        anchor: Anchor.center,
        scale: Vector2.all(0.5),
        textRenderer: TextPaint(
          style: TextStyle(
            color: Colors.white,
            fontSize: GameUtil.getRelativeY(_fontSize),
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset:
                    const Offset(1, 1) *
                    GameUtil.getRelativeY(_fontSize * 0.05),
              ),
            ],
          ),
        ),
      );

  @override
  FutureOr<void> onLoad() {
    // TextComponent has no paint to fade, so it pops in, rises, and is removed.
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
}
