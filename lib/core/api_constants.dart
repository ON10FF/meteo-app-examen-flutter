// ============================================================
// lib/core/api_constants.dart
// Constantes de configuration pour l'API OpenWeatherMap
// ============================================================

/// Classe utilitaire regroupant toutes les constantes de l'API météo.
class ApiConstants {
  ApiConstants._();

  /// URL de base de l'API OpenWeatherMap v2.5
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  /// Clé API OpenWeatherMap
  static const String apiKey = '0626f547137884c35e6516c9f871ad11';

  /// Unités de mesure : "metric" = Celsius
  static const String units = 'metric';

  /// Langue des descriptions météo : "fr" = français
  static const String lang = 'fr';

  // Les 5 villes surveillées par l'application
  static const List<String> cities = [
    'Dakar',
    'Mbour',
    'Kaffrine',
    'Kaolack',
    'Thies',
  ];
}
