import 'package:flutter/material.dart';

import '../widgets/cable_mascot.dart';
import 'onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 900), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CableMascot(size: 160),
            SizedBox(height: 24),
            Text('Aprende Redes', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Intuitivo • Divertido • Prático'),
          ],
        ),
      ),
    );
  }
}