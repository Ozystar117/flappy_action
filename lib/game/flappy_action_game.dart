import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flappy_action/components/background.dart';
import 'package:flappy_action/util/sprite_util.dart';

class FlappyActionGame extends FlameGame {
  @override
  final World world = World();

  late final CameraComponent cameraComponent = CameraComponent(world: world)
    ..viewfinder.anchor = Anchor.topLeft;

  @override
  void onLoad() async {
    await images.loadAll([SpriteUtil.spriteSheet]);
    world.add(
      Background(size: size, position: Vector2(0, 0), animationTime: 30),
    );
    addAll([world, cameraComponent]);
  }
}
