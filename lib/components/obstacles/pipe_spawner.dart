import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flappy_action/components/obstacles/pipe_pair.dart';
import 'package:flappy_action/util/gameUtil.dart';

class PipeSpawner extends SpawnComponent {
  static int numberOfSpawns = 0;

  PipeSpawner()
    : super(
        period: 1,
        factory: (int index) {
          numberOfSpawns++;
          return createPipePair(index);
        },
      );

  @override
  void onLoad() {
    super.onLoad();
    // The spawner will automatically start spawning PipePairs
    // based on the period and factory function
    area = Rectangle.fromLTWH(
      GameUtil.width - GameUtil.getRelativeX(1),
      0,
      0,
      0,
    );
    numberOfSpawns = 0;
  }

  static PipePair createPipePair(int index) {
    return PipePair(
      position: Vector2(GameUtil.width + GameUtil.getRelativeX(1), 0),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // After the first spawn, set the period to 4 seconds
    if (numberOfSpawns > 0) {
      period = 4;
    }
  }

  // int getNumberOfSpawns() {}
}
