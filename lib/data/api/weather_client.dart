import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/weather_model.dart';

part 'weather_client.g.dart';

@RestApi()
abstract class WeatherClient {
  factory WeatherClient(Dio dio, {String baseUrl}) = _WeatherClient;

  @GET('/weather')
  Future<WeatherModel> getWeather(
    @Query('q') String city,
    @Query('appid') String apiKey,
    @Query('units') String units,
    @Query('lang') String lang,
  );
}
