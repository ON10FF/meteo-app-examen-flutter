import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Clé chargée depuis .env
  static String get apiKey => dotenv.env['WEATHER_API_KEY'] ?? '';

  static const String units = 'metric';
  static const String lang = 'fr';

  static const List<String> cities = [
    'Dakar', 'Mbour', 'Kaffrine', 'Kaolack', 'Thies',
  ];
}