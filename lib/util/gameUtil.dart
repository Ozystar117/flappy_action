import 'package:flame/components.dart';

class GameUtil {
  static late double grid;
  static late Vector2 screenSize;

  /// Initialize the grid size based on the provided screen size
  /// Grid will be 10% of the smaller screen dimension
  static void initialize({required deviceSize}) {
    screenSize = deviceSize;
    grid = (screenSize.x < screenSize.y ? screenSize.x : screenSize.y) * 0.1;
  }

  /// Get relative position based on grid coordinates
  static Vector2 getRelativePosition(double gridX, double gridY) {
    return Vector2(gridX * grid, gridY * grid);
  }

  /// Get relative size based on grid units
  static Vector2 getRelativeSize(double gridWidth, double gridHeight) {
    return Vector2(gridWidth * grid, gridHeight * grid);
  }

  /// Get relative width based on grid units
  static double getRelativeWidth(double gridWidth) {
    return gridWidth * grid;
  }

  /// Get relative height based on grid units
  static double getRelativeHeight(double gridHeight) {
    return gridHeight * grid;
  }

  /// Get relative X position based on grid coordinates
  static double getRelativeX(double gridX) {
    return gridX * grid;
  }

  /// Get relative Y position based on grid coordinates
  static double getRelativeY(double gridY) {
    return gridY * grid;
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
