import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/weather_provider.dart';
import '../../providers/theme_provider.dart';

// TODO: À compléter par Membre 3 (widgets jauge et tableau)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Météo Mondiale'),
        // Bouton retour vers l'accueil
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        // Bouton toggle thème clair/sombre
        actions: [
          IconButton(
            icon: Icon(
              context.watch<ThemeProvider>().isDark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
        ],
      ),
      // TODO: À compléter par Membre 2 et 3
      body: const Center(
        child: Text('Écran principal - En cours de développement'),
      ),
    );
  }
}