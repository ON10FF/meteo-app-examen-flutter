// Constantes de l'API OpenWeatherMap
class ApiConstants {

  // URL de base de l'API
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Clé API (ne jamais partager publiquement !)
  static const String apiKey = 'MACLEFAPI';

  // Unité de température (metric = Celsius)
  static const String units = 'metric';

  // Langue des descriptions météo
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