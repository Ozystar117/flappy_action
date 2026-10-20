import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flappy_action/components/score_popup.dart';
import 'package:flappy_action/util/gameUtil.dart';
import 'package:flappy_action/util/sprite_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    Flame.images.add(SpriteUtil.spriteSheet, await generateImage(512, 512));
    GameUtil.initialize(deviceSize: Vector2(400, 800));
  });

  Future<ScorePopup> addPopup(FlameGame game, {int points = 5}) async {
    final popup = ScorePopup(points: points, position: Vector2(100, 300));
    await game.ensureAdd(popup);
    return popup;
  }

  List<SpriteComponent> spriteChildren(ScorePopup popup) =>
      popup.children.whereType<SpriteComponent>().toList();

  testWithFlameGame('shows a plus sign followed by the digits', (game) async {
    final sprites = spriteChildren(await addPopup(game, points: 15));

    expect(sprites.map((s) => s.sprite), [
      SpriteUtil.plusSign,
      SpriteUtil.smallDigit1,
      SpriteUtil.smallDigit5,
    ]);
  });

  testWithFlameGame('sprites keep their aspect ratio', (game) async {
    for (final sprite in spriteChildren(await addPopup(game, points: 1234))) {
      final srcSize = sprite.sprite!.srcSize;
      expect(
        sprite.size.x / sprite.size.y,
        closeTo(srcSize.x / srcSize.y, 1e-6),
      );
    }
  });

  testWithFlameGame('sizes itself to its sprites so it stays centred', (
    game,
  ) async {
    final popup = await addPopup(game);
    final sprites = spriteChildren(popup);

    expect(popup.anchor, Anchor.center);
    expect(sprites.first.position.x, 0);
    expect(popup.size.x, closeTo(sprites.last.toRect().right, 1e-3));
    expect(popup.size.y, closeTo(GameUtil.getRelativeY(0.4), 1e-3));
  });

  testWithFlameGame('pops in to full size', (game) async {
    final popup = await addPopup(game);
    expect(popup.scale.x, closeTo(0.5, 1e-6));

    game.update(0.15);
    expect(popup.scale.x, closeTo(1, 1e-3));
  });

  testWithFlameGame('rises half a grid unit, then is removed', (game) async {
    final popup = await addPopup(game);
    final rise = GameUtil.getRelativeY(0.5);

    game.update(0.3);
    expect(popup.position.y, closeTo(300 - rise / 2, 1e-3));

    game.update(0.31);
    await game.ready();
    expect(popup.isMounted, isFalse);
  });
}
