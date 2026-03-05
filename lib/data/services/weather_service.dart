import 'package:dio/dio.dart';
import '../models/weather_model.dart';
import '../../core/constants/api_constants.dart';

class WeatherService {
  final Dio _dio;

  WeatherService() : _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<WeatherModel> getWeatherForCity(String city) async {
    try {
      final response = await _dio.get('/weather', queryParameters: {
        'q': city,
        'appid': ApiConstants.apiKey,
        'units': ApiConstants.units,
        'lang': ApiConstants.lang,
      });
      return WeatherModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connexion trop lente. Vérifiez votre réseau.');
      case DioExceptionType.receiveTimeout:
        return Exception('Le serveur ne répond pas.');
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 401) {
          return Exception('Clé API invalide.');
        }
        return Exception('Erreur serveur: ${e.response?.statusCode}');
      default:
        return Exception('Erreur réseau. Vérifiez votre connexion.');
    }
  }
}