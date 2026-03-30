import 'package:flutter/material.dart';

class SplashAnimation {
  final AnimationController controller;
  late final Animation<double> scale;
  late final Animation<double> rotation;

  SplashAnimation(this.controller) {
    scale = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.2,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(controller);

    rotation = Tween(
      begin: -0.05,
      end: 0.05,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.elasticIn));
  }
}
