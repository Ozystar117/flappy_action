import 'package:flappy_action/util/audio_util.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingMusic implements MusicPlayer {
  final calls = <String>[];

  @override
  void play(String file, double volume) => calls.add('play $file $volume');

  @override
  void pause() => calls.add('pause');

  @override
  void resume() => calls.add('resume');

  @override
  void stop() => calls.add('stop');
}

void main() {
  tearDown(() {
    AudioUtil.player = null;
    AudioUtil.music = null;
  });

  test('is silent until sounds are loaded', () {
    expect(() {
      AudioUtil.flap();
      AudioUtil.kill();
      AudioUtil.hit();
      AudioUtil.die();
      AudioUtil.playMenuMusic();
      AudioUtil.playGameMusic();
      AudioUtil.pauseMusic();
      AudioUtil.stopMusic();
    }, returnsNormally);
  });

  test('each sound plays its own file', () {
    final played = <String>[];
    AudioUtil.player = (file, volume) => played.add(file);

    AudioUtil.flap();
    AudioUtil.kill();
    AudioUtil.hit();
    AudioUtil.die();
    AudioUtil.countdown(3);
    AudioUtil.countdown(2);
    AudioUtil.countdown(1);
    AudioUtil.countdownGo();

    expect(played, [
      'flap.wav',
      'enemy_kill.wav',
      'player_hit.wav',
      'player_death.wav',
      'countdown_3.wav',
      'countdown_2.wav',
      'countdown_1.wav',
      'countdown_go.wav',
    ]);
  });

  group('music', () {
    late _RecordingMusic music;

    setUp(() {
      music = _RecordingMusic();
      AudioUtil.music = music;
    });

    test('each track plays its own file quietly', () {
      AudioUtil.playMenuMusic();
      AudioUtil.playGameMusic();

      expect(music.calls, ['play menu.m4a 0.25', 'play background.m4a 0.25']);
    });

    test('a paused game track resumes instead of starting over', () {
      AudioUtil.playGameMusic();
      AudioUtil.pauseMusic();
      AudioUtil.playGameMusic();

      expect(music.calls, ['play background.m4a 0.25', 'pause', 'resume']);
    });

    test('a stopped game track starts over', () {
      AudioUtil.playGameMusic();
      AudioUtil.pauseMusic();
      AudioUtil.stopMusic();
      AudioUtil.playGameMusic();

      expect(music.calls, [
        'play background.m4a 0.25',
        'pause',
        'stop',
        'play background.m4a 0.25',
      ]);
    });

    test('a paused menu track is not resumed as the game track', () {
      AudioUtil.playMenuMusic();
      AudioUtil.pauseMusic();
      AudioUtil.playGameMusic();

      expect(music.calls, [
        'play menu.m4a 0.25',
        'pause',
        'play background.m4a 0.25',
      ]);
    });

    test('pause and stop do nothing when no track is playing', () {
      AudioUtil.pauseMusic();
      AudioUtil.stopMusic();

      expect(music.calls, isEmpty);
    });
  });
}
