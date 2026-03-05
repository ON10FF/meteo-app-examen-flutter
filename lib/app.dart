import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/theme_provider.dart';
import 'views/splash/home_screen.dart';
import 'views/main_screen/main_screen.dart';
import 'views/detail/city_detail_screen.dart';

// ── Palette commune (hors classe pour permettre l'usage en const) ──
const _sunOrange   = Color(0xFFFF8C00);
const _burntOrange = Color(0xFFD4541A);
const _deepRed     = Color(0xFF7B1F2E);
const _nightPurple = Color(0xFF1A0533);
const _sandYellow  = Color(0xFFFFC94A);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Météo Sénégal',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,

      // ── Thème clair ──────────────────────────────────────────
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _sunOrange,
          brightness: Brightness.light,
          primary: _sunOrange,
          secondary: _burntOrange,
          surface: const Color(0xFFFFF8F0),
          onSurface: _nightPurple,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _sunOrange,
            foregroundColor: Colors.white,
            elevation: 8,
            shadowColor: const Color(0x80FF8C00),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),

        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white,
          shadowColor: const Color(0x26FF8C00),
        ),

        iconTheme: const IconThemeData(color: _burntOrange),
      ),

      // ── Thème sombre ──────────────────────────────────────────
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _sunOrange,
          brightness: Brightness.dark,
          primary: _sunOrange,
          secondary: _sandYellow,
          surface: _nightPurple,
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: _nightPurple,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _sunOrange,
            foregroundColor: Colors.white,
            elevation: 8,
            shadowColor: const Color(0x66FF8C00),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),

        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: const Color(0xFF2D1045),
          shadowColor: const Color(0x4D7B1F2E),
        ),

        iconTheme: const IconThemeData(color: _sandYellow),
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/main': (context) => const MainScreen(),
        '/detail': (context) => const CityDetailScreen(),
      },
    );
  }
}