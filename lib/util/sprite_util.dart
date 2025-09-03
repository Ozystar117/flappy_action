import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

class SpriteUtil {
  static const String spriteSheet = 'spritesheet.png';

  static Sprite backgroundDaySprite = getSprite(0, 0, 144, 256);
  static Sprite backgroundNightSprite = getSprite(146, 0, 144, 256);

  static Sprite getSprite(double x, double y, double width, double height) {
    return Sprite(
      Flame.images.fromCache(spriteSheet),
      srcSize: Vector2(width, height),
      srcPosition: Vector2(x, y),
    );
  }
}
