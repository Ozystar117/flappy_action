import 'package:flame/widgets.dart';
import 'package:flappy_action/game/flappy_action_game.dart';
import 'package:flappy_action/util/sprite_util.dart';
import 'package:flutter/material.dart';

class PauseMenu extends StatelessWidget {
  final FlappyActionGame game;

  const PauseMenu({super.key, required this.game});

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
                  child: SizedBox(
                    width: gridX * 3, // Same size as main menu button
                    height: gridY * 1.5, // Proportional height for play button
                    child: GestureDetector(
                      onTap: () {
                        // Resume the game
                        game.overlays.remove('pauseMenu');
                        game.countdown();
                      },
                      child: SpriteWidget(sprite: SpriteUtil.playButton),
                    ),
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
