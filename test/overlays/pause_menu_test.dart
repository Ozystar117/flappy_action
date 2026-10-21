import 'package:flame/flame.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flappy_action/game/flappy_action_game.dart';
import 'package:flappy_action/overlays/pause_menu.dart';
import 'package:flappy_action/util/audio_util.dart';
import 'package:flappy_action/util/sprite_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Counts resumeGame calls instead of touching the engine.
class _FakeGame extends FlappyActionGame {
  int resumeCalls = 0;

  @override
  void resumeGame() => resumeCalls++;
}

void main() {
  setUpAll(() async {
    Flame.images.add(SpriteUtil.spriteSheet, await generateImage(512, 512));
  });

  tearDown(() => AudioUtil.player = null);

  testWidgets('tapping resume flaps and resumes the game', (tester) async {
    final played = <String>[];
    AudioUtil.player = (file, volume) => played.add(file);
    final game = _FakeGame();
    await tester.pumpWidget(MaterialApp(home: PauseMenu(game: game)));
    await tester.pump(); // SpriteWidget shows its sprite on the next frame

    await tester.tap(find.byType(GestureDetector));

    expect(played, ['flap.wav']);
    expect(game.resumeCalls, 1);
  });
}
