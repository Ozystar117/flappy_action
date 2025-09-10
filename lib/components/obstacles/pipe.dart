import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_action/util/sprite_util.dart';

class Pipe extends SpriteComponent {
  final bool isTop;

  Pipe({required super.position, required super.size, required this.isTop});

  @override
  Future<void> onLoad() async {
    sprite = SpriteUtil.greenTopTube;

    // bottom pipe
    if (!isTop) {
      flipVertically();
    }

    // anchor = Anchor.topLeft;
    anchor = isTop ? Anchor.topLeft : Anchor.bottomLeft;

    add(RectangleHitbox());
  }
}
