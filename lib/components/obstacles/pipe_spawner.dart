import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flappy_action/components/obstacles/pipe_pair.dart';
import 'package:flappy_action/util/gameUtil.dart';

class PipeSpawner extends SpawnComponent {
  PipeSpawner()
    : super(
        period: 4, // Spawn pipes every 4 seconds
        factory: (int index) => PipePair(
          position: Vector2(
            GameUtil.width +
                GameUtil.getRelativeX(1), // Start off-screen to the right
            0, // Y position will be calculated in PipePair
          ),
        ),
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
  }
}
