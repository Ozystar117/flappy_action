import 'package:flame/components.dart';

class GameUtil {
  static late Vector2 grid;
  static late Vector2 screenSize;

  /// Initialize the grid size based on the provided screen size
  /// Grid will be 10% of the smaller screen dimension
  static void initialize({required deviceSize}) {
    screenSize = deviceSize;
    // grid = (screenSize.x < screenSize.y ? screenSize.x : screenSize.y) * 0.1;
    grid = screenSize * 0.1;
  }

  /// Get relative position based on grid coordinates
  static Vector2 getRelativePosition(double gridX, double gridY) {
    return Vector2(gridX * grid.x, gridY * grid.y);
  }

  /// Get relative size based on grid units
  static Vector2 getRelativeSize(double gridWidth, double gridHeight) {
    return Vector2(gridWidth * grid.x, gridHeight * grid.y);
  }

  static Vector2 getRelativeSizeX(double gridWidth) {
    return Vector2(gridWidth * grid.x, gridWidth * grid.x);
  }

  static Vector2 getRelativeSizeY(double gridHeight) {
    return Vector2(gridHeight * grid.y, gridHeight * grid.y);
  }

  /// Get relative width based on grid units
  static double getRelativeWidth(double gridWidth) {
    return gridWidth * grid.x;
  }

  /// Get relative height based on grid units
  static double getRelativeHeight(double gridHeight) {
    return gridHeight * grid.y;
  }

  /// Get relative X position based on grid coordinates
  static double getRelativeX(double gridX) {
    return gridX * grid.x;
  }

  /// Get relative Y position based on grid coordinates
  static double getRelativeY(double gridY) {
    return gridY * grid.y;
  }

  /// Get the center of the screen
  static Vector2 get center => screenSize / 2;

  /// Get the bottom of the screen
  static double get bottom => screenSize.y;

  /// Get the right edge of the screen
  static double get right => screenSize.x;

  /// Get the top of the screen
  static double get top => 0.0;

  /// Get the left edge of the screen
  static double get left => 0.0;

  /// Get the width of the screen
  static double get width => screenSize.x;

  /// Get the height of the screen
  static double get height => screenSize.y;
}
