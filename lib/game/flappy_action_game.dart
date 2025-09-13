import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flappy_action/components/background.dart';
import 'package:flappy_action/components/birds/bird.dart';
import 'package:flappy_action/components/birds/flappy_bird.dart';
import 'package:flappy_action/components/obstacles/pipe_spawner.dart';
import 'package:flappy_action/util/gameUtil.dart';
import 'package:flappy_action/util/sprite_util.dart';
import 'package:flutter/material.dart';

class FlappyActionGame extends FlameGame
    with TapCallbacks, HasCollisionDetection {
  @override
  final World world = World();

  late final CameraComponent cameraComponent = CameraComponent(world: world)
    ..viewfinder.anchor = Anchor.topLeft;

  late final Bird player = FlappyBird(
    size: GameUtil.getRelativeSizeX(0.7),
    // size: Vector2.all(50),
    position: size / 2,
    animationTime: 0.12,
    joystick: joystick,
  );

  late final JoystickComponent joystick;

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
      knob: CircleComponent(radius: 20, paint: Paint()..color = Colors.white),
      background: CircleComponent(
        radius: 50,
        paint: Paint()..color = Colors.black.withAlpha(100),
      ),
      size: 100,
      anchor: Anchor.center,
    );

    addAll([world, cameraComponent]);

    addComponentsToViewport();

    addComponentsToWorld();
  }

  void addComponentsToWorld() {
    // PipePair pipePair = PipePair(position: Vector2(size.x / 2, 0));
    PipeSpawner pipeSpawner = PipeSpawner();

    world.addAll([
      Background(size: size, position: Vector2(0, 0), animationTime: 30),
      player,
      pipeSpawner,
    ]);
  }

  void addComponentsToViewport() {
    cameraComponent.viewport.add(joystick);
  }

  @override
  void onTapUp(TapUpEvent event) {
    (player as FlappyBird).jump();
  }

  // @override
  // bool get debugMode => true;
}
