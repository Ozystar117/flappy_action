// lib/overlays/main_menu.dart
import 'package:flame/widgets.dart';
import 'package:flappy_action/game/flappy_action_game.dart';
import 'package:flappy_action/util/sprite_util.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  final FlappyActionGame game;

  const MainMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: 144, // Original sprite width
                height: 256, // Original sprite height
                child: SpriteWidget(sprite: SpriteUtil.backgroundDaySprite),
              ),
            ),
          ),

          // Semi-transparent overlay
          Container(color: Colors.black.withAlpha(100)),

          // Menu Content
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
                      // Title
                      SizedBox(
                        width: gridX * 6,
                        height: gridY,
                        child: SpriteWidget(sprite: SpriteUtil.flappyBirdText),
                      ),

                      SizedBox(height: gridY * 0.1),

                      // Start button
                      SizedBox(
                        width: gridX * 3,
                        height: gridY * 3,
                        child: GestureDetector(
                          onTap: () {
                            game.overlays.remove('mainMenu');
                            game.resumeEngine();
                            game.startGame();
                          },
                          // child: SpriteWidget(sprite: SpriteUtil.playButton),
                          child: SpriteWidget(sprite: SpriteUtil.tapSprite),
                        ),
                      ),

                      SizedBox(height: gridY * 0.5),
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

  // @override
  // Widget build(BuildContext context) {
  //   return SizedBox.expand(
  //     child: Material(
  //       color: Colors.black.withAlpha(100),
  //       child: LayoutBuilder(
  //         builder: (context, constraints) {
  //           // Calculate responsive sizes based on screen dimensions
  //           final screenWidth = constraints.maxWidth;
  //           final screenHeight = constraints.maxHeight;

  //           // Define your grid system for overlays
  //           final gridX = screenWidth / 10; // 10 grid units across
  //           final gridY = screenHeight / 10; // 10 grid units down

  //           return SafeArea(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 // Title
  //                 SizedBox(
  //                   width: gridX * 6,
  //                   height: gridY,
  //                   child: SpriteWidget(sprite: SpriteUtil.flappyBirdText),
  //                 ),

  //                 SizedBox(height: gridY * 0.1),

  //                 // Start button
  //                 SizedBox(
  //                   width: gridX * 3,
  //                   height: gridY * 0.8,
  //                   child: GestureDetector(
  //                     onTap: () {
  //                       // game.startGame();
  //                       game.overlays.remove('mainMenu');
  //                       game.isGameStarted = true;
  //                     },
  //                     child: SpriteWidget(sprite: SpriteUtil.playButton),
  //                   ),
  //                 ),

  //                 SizedBox(height: gridY * 0.5),
  //               ],
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }
}
