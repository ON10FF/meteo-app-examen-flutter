// ============================================================
// test/weather_test.dart
// Tests unitaires pour la couche Réseau & Data
// ============================================================
// Lancer avec : flutter test test/weather_test.dart
// ============================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/data/services/weather_repository.dart';

void main() {
  // ──────────────────────────────────────────────────────────
  // GROUPE 1 : Tests du parsing JSON (WeatherModel)
  // ──────────────────────────────────────────────────────────
  group('WeatherModel - Parsing JSON', () {
    test('Doit parser correctement un JSON complet avec des doubles', () {
      // Simule une réponse JSON typique de l'API OpenWeatherMap
      final Map<String, dynamic> json = {
        'name': 'Paris',
        'coord': {'lat': 48.8566, 'lon': 2.3522},
        'main': {'temp': 22.5, 'feels_like': 21.3, 'humidity': 65},
        'weather': [
          {'description': 'ciel dégagé', 'icon': '01d'},
        ],
        'wind': {'speed': 5.2},
      };

      final weather = WeatherModel.fromJson(json);

      expect(weather.name, equals('Paris'));
      expect(weather.main.temp, equals(22.5));
      expect(weather.main.feelsLike, equals(21.3));
      expect(weather.main.humidity, equals(65));
      expect(weather.description, equals('ciel dégagé'));
      expect(weather.icon, equals('01d'));
      expect(weather.wind.speed, equals(5.2));
      expect(weather.coord.lat, equals(48.8566));
      expect(weather.coord.lon, equals(2.3522));
    });

    test(
      'Doit parser correctement quand l\'API renvoie des entiers au lieu de doubles',
      () {
        // Cas réel fréquent : l'API renvoie temp: 22 (int) au lieu de 22.0 (double)
        // Sans la gestion num → toDouble(), ça crashe !
        final Map<String, dynamic> json = {
          'name': 'Dakar',
          'coord': {'lat': 14, 'lon': -17}, // Entiers !
          'main': {'temp': 30, 'feels_like': 32, 'humidity': 80}, // Entiers !
          'weather': [
            {'description': 'nuageux', 'icon': '04d'},
          ],
          'wind': {'speed': 7}, // Entier !
        };

        final weather = WeatherModel.fromJson(json);

        // Vérifie que les conversions num → double fonctionnent
        expect(weather.main.temp, isA<double>());
        expect(weather.main.temp, equals(30.0));
        expect(weather.main.feelsLike, isA<double>());
        expect(weather.main.feelsLike, equals(32.0));
        expect(weather.main.humidity, isA<int>());
        expect(weather.main.humidity, equals(80));
        expect(weather.wind.speed, isA<double>());
        expect(weather.wind.speed, equals(7.0));
        expect(weather.coord.lat, isA<double>());
        expect(weather.coord.lat, equals(14.0));
      },
    );

    test('Doit gérer un tableau weather vide via les accesseurs', () {
      final Map<String, dynamic> json = {
        'name': 'Inconnu',
        'coord': {'lat': 0.0, 'lon': 0.0},
        'main': {'temp': 0.0, 'feels_like': 0.0, 'humidity': 0},
        'weather': [], // Tableau vide (cas limite)
        'wind': {'speed': 0.0},
      };

      final weather = WeatherModel.fromJson(json);

      // Les accesseurs pratiques doivent retourner des valeurs par défaut
      expect(weather.description, equals('Inconnu'));
      expect(weather.icon, equals('01d'));
    });

    test('Doit sérialiser et désérialiser sans perte (round-trip)', () {
      final Map<String, dynamic> originalJson = {
        'name': 'Lyon',
        'coord': {'lat': 45.76, 'lon': 4.83},
        'main': {'temp': 18.5, 'feels_like': 17.0, 'humidity': 55},
        'weather': [
          {'description': 'pluie légère', 'icon': '10d'},
        ],
        'wind': {'speed': 3.1},
      };

      // JSON → Objet → JSON → Objet
      final weather1 = WeatherModel.fromJson(originalJson);
      final reserializedJson = weather1.toJson();
      final weather2 = WeatherModel.fromJson(reserializedJson);

      expect(weather2.name, equals(weather1.name));
      expect(weather2.main.temp, equals(weather1.main.temp));
      expect(weather2.description, equals(weather1.description));
    });

    test('Doit générer une URL d\'icône correcte', () {
      final Map<String, dynamic> json = {
        'name': 'Marseille',
        'coord': {'lat': 43.3, 'lon': 5.37},
        'main': {'temp': 25.0, 'feels_like': 26.0, 'humidity': 50},
        'weather': [
          {'description': 'ensoleillé', 'icon': '01d'},
        ],
        'wind': {'speed': 4.0},
      };

      final weather = WeatherModel.fromJson(json);

      expect(
        weather.iconUrl,
        equals('https://openweathermap.org/img/wn/01d@2x.png'),
      );
    });
  });

  // ──────────────────────────────────────────────────────────
  // GROUPE 2 : Tests du WeatherRepository (gestion d'erreurs)
  // ──────────────────────────────────────────────────────────
  group('WeatherRepository - Validation des entrées', () {
    late WeatherRepository repository;

    setUp(() {
      repository = WeatherRepository();
    });

    tearDown(() {
      repository.dispose();
    });

    test('Doit lever une WeatherException si la ville est vide', () async {
      expect(
        () => repository.getWeather(''),
        throwsA(
          isA<WeatherException>().having(
            (e) => e.code,
            'code',
            WeatherErrorCode.invalidInput,
          ),
        ),
      );
    });

    test(
      'Doit lever une WeatherException si la ville ne contient que des espaces',
      () async {
        expect(
          () => repository.getWeather('   '),
          throwsA(
            isA<WeatherException>().having(
              (e) => e.message,
              'message',
              contains('Veuillez entrer'),
            ),
          ),
        );
      },
    );
  });

  // ──────────────────────────────────────────────────────────
  // GROUPE 3 : Tests de la WeatherException
  // ──────────────────────────────────────────────────────────
  group('WeatherException', () {
    test('Doit contenir le message, le code et le statusCode', () {
      final exception = WeatherException(
        message: 'Ville introuvable',
        code: WeatherErrorCode.notFound,
        statusCode: 404,
      );

      expect(exception.message, equals('Ville introuvable'));
      expect(exception.code, equals(WeatherErrorCode.notFound));
      expect(exception.statusCode, equals(404));
    });

    test('toString() doit être lisible pour le débogage', () {
      final exception = WeatherException(
        message: 'Clé API invalide',
        code: WeatherErrorCode.unauthorized,
        statusCode: 401,
      );

      final str = exception.toString();

      expect(str, contains('unauthorized'));
      expect(str, contains('401'));
      expect(str, contains('Clé API invalide'));
    });

    test('statusCode peut être null (erreur réseau sans réponse HTTP)', () {
      final exception = WeatherException(
        message: 'Pas de connexion',
        code: WeatherErrorCode.noConnection,
      );

      expect(exception.statusCode, isNull);
    });
  });
}
