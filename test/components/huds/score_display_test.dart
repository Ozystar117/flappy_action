import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flappy_action/components/huds/score_display.dart';
import 'package:flappy_action/util/gameUtil.dart';
import 'package:flappy_action/util/sprite_util.dart';
import 'package:flutter_test/flutter_test.dart';

/// Increments from inside `update`, like the real per-second timer does, so
/// tests can make pops overlap.
class _IncrementOnUpdateScoreDisplay extends ScoreDisplay {
  bool incrementOnNextUpdate = false;

  @override
  void update(double dt) {
    if (incrementOnNextUpdate) {
      incrementOnNextUpdate = false;
      incrementScore();
    }
    super.update(dt);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    Flame.images.add(SpriteUtil.spriteSheet, await generateImage(512, 512));
    GameUtil.initialize(deviceSize: Vector2(400, 800));
  });

  Future<ScoreDisplay> addScoreDisplay(FlameGame game, {int score = 0}) async {
    final scoreDisplay = ScoreDisplay()..score = score;
    await game.ensureAdd(scoreDisplay);
    return scoreDisplay;
  }

  List<SpriteComponent> digitChildren(ScoreDisplay scoreDisplay) =>
      scoreDisplay.children.whereType<SpriteComponent>().toList();

  List<ScaleEffect> scaleEffects(ScoreDisplay scoreDisplay) =>
      scoreDisplay.children.whereType<ScaleEffect>().toList();

  Future<void> increment(FlameGame game, ScoreDisplay scoreDisplay) async {
    scoreDisplay.incrementScore();
    await game.ready();
  }

  group('ScoreDisplay', () {
    testWithFlameGame('renders one digit sprite per digit', (game) async {
      expect(digitChildren(await addScoreDisplay(game)), hasLength(1));
      expect(
        digitChildren(await addScoreDisplay(game, score: 10)),
        hasLength(2),
      );
      expect(
        digitChildren(await addScoreDisplay(game, score: 100)),
        hasLength(3),
      );
    });

    testWithFlameGame('updates digits when the score increments', (game) async {
      final scoreDisplay = await addScoreDisplay(game, score: 9);

      scoreDisplay.incrementScore();
      await game.ready();

      expect(scoreDisplay.score, 10);
      final digits = digitChildren(scoreDisplay);
      expect(digits, hasLength(2));
      expect(digits[0].sprite, SpriteUtil.digit1);
      expect(digits[1].sprite, SpriteUtil.digit0);
    });

    testWithFlameGame('narrow 1s make the score narrower', (game) async {
      final ones = await addScoreDisplay(game, score: 111);
      final eights = await addScoreDisplay(game, score: 888);

      expect(ones.size.x, lessThan(eights.size.x));
    });

    testWithFlameGame('digits keep their sprite aspect ratio', (game) async {
      final scoreDisplay = await addScoreDisplay(game, score: 1234567890);

      for (final digit in digitChildren(scoreDisplay)) {
        final srcSize = digit.sprite!.srcSize;
        expect(
          digit.size.x / digit.size.y,
          closeTo(srcSize.x / srcSize.y, 1e-6),
        );
      }
    });

    testWithFlameGame('sizes itself to its digits so it stays centred', (
      game,
    ) async {
      final scoreDisplay = await addScoreDisplay(game, score: 42);
      final digits = digitChildren(scoreDisplay);

      expect(scoreDisplay.anchor, Anchor.topCenter);
      expect(digits.first.position.x, 0);
      expect(scoreDisplay.size.x, closeTo(digits.last.toRect().right, 1e-3));
      expect(scoreDisplay.size.y, closeTo(digits.first.size.y, 1e-3));
    });

    testWithFlameGame('adds a point every second', (game) async {
      final scoreDisplay = await addScoreDisplay(game);

      game.update(0.5);
      expect(scoreDisplay.score, 0);

      game.update(0.5);
      expect(scoreDisplay.score, 1);
    });
  });

  group('ScoreDisplay pop', () {
    testWithFlameGame('does not pop when first shown', (game) async {
      final scoreDisplay = await addScoreDisplay(game);

      expect(scaleEffects(scoreDisplay), isEmpty);
      expect(scoreDisplay.scale, Vector2.all(1));
    });

    testWithFlameGame('pops when the score increments', (game) async {
      final scoreDisplay = await addScoreDisplay(game);

      await increment(game, scoreDisplay);

      expect(scaleEffects(scoreDisplay), hasLength(1));
      game.update(0.075);
      expect(scoreDisplay.scale.x, closeTo(1.1, 1e-3));
    });

    testWithFlameGame('pulses bigger every 10 points', (game) async {
      final scoreDisplay = await addScoreDisplay(game, score: 9);

      await increment(game, scoreDisplay);

      game.update(0.125);
      expect(scoreDisplay.scale.x, closeTo(1.3, 1e-3));
    });

    testWithFlameGame('settles back to normal size', (game) async {
      final scoreDisplay = await addScoreDisplay(game, score: 9);

      await increment(game, scoreDisplay);
      game.update(0.3);
      await game.ready();

      expect(scoreDisplay.scale.x, closeTo(1, 1e-6));
      expect(scoreDisplay.scale.y, closeTo(1, 1e-6));
      expect(scaleEffects(scoreDisplay), isEmpty);
    });

    testWithFlameGame('overlapping pops do not stack', (game) async {
      final scoreDisplay = await addScoreDisplay(game);

      await increment(game, scoreDisplay);
      game.update(0.05);
      await increment(game, scoreDisplay);

      expect(scaleEffects(scoreDisplay), hasLength(1));

      game.update(0.075);
      expect(scoreDisplay.scale.x, closeTo(1.1, 1e-3));

      game.update(0.3);
      await game.ready();
      expect(scoreDisplay.scale.x, closeTo(1, 1e-6));
      expect(scaleEffects(scoreDisplay), isEmpty);
    });

    testWithFlameGame('overlapping pops from update do not drift', (
      game,
    ) async {
      final scoreDisplay = _IncrementOnUpdateScoreDisplay();
      await game.ensureAdd(scoreDisplay);

      for (var i = 0; i < 5; i++) {
        scoreDisplay.incrementOnNextUpdate = true;
        game.update(0.05);
      }
      game.update(0.3);
      game.update(0.3);
      await game.ready();

      expect(scoreDisplay.score, 5);
      expect(scoreDisplay.scale.x, closeTo(1, 1e-6));
      expect(scoreDisplay.scale.y, closeTo(1, 1e-6));
    });
  });
}
