import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

class SpriteUtil {
  static const String spriteSheet = 'spritesheet.png';

  static Sprite backgroundDaySprite = getSprite(0, 0, 144, 256);
  static Sprite backgroundNightSprite = getSprite(146, 0, 144, 256);
  
  static Sprite yellowBird1 = getSprite(3, 491, 17, 12);
  static Sprite yellowBird2 = getSprite(31, 491, 17, 12);
  static Sprite yellowBird3 = getSprite(59, 491, 17, 12);

  static Sprite redBird1 = getSprite(115, 381, 17, 12);
  static Sprite redBird2 = getSprite(115, 407, 17, 12);
  static Sprite redBird3 = getSprite(115, 433, 17, 12);

  static Sprite getSprite(double x, double y, double width, double height) {
    return Sprite(
      Flame.images.fromCache(spriteSheet),
      srcSize: Vector2(width, height),
      srcPosition: Vector2(x, y),
    );
  }
}
