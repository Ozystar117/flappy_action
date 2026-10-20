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

class _CountdownOverlayState extends State<CountdownOverlay>
    with SingleTickerProviderStateMixin {
  int countdown = 3;
  Timer? _timer;

  // The engine is paused during the countdown, so these are Flutter
  // animations rather than Flame effects
  static const Duration _numberTransition = Duration(milliseconds: 300);
  static const double _numberStartScale = 2.0;
  static const double _numberHeight = 2.0; // grid units
  // Incoming numbers are fully visible after this fraction of the transition,
  // so the shrink from the start scale can be seen
  static const double _fadeInPortion = 0.15;
  static const Duration _bobHalfPeriod = Duration(milliseconds: 500);
  static const double _bobDistance = 0.1; // grid units
  late final AnimationController _bobController;

  // AnimatedSwitcher doesn't animate its first child, so show a placeholder
  // for one frame and let the first number arrive as a change
  bool _showNumber = false;

  @override
  void initState() {
    super.initState();
    _bobController = AnimationController(vsync: this, duration: _bobHalfPeriod)
      ..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _showNumber = true);
    });
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
    _bobController.dispose();
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

              // Define the grid system for overlays
              final gridX = screenWidth / 10;
              final gridY = screenHeight / 10;

              return SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Ready text, bobbing up and down
                      AnimatedBuilder(
                        animation: _bobController,
                        builder: (context, child) => Transform.translate(
                          offset: Offset(
                            0,
                            (_bobController.value * 2 - 1) *
                                gridY *
                                _bobDistance,
                          ),
                          child: child,
                        ),
                        child: SizedBox(
                          width: gridX * 4,
                          height: gridY * 1,
                          child: SpriteWidget(sprite: SpriteUtil.readyText),
                        ),
                      ),

                      SizedBox(height: gridY * 0.5),

                      // Countdown number, punching in as it changes
                      SizedBox(
                        height: gridY * _numberHeight,
                        child: AnimatedSwitcher(
                          duration: _numberTransition,
                          transitionBuilder: _punchIn,
                          child: _showNumber && countdown > 0
                              ? _number(countdown, gridY * _numberHeight)
                              : const SizedBox(key: ValueKey(0)),
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

  /// Incoming numbers scale down from [_numberStartScale] with an overshoot
  /// while quickly fading in; outgoing numbers only fade out. AnimatedSwitcher runs
  /// the same transition in reverse for outgoing children, so the scale is
  /// chosen from the animation's direction on every frame.
  Widget _punchIn(Widget child, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final isLeaving = animation.status == AnimationStatus.reverse;
        final scale = isLeaving
            ? 1.0
            : _numberStartScale +
                  (1.0 - _numberStartScale) *
                      Curves.easeOutBack.transform(animation.value);
        final opacity = isLeaving
            ? animation.value
            : (animation.value / _fadeInPortion).clamp(0.0, 1.0);
        return Opacity(
          opacity: opacity,
          child: Transform.scale(scale: scale, child: child),
        );
      },
    );
  }

  /// Sized from the sprite's own aspect ratio so every number has the same
  /// height (the '1' is narrower than the other digits).
  Widget _number(int value, double height) {
    final sprite = SpriteUtil.getSmallDigitSprite(value);
    return SizedBox(
      key: ValueKey(value),
      height: height,
      width: height * sprite.srcSize.x / sprite.srcSize.y,
      child: SpriteWidget(sprite: sprite),
    );
  }
}
