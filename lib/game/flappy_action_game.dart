import 'dart:async';

import 'package:flame/components.dart' hide Timer;
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flappy_action/components/background.dart';
import 'package:flappy_action/components/birds/bird.dart';
import 'package:flappy_action/components/birds/flappy_bird.dart';
import 'package:flappy_action/components/huds/pause_button.dart';
import 'package:flappy_action/components/obstacles/pipe_spawner.dart';
import 'package:flappy_action/components/huds/score_display.dart';
import 'package:flappy_action/util/audio_util.dart';
import 'package:flappy_action/util/gameUtil.dart';
import 'package:flappy_action/util/sprite_util.dart';
import 'package:flutter/material.dart';

class FlappyActionGame extends FlameGame
    with TapCallbacks, HasCollisionDetection {
  @override
  final World world = World();

  late CameraComponent cameraComponent = CameraComponent(world: world)
    ..viewfinder.anchor = Anchor.topLeft;

  late Bird player;

  late JoystickComponent joystick;

  late PipeSpawner pipeSpawner;

  late ScoreDisplay scoreDisplay;

  late PauseButton pauseButton = PauseButton();

  bool isGameOver = false;
  bool isGameStarted = false;

  static const Duration _deathSoundDelay = Duration(milliseconds: 400);
  // A Dart timer because the engine is paused at game over
  Timer? _deathSoundTimer;

  @override
  void onLoad() async {
    await images.loadAll([SpriteUtil.spriteSheet]);
    await AudioUtil.load();
    AudioUtil.playMenuMusic();
    Flame.device.setPortraitUpOnly(); // lock to portrait
    GameUtil.initialize(deviceSize: size);

    // Create joystick after GameUtil is initialized
    joystick = JoystickComponent(
      position: Vector2(
        GameUtil.right -
            GameUtil.getRelativeX(1.5), // 1.5 grid units from right
        GameUtil.bottom -
            GameUtil.getRelativeY(1.5), // 1.5 grid units from bottom
      ),
      knob: CircleComponent(
        radius: GameUtil.getRelativeX(1),
        paint: Paint()..color = Colors.white,
      ),
      background: CircleComponent(
        radius: GameUtil.getRelativeX(1.5),
        paint: Paint()..color = Colors.black.withAlpha(10),
      ),
      size: GameUtil.getRelativeWidth(1.5),
      anchor: Anchor.center,
    );

    addAll([world, cameraComponent]);

    pauseEngine(); // pause as we are still in the main menu
  }

  void addComponentsToWorld() {
    // PipePair pipePair = PipePair(position: Vector2(size.x / 2, 0));
    player = FlappyBird(
      size: GameUtil.getRelativeSizeX(0.7),
      position: size / 2,
      animationTime: 0.12,
      joystick: joystick,
    );
    scoreDisplay = ScoreDisplay();
    pipeSpawner = PipeSpawner();

    world.addAll([
      Background(size: size, position: Vector2(0, 0), animationTime: 30),
      player,
      pipeSpawner,
    ]);
  }

  void addComponentsToViewport() {
    cameraComponent.viewport.add(joystick);
    cameraComponent.viewport.add(scoreDisplay);
    cameraComponent.viewport.add(pauseButton);
  }

  @override
  void onTapUp(TapUpEvent event) {
    (player as FlappyBird).jump();
  }

  void gameOver() {
    // A pipe and the ground can both end the run in the same frame; only the
    // call that actually shows the menu plays the sounds
    if (overlays.add('gameOverMenu')) {
      AudioUtil.stopMusic();
      AudioUtil.hit();
      _deathSoundTimer = Timer(_deathSoundDelay, AudioUtil.die);
    }
    pauseEngine();
  }

  Future<void> startGame() async {
    AudioUtil.stopMusic();
    overlays.clear();
    resumeEngine();
    addComponentsToWorld();
    addComponentsToViewport();
    await Future.delayed(const Duration(milliseconds: 50));
    countdown();
  }

  void restartGame() async {
    reset();
    await startGame();
  }

  void reset() {
    _deathSoundTimer?.cancel();
    world.removeAll(world.children);
    cameraComponent.viewport.removeAll(cameraComponent.viewport.children);
  }

  void countdown() {
    overlays.add('countdown');
    pauseEngine();
  }

  void countdownComplete() {
    overlays.remove('countdown');
    resumeEngine();
    AudioUtil.playGameMusic();
  }

  void pauseGame() {
    AudioUtil.pauseMusic();
    overlays.add('pauseMenu');
    pauseEngine();
  }

  void resumeGame() {
    overlays.remove('pauseMenu');
    resumeEngine();
    countdown();
  }

  void goToMainMenu() {
    overlays.clear();
    overlays.add('mainMenu');
    reset();
    AudioUtil.playMenuMusic();
    pauseEngine();
  }

  // @override
  // void update(double dt) {
  //   if (isGameOver) {
  //     return;
  //   }
  //   super.update(dt);
  // }

  // @override
  // bool get debugMode => true;
}
