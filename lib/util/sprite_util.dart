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

  static Sprite greenTopTube = getSprite(56, 323, 26, 160);

  static Sprite digit0 = getSprite(496, 60, 12, 18);
  static Sprite digit1 = getSprite(136, 455, 8, 18);
  static Sprite digit2 = getSprite(292, 160, 12, 18);
  static Sprite digit3 = getSprite(306, 160, 12, 18);
  static Sprite digit4 = getSprite(320, 160, 12, 18);
  static Sprite digit5 = getSprite(334, 160, 12, 18);
  static Sprite digit6 = getSprite(292, 184, 12, 18);
  static Sprite digit7 = getSprite(306, 184, 12, 18);
  static Sprite digit8 = getSprite(320, 184, 12, 18);
  static Sprite digit9 = getSprite(334, 184, 12, 18);

  static Sprite getDigitSprite(int digit) {
    switch (digit) {
      case 0:
        return digit0;
      case 1:
        return digit1;
      case 2:
        return digit2;
      case 3:
        return digit3;
      case 4:
        return digit4;
      case 5:
        return digit5;
      case 6:
        return digit6;
      case 7:
        return digit7;
      case 8:
        return digit8;
      case 9:
        return digit9;
      default:
        return digit0;
    }
  }

  static Sprite getSprite(double x, double y, double width, double height) {
    return Sprite(
      Flame.images.fromCache(spriteSheet),
      srcSize: Vector2(width, height),
      srcPosition: Vector2(x, y),
    );
  }
}
