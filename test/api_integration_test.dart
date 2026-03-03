// ============================================================
// test/api_integration_test.dart
// Test d'intégration : appel RÉEL à l'API OpenWeatherMap
// ============================================================
// ⚠️ Ce test fait un vrai appel réseau !
// Il nécessite une clé API valide dans api_constants.dart
// et une connexion internet active.
//
// Lancer avec : dart run test/api_integration_test.dart
// ============================================================

import 'package:weather_app/data/services/weather_repository.dart';
import 'package:weather_app/data/models/weather_model.dart';

/// Couleurs ANSI pour un affichage lisible dans le terminal
const String _green = '\x1B[32m';
const String _red = '\x1B[31m';
const String _yellow = '\x1B[33m';
const String _cyan = '\x1B[36m';
const String _reset = '\x1B[0m';
const String _bold = '\x1B[1m';

void main() async {
  print('');
  print('$_bold$_cyan╔══════════════════════════════════════════════╗$_reset');
  print(
    '$_bold$_cyan║   🌤️  TEST D\'INTÉGRATION API MÉTÉO  🌤️      ║$_reset',
  );
  print('$_bold$_cyan╚══════════════════════════════════════════════╝$_reset');
  print('');

  final repository = WeatherRepository();
  int passed = 0;
  int failed = 0;

  // ── Test 1 : Ville valide ─────────────────────────────────
  print('$_bold── Test 1 : Requête avec une ville valide (Paris) ──$_reset');
  try {
    final WeatherModel weather = await repository.getWeather('Paris');

    print('  ${_green}✅ SUCCÈS$_reset — Réponse reçue et parsée :');
    print('     🏙️  Ville       : ${weather.name}');
    print('     🌡️  Température : ${weather.main.temp.toStringAsFixed(1)}°C');
    print(
      '     🤔  Ressenti    : ${weather.main.feelsLike.toStringAsFixed(1)}°C',
    );
    print('     💧  Humidité    : ${weather.main.humidity}%');
    print('     🌤️  Météo       : ${weather.description}');
    print(
      '     💨  Vent        : ${weather.wind.speed.toStringAsFixed(1)} m/s',
    );
    print('     📍  Coordonnées : ${weather.coord.lat}, ${weather.coord.lon}');
    print('     🖼️  Icône       : ${weather.icon} → ${weather.iconUrl}');
    passed++;
  } on WeatherException catch (e) {
    print('  ${_red}❌ ÉCHEC$_reset — ${e.message}');
    print('     Code: ${e.code}, HTTP: ${e.statusCode}');
    failed++;
  }
  print('');

  // ── Test 2 : Ville avec accents ───────────────────────────
  print(
    '$_bold── Test 2 : Ville avec caractères spéciaux (Montréal) ──$_reset',
  );
  try {
    final weather = await repository.getWeather('Montréal');

    print(
      '  ${_green}✅ SUCCÈS$_reset — ${weather.name} : ${weather.main.temp.toStringAsFixed(1)}°C, ${weather.description}',
    );
    passed++;
  } on WeatherException catch (e) {
    print('  ${_red}❌ ÉCHEC$_reset — ${e.message}');
    failed++;
  }
  print('');

  // ── Test 3 : Ville africaine ──────────────────────────────
  print('$_bold── Test 3 : Ville africaine (Dakar) ──$_reset');
  try {
    final weather = await repository.getWeather('Dakar');

    print(
      '  ${_green}✅ SUCCÈS$_reset — ${weather.name} : ${weather.main.temp.toStringAsFixed(1)}°C, ${weather.description}',
    );
    passed++;
  } on WeatherException catch (e) {
    print('  ${_red}❌ ÉCHEC$_reset — ${e.message}');
    failed++;
  }
  print('');

  // ── Test 4 : Ville inexistante (erreur 404 attendue) ─────
  print(
    '$_bold── Test 4 : Ville inexistante → doit retourner une erreur ──$_reset',
  );
  try {
    await repository.getWeather('VilleQuiNExistePas12345');

    print(
      '  ${_red}❌ ÉCHEC$_reset — Aucune exception levée (on en attendait une !)',
    );
    failed++;
  } on WeatherException catch (e) {
    if (e.code == WeatherErrorCode.notFound) {
      print(
        '  ${_green}✅ SUCCÈS$_reset — Erreur 404 interceptée correctement :',
      );
      print('     Message : "${e.message}"');
      passed++;
    } else {
      print(
        '  ${_yellow}⚠️  ATTENTION$_reset — Exception reçue mais code inattendu :',
      );
      print('     Code: ${e.code}, Message: ${e.message}');
      failed++;
    }
  }
  print('');

  // ── Test 5 : Ville vide (validation input) ────────────────
  print('$_bold── Test 5 : Ville vide → doit retourner une erreur ──$_reset');
  try {
    await repository.getWeather('');

    print('  ${_red}❌ ÉCHEC$_reset — Aucune exception levée !');
    failed++;
  } on WeatherException catch (e) {
    if (e.code == WeatherErrorCode.invalidInput) {
      print('  ${_green}✅ SUCCÈS$_reset — Validation interceptée :');
      print('     Message : "${e.message}"');
      passed++;
    } else {
      print(
        '  ${_yellow}⚠️  ATTENTION$_reset — Exception reçue mais code inattendu : ${e.code}',
      );
      failed++;
    }
  }
  print('');

  // ── Test 6 : Espaces uniquement ───────────────────────────
  print(
    '$_bold── Test 6 : Espaces uniquement → doit retourner une erreur ──$_reset',
  );
  try {
    await repository.getWeather('   ');

    print('  ${_red}❌ ÉCHEC$_reset — Aucune exception levée !');
    failed++;
  } on WeatherException catch (e) {
    if (e.code == WeatherErrorCode.invalidInput) {
      print(
        '  ${_green}✅ SUCCÈS$_reset — Validation interceptée : "${e.message}"',
      );
      passed++;
    } else {
      print('  ${_yellow}⚠️$_reset — Code inattendu : ${e.code}');
      failed++;
    }
  }
  print('');

  // ── Test 7 : Sérialisation round-trip ─────────────────────
  print('$_bold── Test 7 : Sérialisation JSON round-trip ──$_reset');
  try {
    final weather = await repository.getWeather('Tokyo');
    final json = weather.toJson();
    final weather2 = WeatherModel.fromJson(json);

    if (weather.name == weather2.name &&
        weather.main.temp == weather2.main.temp &&
        weather.description == weather2.description) {
      print(
        '  ${_green}✅ SUCCÈS$_reset — JSON → Objet → JSON → Objet sans perte',
      );
      print(
        '     ${weather.name} : ${weather.main.temp}°C ↔ ${weather2.main.temp}°C',
      );
      passed++;
    } else {
      print('  ${_red}❌ ÉCHEC$_reset — Données différentes après round-trip');
      failed++;
    }
  } on WeatherException catch (e) {
    print('  ${_red}❌ ÉCHEC$_reset — ${e.message}');
    failed++;
  }
  print('');

  // ── Résumé final ──────────────────────────────────────────
  print('$_bold$_cyan══════════════════════════════════════════════$_reset');
  print('$_bold  RÉSUMÉ : $passed/${passed + failed} tests réussis$_reset');

  if (failed == 0) {
    print('  ${_green}${_bold}🎉 TOUS LES TESTS SONT PASSÉS !$_reset');
  } else {
    print('  ${_red}${_bold}⚠️  $failed test(s) en échec.$_reset');
  }
  print('$_bold$_cyan══════════════════════════════════════════════$_reset');
  print('');

  // Libération des ressources
  repository.dispose();
}
