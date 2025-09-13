import 'dart:math';

import 'package:flame/components.dart';
import 'package:flappy_action/components/birds/enemy.dart';
import 'package:flappy_action/components/obstacles/pipe.dart';
import 'package:flappy_action/util/gameUtil.dart';

class PipePair extends PositionComponent {
  late final Pipe topPipe;
  late final Pipe bottomPipe;
  late final Enemy enemy;
  late final double gapHeight = GameUtil.getRelativeY(2);

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
      position: Vector2(0, topPipe.size.y + gapHeight),
      size: Vector2(
        GameUtil.getRelativeX(1),
        GameUtil.screenSize.y - (topPipe.size.y + gapHeight),
      ),
      isTop: false,
    );

    spawnEnemyInGap();

    parent!.addAll([topPipe, bottomPipe]);
  }

  @override
  update(double dt) {
    super.update(dt);

    position.x -= GameUtil.getRelativeX(2) * dt;

    // keep pipes in place
    topPipe.position.x = position.x;
    bottomPipe.position.x = position.x;

    // Keep enemy in place
    enemy.position.x = position.x;

    if (topPipe.position.x < -topPipe.size.x) {
      parent!.removeAll([topPipe, bottomPipe]);
      if (enemy.parent != null) {
        enemy.removeFromParent();
      }
      removeFromParent();
    }
  }

  void spawnEnemyInGap() {
    enemy = Enemy(
      size: GameUtil.getRelativeSizeX(0.7),
      position: GameUtil.getRelativePosition(3, 3),
      animationTime: 0.12,
    );

    final gapCenterY = randomBetween(
      topPipe.size.y,
      topPipe.size.y + gapHeight,
    );
    enemy.position = Vector2(position.x, gapCenterY);

    parent!.add(enemy);
  }

  double randomBetween(double min, double max) {
    return min + Random().nextDouble() * (max - min);
  }
}
