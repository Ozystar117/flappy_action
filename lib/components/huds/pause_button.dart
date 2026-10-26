import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flappy_action/game/flappy_action_game.dart';
import 'package:flappy_action/util/gameUtil.dart';
import 'package:flappy_action/util/sprite_util.dart';

class PauseButton extends SpriteComponent
    with TapCallbacks, HasGameReference<FlappyActionGame> {
  PauseButton()
    : super(
        size: GameUtil.getRelativeSizeX(0.7),
        position: Vector2(
          GameUtil.right - GameUtil.getRelativeWidth(1),
          GameUtil.getRelativeHeight(1),
        ),
      );

  @override
  FutureOr<void> onLoad() {
    sprite = SpriteUtil.pauseButtonSprite;
    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.pauseGame();
    super.onTapDown(event);
  }
}
