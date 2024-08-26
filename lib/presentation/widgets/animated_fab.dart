import 'package:flutter/material.dart';

class AnimatedFAB extends StatefulWidget {
  final VoidCallback onPressedCallback;

  const AnimatedFAB({super.key, required this.onPressedCallback});

  @override
  AnimatedFABState createState() => AnimatedFABState();
}

class AnimatedFABState extends State<AnimatedFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _wiggleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(
          milliseconds: 500), // Shorter duration for bounce effect
      vsync: this,
    );

    // Define the wiggle animation with a more pronounced bounce effect
    _wiggleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.1)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.1, end: -0.1)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.1, end: 0.05)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.05, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1.0,
      ),
    ]).animate(_animationController);
  }

  void _onPressed() {
    if (_animationController.isCompleted || _animationController.isDismissed) {
      _animationController.reset();
      _animationController.forward();
      widget.onPressedCallback(); // Call the passed callback
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _wiggleAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _wiggleAnimation.value,
          child: FloatingActionButton(
            onPressed: _onPressed,
            backgroundColor: Colors.green,
            child: const Icon(Icons.add, color: Colors.black),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
