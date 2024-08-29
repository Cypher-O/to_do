import 'package:to_do/core/utils/imports/general_import.dart';

class BackgroundCircles extends StatelessWidget {
  final double size;
  final Duration fadeInDuration;
  final Duration fadeOutDuration;
  final Duration fadeOutDelay;

  const BackgroundCircles({
    super.key,
    this.size = 300.0,
    this.fadeInDuration = const Duration(seconds: 1),
    this.fadeOutDuration = const Duration(seconds: 1),
    this.fadeOutDelay = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -size / 3,
          left: -size / 3,
          child: FadeInDown(
            duration: fadeInDuration,
            child: SvgPicture.string(
              _circleSvg,
              width: size,
              height: size,
            ),
          ),
        ),
        Positioned(
          bottom: -size / 3,
          right: -size / 3,
          child: FadeInUp(
            duration: fadeOutDuration,
            delay: fadeOutDelay,
            child: SvgPicture.string(
              _circleSvg,
              width: size,
              height: size,
            ),
          ),
        ),
      ],
    );
  }

  static const String _circleSvg = '''
    <svg width="300" height="300" viewBox="0 0 300 300" fill="none" xmlns="http://www.w3.org/2000/svg">
      <circle cx="150" cy="150" r="150" fill="white" fill-opacity="0.1"/>
      <circle cx="150" cy="150" r="100" fill="white" fill-opacity="0.1"/>
      <circle cx="150" cy="150" r="50" fill="white" fill-opacity="0.1"/>
    </svg>
  ''';
}
