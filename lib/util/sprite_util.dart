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

  // Non-bold digits (score panel style), scattered across the sheet
  static Sprite smallDigit0 = getSprite(137, 306, 7, 10);
  static Sprite smallDigit1 = getSprite(139, 477, 5, 10);
  static Sprite smallDigit2 = getSprite(137, 489, 7, 10);
  static Sprite smallDigit3 = getSprite(131, 501, 7, 10);
  static Sprite smallDigit4 = getSprite(502, 0, 7, 10);
  static Sprite smallDigit5 = getSprite(502, 12, 7, 10);
  static Sprite smallDigit6 = getSprite(505, 26, 7, 10);
  static Sprite smallDigit7 = getSprite(505, 42, 7, 10);
  static Sprite smallDigit8 = getSprite(293, 242, 7, 10);
  static Sprite smallDigit9 = getSprite(311, 206, 7, 10);
  static Sprite plusSign = getSprite(496, 84, 5, 5);

  // Tiny non-bold digits, stacked in a column beside the bird sprites
  static Sprite tinyDigit0 = getSprite(138, 323, 6, 7);
  static Sprite tinyDigit1 = getSprite(141, 332, 3, 7);
  static Sprite tinyDigit2 = getSprite(138, 349, 6, 7);
  static Sprite tinyDigit3 = getSprite(138, 358, 6, 7);
  static Sprite tinyDigit4 = getSprite(138, 375, 6, 7);
  static Sprite tinyDigit5 = getSprite(138, 384, 6, 7);
  static Sprite tinyDigit6 = getSprite(138, 401, 6, 7);
  static Sprite tinyDigit7 = getSprite(138, 410, 6, 7);
  static Sprite tinyDigit8 = getSprite(138, 427, 6, 7);
  static Sprite tinyDigit9 = getSprite(138, 436, 6, 7);

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

  static Sprite getSmallDigitSprite(int digit) {
    switch (digit) {
      case 0:
        return smallDigit0;
      case 1:
        return smallDigit1;
      case 2:
        return smallDigit2;
      case 3:
        return smallDigit3;
      case 4:
        return smallDigit4;
      case 5:
        return smallDigit5;
      case 6:
        return smallDigit6;
      case 7:
        return smallDigit7;
      case 8:
        return smallDigit8;
      case 9:
        return smallDigit9;
      default:
        return smallDigit0;
    }
  }

  static Sprite getTinyDigitSprite(int digit) {
    switch (digit) {
      case 0:
        return tinyDigit0;
      case 1:
        return tinyDigit1;
      case 2:
        return tinyDigit2;
      case 3:
        return tinyDigit3;
      case 4:
        return tinyDigit4;
      case 5:
        return tinyDigit5;
      case 6:
        return tinyDigit6;
      case 7:
        return tinyDigit7;
      case 8:
        return tinyDigit8;
      case 9:
        return tinyDigit9;
      default:
        return tinyDigit0;
    }
  }

  // MENU SPRITES
  static Sprite playButton = getSprite(354, 118, 52, 29);
  static Sprite flappyBirdText = getSprite(351, 91, 89, 24);
  static Sprite tapSprite = getSprite(292, 91, 57, 65);
  static Sprite pauseButtonSprite = getSprite(121, 306, 13, 14);
  static Sprite gameOverText = getSprite(395, 59, 96, 21);
  static Sprite menuButton = getSprite(462, 26, 40, 14);
  static Sprite readyText = getSprite(295, 59, 92, 25);

  // GET SPRITE FROM SPRITE SHEET
  static Sprite getSprite(double x, double y, double width, double height) {
    return Sprite(
      Flame.images.fromCache(spriteSheet),
      srcSize: Vector2(width, height),
      srcPosition: Vector2(x, y),
    );
  }
}
