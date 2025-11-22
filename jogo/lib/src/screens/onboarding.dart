import 'package:flutter/material.dart';

import '../widgets/cable_mascot.dart';
import 'dashboard.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Bem-vindo ao Aprende Redes', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('Aprende conceitos de redes com lições curtas, animações e quizzes.'),
              const SizedBox(height: 20),
              const CableMascot(size: 140),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                ),
                child: const Text('Começar a aprender'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}