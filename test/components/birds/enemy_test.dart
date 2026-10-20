import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flappy_action/components/birds/enemy.dart';
import 'package:flappy_action/components/bullet.dart';
import 'package:flappy_action/components/huds/score_display.dart';
import 'package:flappy_action/components/score_popup.dart';
import 'package:flappy_action/game/flappy_action_game.dart';
import 'package:flappy_action/util/gameUtil.dart';
import 'package:flappy_action/util/sprite_util.dart';
import 'package:flutter_test/flutter_test.dart';

/// Skips the real asset loading and menu setup; only provides a score display.
class _TestGame extends FlappyActionGame {
  @override
  Future<void> onLoad() async {
    scoreDisplay = ScoreDisplay();
    await add(scoreDisplay);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    Flame.images.add(SpriteUtil.spriteSheet, await generateImage(512, 512));
    GameUtil.initialize(deviceSize: Vector2(400, 800));
  });

  Future<Enemy> addEnemy(_TestGame game) async {
    final enemy = Enemy(
      size: Vector2.all(30),
      position: Vector2(200, 400),
      animationTime: 0.12,
    );
    await game.ensureAdd(enemy);
    return enemy;
  }

  void hitNow(Enemy enemy) => enemy.onCollisionStart(
    {},
    Bullet(position: Vector2.zero(), direction: Vector2(1, 0), speed: 1),
  );

  Future<void> hit(_TestGame game, Enemy enemy) async {
    hitNow(enemy);
    await game.ready();
  }

  testWithGame<_TestGame>(
    'a non-lethal hit flashes without scoring',
    _TestGame.new,
    (game) async {
      final enemy = await addEnemy(game);

      await hit(game, enemy);

      expect(enemy.health, 2);
      expect(enemy.isDying, isFalse);
      expect(enemy.children.whereType<OpacityEffect>(), hasLength(1));
      expect(game.scoreDisplay.score, 0);
    },
  );

  testWithGame<_TestGame>(
    'the killing hit scores and starts dying',
    _TestGame.new,
    (game) async {
      final enemy = await addEnemy(game);

      await hit(game, enemy);
      await hit(game, enemy);

      expect(enemy.isDying, isTrue);
      expect(game.scoreDisplay.score, Enemy.killPoints);
      expect(enemy.children.whereType<CircleHitbox>(), isEmpty);
      expect(enemy.children.whereType<RotateEffect>(), hasLength(1));
      expect(enemy.children.whereType<ScaleEffect>(), hasLength(1));
      expect(game.children.whereType<ScorePopup>(), hasLength(1));
      // Only the death fade remains; the earlier hit flash is gone.
      expect(enemy.children.whereType<OpacityEffect>(), hasLength(1));
    },
  );

  testWithGame<_TestGame>(
    'two hits in the same frame leave no flash behind',
    _TestGame.new,
    (game) async {
      final enemy = await addEnemy(game);

      hitNow(enemy);
      hitNow(enemy);
      await game.ready();

      expect(enemy.isDying, isTrue);
      expect(enemy.children.whereType<OpacityEffect>(), hasLength(1));
    },
  );

  testWithGame<_TestGame>('hits on a dying enemy are ignored', _TestGame.new, (
    game,
  ) async {
    final enemy = await addEnemy(game);
    await hit(game, enemy);
    await hit(game, enemy);

    await hit(game, enemy);

    expect(game.scoreDisplay.score, Enemy.killPoints);
    expect(game.children.whereType<ScorePopup>(), hasLength(1));
    expect(enemy.children.whereType<ScaleEffect>(), hasLength(1));
    expect(enemy.children.whereType<OpacityEffect>(), hasLength(1));
  });

  testWithGame<_TestGame>(
    'is removed once the death animation ends',
    _TestGame.new,
    (game) async {
      final enemy = await addEnemy(game);
      await hit(game, enemy);
      await hit(game, enemy);

      game.update(0.2);
      await game.ready();
      expect(enemy.isMounted, isTrue);

      game.update(0.15);
      await game.ready();
      expect(enemy.isMounted, isFalse);
    },
  );
}
