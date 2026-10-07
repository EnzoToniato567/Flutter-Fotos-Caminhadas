import 'package:flutter/material.dart';

import 'home.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 700),
              tween: Tween(begin: 0, end: 1),
              builder: (context, opacidade, child) => Opacity(
                opacity: opacidade,
                child: child,
              ),
              child: Image.asset('assets/icon.png', width: 180),
            ),
            const SizedBox(height: 16),
            Text(
              'Minhas Caminhadas',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Home()),
              ),
              icon: const Icon(Icons.login),
              label: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
