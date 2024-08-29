import 'dart:math' as math;
import 'package:to_do/core/utils/imports/flutter_import.dart';

class AnimatedFAB extends StatefulWidget {
  final VoidCallback onPressedCallback;

  const AnimatedFAB({super.key, required this.onPressedCallback});

  @override
  AnimatedFABState createState() => AnimatedFABState();
}

class AnimatedFABState extends State<AnimatedFAB>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _bounceController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
        CurvedAnimation(
            parent: _rotationController, curve: Curves.easeInOutBack));

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 0.9), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 1.1), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.1, end: 1), weight: 1),
    ]).animate(
        CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut));

    _rotationController.repeat(reverse: true);
    _bounceController.repeat(reverse: true);
  }

  void _onPressed() {
    _rotationController.forward(from: 0);
    _bounceController.forward(from: 0);
    widget.onPressedCallback();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationAnimation, _bounceAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: _onPressed,
                backgroundColor: Colors.green,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _bounceController.dispose();
    super.dispose();
  }
}
