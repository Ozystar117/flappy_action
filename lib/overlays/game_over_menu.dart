import 'package:flame/widgets.dart';
import 'package:flappy_action/game/flappy_action_game.dart';
import 'package:flappy_action/util/sprite_util.dart';
import 'package:flutter/material.dart';

class GameOverMenu extends StatelessWidget {
  final FlappyActionGame game;

  const GameOverMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          // Semi-transparent dim overlay
          Container(color: Colors.black.withAlpha(150)),

          // Responsive menu content
          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate responsive sizes based on screen dimensions
              final screenWidth = constraints.maxWidth;
              final screenHeight = constraints.maxHeight;

              // Define your grid system for overlays
              final gridX = screenWidth / 10; // 10 grid units across
              final gridY = screenHeight / 10; // 10 grid units down

              return SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Game Over Text Sprite
                      SizedBox(
                        width: gridX * 4, // Adjust size as needed
                        height: gridY * 1, // Adjust size as needed
                        child: SpriteWidget(sprite: SpriteUtil.gameOverText),
                      ),

                      SizedBox(height: gridY * 0.5),

                      // Play button to restart
                      SizedBox(
                        width: gridX * 3,
                        height: gridY * 1.5,
                        child: GestureDetector(
                          onTap: () {
                            // Restart the game
                            game.resumeEngine();
                            game.overlays.remove('gameOverMenu');
                            game.restartGame();
                          },
                          child: SpriteWidget(sprite: SpriteUtil.playButton),
                        ),
                      ),

                      SizedBox(height: gridY * 0.3),

                      // Main Menu button
                      SizedBox(
                        width: gridX * 3,
                        height: gridY * 1,
                        child: GestureDetector(
                          onTap: () {
                            // Go to main menu
                            game.overlays.remove('gameOverMenu');
                            game.overlays.add('mainMenu');
                            game.reset();
                            game.pauseEngine(); // prevent the game from starting when the main menu is shown
                          },
                          child: SpriteWidget(sprite: SpriteUtil.menuButton),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
