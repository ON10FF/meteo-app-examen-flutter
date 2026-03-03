import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../../core/api_constants.dart';
import '../api/weather_client.dart';
import '../models/weather_model.dart';

class WeatherRepository {
  late final Dio _dio;
  late final WeatherClient _client;

  WeatherRepository() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: false,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );

    _client = WeatherClient(_dio);
  }

  Future<WeatherModel> getWeather(String cityName) async {
    if (cityName.trim().isEmpty) {
      throw WeatherException(
        message: 'Veuillez entrer un nom de ville.',
        code: WeatherErrorCode.invalidInput,
      );
    }

    // Sur le web, on utilise package:http pour éviter le CORS
    if (kIsWeb) {
      return _getWeatherWeb(cityName.trim());
    }

    return _getWeatherNative(cityName.trim());
  }

  /// Stratégie WEB : utilise package:http (pas de problème CORS)
  Future<WeatherModel> _getWeatherWeb(String cityName) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}/weather'
        '?q=${Uri.encodeComponent(cityName)}'
        '&appid=${ApiConstants.apiKey}'
        '&units=${ApiConstants.units}'
        '&lang=${ApiConstants.lang}',
      );

      final response = await http
          .get(uri)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw WeatherException(
              message: 'Le serveur met trop de temps à répondre. Réessayez.',
              code: WeatherErrorCode.timeout,
            ),
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return WeatherModel.fromJson(json);
      }

      _handleHttpError(response.statusCode, cityName);

      // Ne sera jamais atteint mais requis par le compilateur
      throw WeatherException(
        message: 'Erreur inconnue.',
        code: WeatherErrorCode.unknown,
      );
    } on WeatherException {
      rethrow;
    } on FormatException {
      throw WeatherException(
        message: 'Erreur de lecture des données météo.',
        code: WeatherErrorCode.parsingError,
      );
    } catch (e) {
      if (e is WeatherException) rethrow;
      throw WeatherException(
        message:
            'Impossible de se connecter au serveur. Vérifiez votre connexion internet.',
        code: WeatherErrorCode.noConnection,
      );
    }
  }

  Future<WeatherModel> _getWeatherNative(String cityName) async {
    try {
      final WeatherModel weather = await _client.getWeather(
        cityName,
        ApiConstants.apiKey,
        ApiConstants.units,
        ApiConstants.lang,
      );
      return weather;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        _handleHttpError(e.response?.statusCode, cityName);
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw WeatherException(
          message:
              'Pas de connexion internet. Vérifiez votre réseau et réessayez.',
          code: WeatherErrorCode.timeout,
        );
      }

      if (e.type == DioExceptionType.connectionError) {
        throw WeatherException(
          message:
              'Impossible de se connecter au serveur. Vérifiez votre connexion internet.',
          code: WeatherErrorCode.noConnection,
        );
      }

      if (e.type == DioExceptionType.cancel) {
        throw WeatherException(
          message: 'La requête a été annulée.',
          code: WeatherErrorCode.cancelled,
        );
      }

      throw WeatherException(
        message: 'Une erreur réseau est survenue : ${e.message}',
        code: WeatherErrorCode.unknown,
      );
    } on FormatException {
      throw WeatherException(
        message: 'Erreur de lecture des données météo.',
        code: WeatherErrorCode.parsingError,
      );
    } on TypeError {
      throw WeatherException(
        message: 'Erreur de parsing des données.',
        code: WeatherErrorCode.parsingError,
      );
    } catch (e) {
      if (e is WeatherException) rethrow;
      throw WeatherException(
        message: 'Erreur inattendue : ${e.toString()}',
        code: WeatherErrorCode.unknown,
      );
    }
  }

  Never _handleHttpError(int? statusCode, String cityName) {
    switch (statusCode) {
      case 400:
        throw WeatherException(
          message: 'Requête invalide. Vérifiez le nom de la ville.',
          code: WeatherErrorCode.badRequest,
          statusCode: 400,
        );
      case 401:
        throw WeatherException(
          message:
              'Clé API invalide. Vérifiez votre clé dans api_constants.dart.',
          code: WeatherErrorCode.unauthorized,
          statusCode: 401,
        );
      case 403:
        throw WeatherException(
          message:
              'Accès refusé. Votre clé API n\'a pas les permissions nécessaires.',
          code: WeatherErrorCode.forbidden,
          statusCode: 403,
        );
      case 404:
        throw WeatherException(
          message: 'Ville introuvable : "$cityName". Vérifiez l\'orthographe.',
          code: WeatherErrorCode.notFound,
          statusCode: 404,
        );
      case 429:
        throw WeatherException(
          message: 'Trop de requêtes. Patientez quelques secondes.',
          code: WeatherErrorCode.tooManyRequests,
          statusCode: 429,
        );
      case 500:
      case 502:
      case 503:
        throw WeatherException(
          message: 'Le serveur OpenWeatherMap est temporairement indisponible.',
          code: WeatherErrorCode.serverError,
          statusCode: statusCode,
        );
      default:
        throw WeatherException(
          message: 'Erreur serveur inattendue (code $statusCode).',
          code: WeatherErrorCode.unknown,
          statusCode: statusCode,
        );
    }
  }

  void dispose() {
    _dio.close();
  }
}

enum WeatherErrorCode {
  invalidInput,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  tooManyRequests,
  serverError,
  timeout,
  noConnection,
  cancelled,
  parsingError,
  unknown,
}

class WeatherException implements Exception {
  final String message;
  final WeatherErrorCode code;
  final int? statusCode;

  WeatherException({
    required this.message,
    required this.code,
    this.statusCode,
  });

  @override
  String toString() =>
      'WeatherException(code: $code, status: $statusCode, message: $message)';
}
