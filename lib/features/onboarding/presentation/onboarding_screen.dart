import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('👋', style: TextStyle(fontSize: 64)),
              Text(
                'Welcome to Hydrate Yourself',
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              Text(
                "Let's get you set up",
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () => context.go('/home'),
                child: const Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
