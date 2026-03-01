import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/theme_provider.dart';
import 'views/splash/home_screen.dart';
import 'views/main_screen/main_screen.dart';
import 'views/detail/city_detail_screen.dart';

// Widget racine de l'application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // On écoute le ThemeProvider pour réagir aux changements de thème
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Meteo App',
      // Thème actuel géré par le ThemeProvider (system/light/dark)
      themeMode: themeProvider.themeMode,
      // Thème clair
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      // Thème sombre
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      // Route initiale au démarrage de l'app
      initialRoute: '/',
      // Définition de toutes les routes de navigation
      routes: {
        '/': (context) => const HomeScreen(),         // Écran d'accueil
        '/main': (context) => const MainScreen(),     // Écran principal
        '/detail': (context) => const CityDetailScreen(), // Détail ville
      },
    );
  }
}