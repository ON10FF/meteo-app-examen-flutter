import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône nuage animée
              const Icon(Icons.cloud, size: 100, color: Colors.white)
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .scale(),
              const SizedBox(height: 20),
              // Titre animé
              Text(
                '🌤️ Météo en Temps Réel',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
              const SizedBox(height: 10),
              // Sous-titre animé
              Text(
                'Découvre la météo de 5 villes en direct !',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                ),
              ).animate().fadeIn(delay: 600.ms),
              const SizedBox(height: 50),
              // Bouton de démarrage animé
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/main'),
                icon: const Icon(Icons.explore),
                label: const Text('Lancer l\'expérience 🚀'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ).animate().fadeIn(delay: 800.ms).scale(),
            ],
          ),
        ),
      ),
    );
  }
}