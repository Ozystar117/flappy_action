import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flappy_action/components/obstacles/pipe_pair.dart';
import 'package:flappy_action/game/flappy_action_game.dart';
import 'package:flappy_action/util/gameUtil.dart';
import 'package:flappy_action/util/sprite_util.dart';
import 'package:flutter_test/flutter_test.dart';

/// Skips the real asset loading and menu setup.
class _TestGame extends FlappyActionGame {
  @override
  Future<void> onLoad() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    Flame.images.add(SpriteUtil.spriteSheet, await generateImage(512, 512));
    GameUtil.initialize(deviceSize: Vector2(400, 800));
  });

  Future<PipePair> addPipePair(_TestGame game) async {
    final pipePair = PipePair(position: Vector2(300, 0));
    await game.ensureAdd(pipePair);
    return pipePair;
  }

  testWithGame<_TestGame>(
    'the enemy always spawns fully inside the gap',
    _TestGame.new,
    (game) async {
      // The gap position and enemy height are random; enough spawns that an
      // enemy touching a pipe would show up
      for (var i = 0; i < 200; i++) {
        final pipePair = await addPipePair(game);
        final enemy = pipePair.enemy;
        final gapTop = pipePair.topPipe.toAbsoluteRect().bottom;
        final gapBottom = pipePair.bottomPipe.toAbsoluteRect().top;
        final enemyRect = enemy.toAbsoluteRect();

        // Positions are stored as float32
        expect(enemyRect.top, greaterThanOrEqualTo(gapTop - 1e-3));
        expect(enemyRect.bottom, lessThanOrEqualTo(gapBottom + 1e-3));

        game.removeAll([
          pipePair,
          pipePair.topPipe,
          pipePair.bottomPipe,
          enemy,
        ]);
        await game.ready();
      }
    },
  );

  testWithGame<_TestGame>(
    'the enemy stays centred on the pipes as they move',
    _TestGame.new,
    (game) async {
      final pipePair = await addPipePair(game);
      final enemy = pipePair.enemy;

      // The pipes are only moved into place by the pair's update
      game.update(0.5);

      expect(pipePair.position.x, lessThan(300));
      expect(
        enemy.absoluteCenter.x,
        closeTo(pipePair.topPipe.toAbsoluteRect().center.dx, 0.001),
      );
    },
  );
}
