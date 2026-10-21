import 'package:flappy_action/util/audio_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() => AudioUtil.player = null);

  test('is silent until sounds are loaded', () {
    expect(() {
      AudioUtil.flap();
      AudioUtil.kill();
      AudioUtil.hit();
      AudioUtil.die();
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
}
