import 'dart:async';

import 'package:flappy_action/components/birds/bird.dart';
import 'package:flappy_action/util/sprite_util.dart';

class Enemy extends Bird {
  Enemy({
    required super.size,
    required super.position,
    required super.animationTime,
  });

  @override
  FutureOr<void> onLoad() {
    sprites = [SpriteUtil.redBird1, SpriteUtil.redBird2, SpriteUtil.redBird3];
    super.onLoad();

    // Flip the enemy to face the opposite direction
    flipHorizontally();
  }
}
