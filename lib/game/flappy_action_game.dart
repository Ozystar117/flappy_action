import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flappy_action/components/background.dart';
import 'package:flappy_action/components/birds/bird.dart';
import 'package:flappy_action/components/birds/flappy_bird.dart';
import 'package:flappy_action/components/huds/pause_button.dart';
import 'package:flappy_action/components/obstacles/pipe_spawner.dart';
import 'package:flappy_action/components/huds/score_display.dart';
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

  @override
  void onLoad() async {
    await images.loadAll([SpriteUtil.spriteSheet]);
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
    overlays.add('gameOverMenu'); // todo: add game over screen
    pauseEngine();
  }

  Future<void> startGame() async {
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
