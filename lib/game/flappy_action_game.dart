import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flappy_action/components/background.dart';
import 'package:flappy_action/components/birds/bird.dart';
import 'package:flappy_action/components/birds/flappy_bird.dart';
import 'package:flappy_action/util/gameUtil.dart';
import 'package:flappy_action/util/sprite_util.dart';

class FlappyActionGame extends FlameGame {
  @override
  final World world = World();

  late final CameraComponent cameraComponent = CameraComponent(world: world)
    ..viewfinder.anchor = Anchor.topLeft;

  late final Bird player = FlappyBird(
    size: GameUtil.getRelativeSize(0.7, 0.7),
    // size: Vector2.all(50),
    position: size / 2,
    animationTime: 0.12,
  );

  @override
  void onLoad() async {
    await images.loadAll([SpriteUtil.spriteSheet]);
    Flame.device.setPortraitUpOnly(); // lock to portrait
    GameUtil.initialize(deviceSize: size);

    addComponentsToWorld();
    addAll([world, cameraComponent]);
  }

  void addComponentsToWorld() {
    world.addAll([
      Background(size: size, position: Vector2(0, 0), animationTime: 30),
      player,
    ]);
  }
}
