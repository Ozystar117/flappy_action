import 'package:flame_test/flame_test.dart';
import 'package:flappy_action/game/flappy_action_game.dart';
import 'package:flappy_action/util/audio_util.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Skips the real asset loading and gameplay components; registers the
/// overlays that main.dart would normally provide.
class _TestGame extends FlappyActionGame {
  @override
  Future<void> onLoad() async {
    for (final name in ['mainMenu', 'pauseMenu', 'gameOverMenu', 'countdown']) {
      overlays.addEntry(name, (_, _) => const SizedBox());
    }
  }

  @override
  void addComponentsToWorld() {}

  @override
  void addComponentsToViewport() {}
}

class _RecordingMusic implements MusicPlayer {
  final calls = <String>[];

  @override
  void play(String file, double volume) => calls.add('play $file');

  @override
  void pause() => calls.add('pause');

  @override
  void resume() => calls.add('resume');

  @override
  void stop() => calls.add('stop');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<String> played;
  late _RecordingMusic music;

  setUp(() {
    played = [];
    AudioUtil.player = (file, volume) => played.add(file);
    music = _RecordingMusic();
    AudioUtil.music = music;
  });

  tearDown(() {
    AudioUtil.player = null;
    AudioUtil.music = null;
  });

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

  group('music', () {
    testWithGame<_TestGame>(
      'start stops the menu track; the game track waits for the countdown',
      _TestGame.new,
      (game) async {
        AudioUtil.playMenuMusic();
        await game.startGame();
        expect(music.calls, ['play menu.m4a', 'stop']);

        game.countdownComplete();
        expect(music.calls, ['play menu.m4a', 'stop', 'play background.m4a']);
      },
    );

    testWithGame<_TestGame>(
      'pause pauses the game track and the resume countdown continues it',
      _TestGame.new,
      (game) async {
        game.countdownComplete();
        game.pauseGame();
        game.resumeGame();
        expect(music.calls, ['play background.m4a', 'pause']);

        game.countdownComplete();
        expect(music.calls, ['play background.m4a', 'pause', 'resume']);
      },
    );

    testWithGame<_TestGame>('game over stops the music once', _TestGame.new, (
      game,
    ) async {
      game.countdownComplete();
      game.gameOver();
      game.gameOver();

      expect(music.calls, ['play background.m4a', 'stop']);
      game.reset();
    });

    testWithGame<_TestGame>(
      'restart starts the game track from the beginning',
      _TestGame.new,
      (game) async {
        game.countdownComplete();
        game.gameOver();
        game.reset();
        await game.startGame();
        game.countdownComplete();

        expect(music.calls, [
          'play background.m4a',
          'stop',
          'play background.m4a',
        ]);
      },
    );

    testWithGame<_TestGame>(
      'a new game after leaving a paused one starts the game track over',
      _TestGame.new,
      (game) async {
        game.countdownComplete();
        game.pauseGame();
        game.goToMainMenu();
        await game.startGame();
        game.countdownComplete();

        expect(music.calls, [
          'play background.m4a',
          'pause',
          'play menu.m4a',
          'stop',
          'play background.m4a',
        ]);
      },
    );

    testWithGame<_TestGame>('main menu plays the menu track', _TestGame.new, (
      game,
    ) async {
      game.countdownComplete();
      game.pauseGame();
      game.goToMainMenu();

      expect(music.calls, ['play background.m4a', 'pause', 'play menu.m4a']);
    });
  });
}
