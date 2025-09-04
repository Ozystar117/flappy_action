import 'dart:async';

import 'package:flame/sprite.dart';
import 'package:flappy_action/components/birds/bird.dart';
import 'package:flappy_action/util/sprite_util.dart';

class FlappyBird extends Bird {
  late final List<Sprite> sprites;

  FlappyBird({
    required super.size,
    required super.position,
    required super.animationTime,
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
}
