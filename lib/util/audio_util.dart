import 'dart:async';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

/// Plays one looping music track at a time.
abstract class MusicPlayer {
  void play(String file, double volume);
  void pause();
  void resume();
  void stop();
}

class _FlameMusicPlayer implements MusicPlayer {
  // Each FlameAudio.bgm call is several awaited steps; queue them so a pause
  // can't land in the middle of a play that is still starting
  Future<void> _queue = Future.value();

  @override
  void play(String file, double volume) =>
      _enqueue(() => FlameAudio.bgm.play(file, volume: volume));

  @override
  void pause() => _enqueue(FlameAudio.bgm.pause);

  @override
  void resume() => _enqueue(FlameAudio.bgm.resume);

  @override
  void stop() => _enqueue(FlameAudio.bgm.stop);

  void _enqueue(Future<void> Function() action) {
    _queue = _queue.then((_) async {
      try {
        await action();
      } catch (error) {
        debugPrint('Music error: $error');
      }
    });
  }
}

class AudioUtil {
  static const String _flap = 'flap.wav';
  static const String _kill = 'enemy_kill.wav';
  static const String _hit = 'player_hit.wav';
  static const String _death = 'player_death.wav';
  static const String _countdownGo = 'countdown_go.wav';
  static const List<int> _countdownNumbers = [3, 2, 1];
  static const String _menuMusic = 'menu.m4a';
  static const String _gameMusic = 'background.m4a';

  static const double _flapVolume = 0.5;
  static const double _killVolume = 0.8;
  static const double _hitVolume = 1.0;
  static const double _deathVolume = 0.8;
  static const double _countdownVolume = 0.6;
  static const double _countdownGoVolume = 0.8;
  static const double _musicVolume = 0.25;

  // Ambient on iOS: silenced by the silent switch and mixes with music from
  // other apps instead of stopping it
  static final AudioContext _audioContext = AudioContext(
    iOS: AudioContextIOS(category: AVAudioSessionCategory.ambient),
    android: const AudioContextAndroid(
      contentType: AndroidContentType.sonification,
      usageType: AndroidUsageType.game,
      audioFocus: AndroidAudioFocus.none,
    ),
  );

  // Null until load() completes, so nothing plays in tests
  static void Function(String file, double volume)? _player;

  @visibleForTesting
  static set player(void Function(String file, double volume)? player) =>
      _player = player;

  // Null until load() completes, like _player
  static MusicPlayer? _music;
  static String? _currentMusic;
  static bool _musicPaused = false;

  @visibleForTesting
  static set music(MusicPlayer? music) {
    _music = music;
    _currentMusic = null;
    _musicPaused = false;
  }

  // Longest wait for a sound to finish before its player is disposed anyway
  static const Duration _maxSoundLength = Duration(seconds: 2);

  static Future<void> load() async {
    try {
      await FlameAudio.audioCache.loadAll([
        _flap,
        _kill,
        _hit,
        _death,
        for (final number in _countdownNumbers) _countdownFile(number),
        _countdownGo,
        _menuMusic,
        _gameMusic,
      ]);
      await FlameAudio.bgm.initialize(audioContext: _audioContext);
      _player = _playWithFlameAudio;
      _music = _FlameMusicPlayer();
    } catch (error) {
      // Sound is polish; stay silent rather than stop the game from loading
      debugPrint('Sound effects disabled: $error');
    }
  }

  static void playMenuMusic() => _playMusic(_menuMusic);

  /// Resumes the game track if it was paused, otherwise starts it over.
  static void playGameMusic() {
    final music = _music;
    if (music == null) return;
    if (_currentMusic == _gameMusic && _musicPaused) {
      _musicPaused = false;
      music.resume();
    } else {
      _playMusic(_gameMusic);
    }
  }

  static void pauseMusic() {
    final music = _music;
    if (music == null || _currentMusic == null || _musicPaused) return;
    _musicPaused = true;
    music.pause();
  }

  static void stopMusic() {
    final music = _music;
    if (music == null || _currentMusic == null) return;
    _currentMusic = null;
    _musicPaused = false;
    music.stop();
  }

  static void _playMusic(String file) {
    final music = _music;
    if (music == null) return;
    _currentMusic = file;
    _musicPaused = false;
    music.play(file, _musicVolume);
  }

  static void flap() => _play(_flap, _flapVolume);
  static void kill() => _play(_kill, _killVolume);
  static void hit() => _play(_hit, _hitVolume);
  static void die() => _play(_death, _deathVolume);

  /// Plays the beep for 3, 2, or 1.
  static void countdown(int number) =>
      _play(_countdownFile(number), _countdownVolume);
  static void countdownGo() => _play(_countdownGo, _countdownGoVolume);

  static String _countdownFile(int number) => 'countdown_$number.wav';

  static void _play(String file, double volume) => _player?.call(file, volume);

  static void _playWithFlameAudio(String file, double volume) {
    unawaited(_playAndDispose(file, volume));
  }

  // FlameAudio.play creates a new player per call and never disposes it
  static Future<void> _playAndDispose(String file, double volume) async {
    try {
      final player = await FlameAudio.play(
        file,
        volume: volume,
        audioContext: _audioContext,
      );
      await player.onPlayerComplete.first.timeout(
        _maxSoundLength,
        onTimeout: () {},
      );
      await player.dispose();
    } catch (error) {
      debugPrint('Could not play $file: $error');
    }
  }
}
