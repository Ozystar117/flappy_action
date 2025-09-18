import 'dart:async';
import 'package:flame/widgets.dart';
import 'package:flappy_action/game/flappy_action_game.dart';
import 'package:flappy_action/util/sprite_util.dart';
import 'package:flutter/material.dart';

class CountdownOverlay extends StatefulWidget {
  final FlappyActionGame game;

  const CountdownOverlay({super.key, required this.game});

  @override
  State<CountdownOverlay> createState() => _CountdownOverlayState();
}

class _CountdownOverlayState extends State<CountdownOverlay> {
  int countdown = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        countdown--;
      });

      if (countdown <= 0) {
        timer.cancel();
        widget.game.countdownComplete();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          // Semi-transparent overlay
          Container(color: Colors.black.withAlpha(100)),

          // Responsive countdown content
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final screenHeight = constraints.maxHeight;

              // Define your grid system for overlays
              final gridX = screenWidth / 10;
              final gridY = screenHeight / 10;

              return SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Ready text
                      SizedBox(
                        width: gridX * 4,
                        height: gridY * 1,
                        child: SpriteWidget(sprite: SpriteUtil.readyText),
                      ),

                      SizedBox(height: gridY * 0.5),

                      // Countdown number
                      SizedBox(
                        width: gridX,
                        height: gridY,
                        child: countdown > 0
                            ? SpriteWidget(
                                sprite: _getCountdownSprite(countdown),
                              )
                            : const SizedBox(),
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

  Sprite _getCountdownSprite(int number) {
    switch (number) {
      case 3:
        return SpriteUtil.digit3;
      case 2:
        return SpriteUtil.digit2;
      case 1:
        return SpriteUtil.digit1;
      default:
        return SpriteUtil.digit1;
    }
  }
}
