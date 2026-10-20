import 'package:flame/flame.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flappy_action/game/flappy_action_game.dart';
import 'package:flappy_action/overlays/countdown.dart';
import 'package:flappy_action/util/sprite_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Counts countdownComplete calls instead of touching the engine.
class _FakeGame extends FlappyActionGame {
  int completeCalls = 0;

  @override
  void countdownComplete() => completeCalls++;
}

void main() {
  setUpAll(() async {
    Flame.images.add(SpriteUtil.spriteSheet, await generateImage(512, 512));
  });

  Finder number(int value) => find.byKey(ValueKey(value));

  double scaleOf(WidgetTester tester, int value) => tester
      .widget<Transform>(
        find
            .ancestor(of: number(value), matching: find.byType(Transform))
            .first,
      )
      .transform
      .entry(0, 0);

  double opacityOf(WidgetTester tester, int value) => tester
      .widget<Opacity>(
        find.ancestor(of: number(value), matching: find.byType(Opacity)).first,
      )
      .opacity;

  Future<_FakeGame> pumpCountdown(WidgetTester tester) async {
    final game = _FakeGame();
    await tester.pumpWidget(MaterialApp(home: CountdownOverlay(game: game)));
    return game;
  }

  group('CountdownOverlay', () {
    testWidgets('counts down 3, 2, 1', (tester) async {
      await pumpCountdown(tester);
      await tester.pump();
      expect(number(3), findsOneWidget);
      expect(number(2), findsNothing);

      await tester.pump(const Duration(seconds: 1));
      expect(number(2), findsOneWidget);

      // The outgoing number is gone once its transition finishes
      await tester.pump(const Duration(milliseconds: 350));
      expect(number(3), findsNothing);

      await tester.pump(const Duration(milliseconds: 650));
      expect(number(1), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('the first number punches in too', (tester) async {
      await pumpCountdown(tester);
      await tester.pump();

      expect(scaleOf(tester, 3), closeTo(2.0, 1e-3));
      expect(opacityOf(tester, 3), closeTo(0.0, 1e-3));

      // Fully visible while still enlarged, so the shrink can be seen
      await tester.pump(const Duration(milliseconds: 45));
      expect(opacityOf(tester, 3), closeTo(1.0, 1e-3));
      expect(scaleOf(tester, 3), greaterThan(1.3));

      await tester.pump(const Duration(milliseconds: 255));
      expect(scaleOf(tester, 3), closeTo(1.0, 1e-3));
      expect(opacityOf(tester, 3), closeTo(1.0, 1e-3));

      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('the outgoing number fades out without growing', (
      tester,
    ) async {
      await pumpCountdown(tester);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.pump(const Duration(milliseconds: 150));
      expect(scaleOf(tester, 3), 1.0);
      expect(opacityOf(tester, 3), inExclusiveRange(0.0, 1.0));
      // Halfway through, the incoming number has overshot below normal size
      expect(scaleOf(tester, 2), lessThan(1.0));

      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('every number has the same height', (tester) async {
      await pumpCountdown(tester);
      await tester.pump();
      final heightOf3 = tester.getSize(number(3)).height;
      final widthOf3 = tester.getSize(number(3)).width;

      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.getSize(number(1)).height, heightOf3);
      expect(tester.getSize(number(1)).width, lessThan(widthOf3));

      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('completes exactly once after 3 seconds', (tester) async {
      final game = await pumpCountdown(tester);

      await tester.pump(const Duration(milliseconds: 2900));
      expect(game.completeCalls, 0);

      await tester.pump(const Duration(milliseconds: 100));
      expect(game.completeCalls, 1);

      await tester.pump(const Duration(seconds: 2));
      expect(game.completeCalls, 1);

      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('stops counting when removed early', (tester) async {
      final game = await pumpCountdown(tester);

      await tester.pump(const Duration(seconds: 1));
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 5));

      expect(game.completeCalls, 0);
    });
  });
}
