import 'dart:math';

import 'package:flame/components.dart';
import 'package:flappy_action/components/obstacles/pipe.dart';
import 'package:flappy_action/util/gameUtil.dart';

class PipePair extends PositionComponent {
  late final Pipe topPipe;
  late final Pipe bottomPipe;

  PipePair({required super.position});

  @override
  onLoad() {
    topPipe = Pipe(
      position: Vector2(0, 0),
      size: GameUtil.getRelativeSize(
        1,
        Random().nextDouble() * 5 + 2,
      ), // random height between 2 and 7
      isTop: true,
    );

    bottomPipe = Pipe(
      position: Vector2(0, topPipe.size.y + GameUtil.getRelativeY(2)),
      size: Vector2(
        GameUtil.getRelativeX(1),
        GameUtil.screenSize.y - (topPipe.size.y + GameUtil.getRelativeY(2)),
      ),
      isTop: false,
    );

    parent!.addAll([topPipe, bottomPipe]);
  }

  @override
  update(double dt) {
    super.update(dt);

    position.x -= GameUtil.getRelativeX(2) * dt;

    topPipe.position.x = position.x;
    bottomPipe.position.x = position.x;

    if (topPipe.position.x < -topPipe.size.x) {
      parent!.removeAll([topPipe, bottomPipe]);
      removeFromParent();
    }
  }
}
