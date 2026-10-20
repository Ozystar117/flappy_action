import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flappy_action/components/score_popup.dart';
import 'package:flappy_action/util/gameUtil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    GameUtil.initialize(deviceSize: Vector2(400, 800));
  });

  testWithFlameGame('shows the points with a plus sign', (game) async {
    final popup = ScorePopup(points: 5, position: Vector2(100, 300));
    await game.ensureAdd(popup);

    expect(popup.text, '+5');
  });

  testWithFlameGame('pops in to full size', (game) async {
    final popup = ScorePopup(points: 5, position: Vector2(100, 300));
    await game.ensureAdd(popup);
    expect(popup.scale.x, closeTo(0.5, 1e-6));

    game.update(0.15);
    expect(popup.scale.x, closeTo(1, 1e-3));
  });

  testWithFlameGame('rises half a grid unit, then is removed', (game) async {
    final popup = ScorePopup(points: 5, position: Vector2(100, 300));
    await game.ensureAdd(popup);
    final rise = GameUtil.getRelativeY(0.5);

    game.update(0.3);
    expect(popup.position.y, closeTo(300 - rise / 2, 1e-3));

    game.update(0.31);
    await game.ready();
    expect(popup.isMounted, isFalse);
  });
}
