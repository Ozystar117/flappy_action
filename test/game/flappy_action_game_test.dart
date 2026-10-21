import 'package:flame_test/flame_test.dart';
import 'package:flappy_action/game/flappy_action_game.dart';
import 'package:flappy_action/util/audio_util.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Skips the real asset loading; registers the game-over overlay that
/// main.dart would normally provide.
class _TestGame extends FlappyActionGame {
  @override
  Future<void> onLoad() async {
    overlays.addEntry('gameOverMenu', (_, _) => const SizedBox());
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<String> played;

  setUp(() {
    played = [];
    AudioUtil.player = (file, volume) => played.add(file);
  });

  tearDown(() => AudioUtil.player = null);

  group('gameOver', () {
    testWithGame<_TestGame>(
      'plays the hit sound, then the death sound',
      _TestGame.new,
      (game) async {
        game.gameOver();
        expect(played, ['player_hit.wav']);

        await Future<void>.delayed(const Duration(milliseconds: 450));
        expect(played, ['player_hit.wav', 'player_death.wav']);
      },
    );

    testWithGame<_TestGame>(
      'plays the sounds once when called twice in a row',
      _TestGame.new,
      (game) async {
        game.gameOver();
        game.gameOver();

        expect(game.overlays.isActive('gameOverMenu'), isTrue);
        expect(game.paused, isTrue);
        expect(played, ['player_hit.wav']);
        game.reset();
      },
    );

    testWithGame<_TestGame>(
      'a quick restart cancels the death sound',
      _TestGame.new,
      (game) async {
        game.gameOver();
        game.reset();

        await Future<void>.delayed(const Duration(milliseconds: 450));
        expect(played, ['player_hit.wav']);
      },
    );
  });
}
