import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flappy_action/components/birds/flappy_bird.dart';
import 'package:flappy_action/game/flappy_action_game.dart';
import 'package:flappy_action/util/audio_util.dart';
import 'package:flappy_action/util/gameUtil.dart';
import 'package:flappy_action/util/sprite_util.dart';
import 'package:flutter_test/flutter_test.dart';

/// Skips the real asset loading and menu setup.
class _TestGame extends FlappyActionGame {
  @override
  Future<void> onLoad() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    Flame.images.add(SpriteUtil.spriteSheet, await generateImage(512, 512));
    GameUtil.initialize(deviceSize: Vector2(400, 800));
  });

  late List<String> played;

  setUp(() {
    played = [];
    AudioUtil.player = (file, volume) => played.add(file);
  });

  tearDown(() => AudioUtil.player = null);

  Future<FlappyBird> addBird(_TestGame game) async {
    final bird = FlappyBird(
      size: Vector2.all(30),
      position: Vector2(200, 400),
      animationTime: 0.12,
      joystick: JoystickComponent(
        knob: CircleComponent(radius: 5),
        background: CircleComponent(radius: 10),
      ),
    );
    await game.ensureAdd(bird);
    return bird;
  }

  testWithGame<_TestGame>('flaps with a sound during play', _TestGame.new, (
    game,
  ) async {
    final bird = await addBird(game);

    bird.jump();

    expect(played, ['flap.wav']);
  });

  testWithGame<_TestGame>('is silent while paused', _TestGame.new, (
    game,
  ) async {
    final bird = await addBird(game);
    game.pauseEngine();

    bird.jump();

    expect(played, isEmpty);
  });
}
