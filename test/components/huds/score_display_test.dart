import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flappy_action/components/huds/score_display.dart';
import 'package:flappy_action/util/gameUtil.dart';
import 'package:flappy_action/util/sprite_util.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
