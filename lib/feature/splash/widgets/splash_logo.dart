import 'package:drawing_app/feature/splash/widgets/splash_animation.dart';
import 'package:flutter/material.dart';

class SplashLogo extends StatelessWidget {
  final SplashAnimation animation;

  const SplashLogo({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation.controller,
      builder: (context, child){
        return Transform.scale(
          scale: animation.scale.value,
          child: Transform.rotate(
            angle: animation.rotation.value,
            child: child,
          ),
        );
      },
      child: Image.asset(
        'assets/images/app_logo.png',
        width: 260,
        height: 260,
      ),
    );
  }
}