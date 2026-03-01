import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    // Si isDark est true → on passe à light, sinon → on passe à dark
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;

    // On notifie tous les widgets qui écoutent ce provider
    notifyListeners();
  }

}