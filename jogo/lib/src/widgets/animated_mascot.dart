// lib/src/widgets/animated_mascot.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedMascot extends StatelessWidget {
  final double size;
  final String assetPath; // ex: 'assets/animations/mascot_idle.json'
  const AnimatedMascot({super.key, this.size = 140, this.assetPath = 'assets/animations/mascot_idle.json'});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: Lottie.asset(assetPath, repeat: true, fit: BoxFit.contain),
    );
  }
}
