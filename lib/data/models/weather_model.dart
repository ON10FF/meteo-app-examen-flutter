import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WeatherModel {
  final String name;
  final MainData main;
  final List<WeatherInfo> weather;
  final WindData wind;
  final CoordData coord;

  WeatherModel({
    required this.name,
    required this.main,
    required this.weather,
    required this.wind,
    required this.coord,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);

  String get description =>
      weather.isNotEmpty ? weather[0].description : 'Inconnu';

  String get icon => weather.isNotEmpty ? weather[0].icon : '01d';

  /// URL complète de l'icône météo
  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';

  @override
  String toString() {
    return '''
🏙️ Ville : $name
🌡️ Température : ${main.temp}°C (ressenti ${main.feelsLike}°C)
💧 Humidité : ${main.humidity}%
🌤️ Météo : $description
💨 Vent : ${wind.speed} m/s
📍 Coordonnées : ${coord.lat}, ${coord.lon}
🖼️ Icône : $icon
''';
  }
}

@JsonSerializable()
class MainData {
  @JsonKey(name: 'temp')
  final num rawTemp;

  @JsonKey(name: 'feels_like')
  final num rawFeelsLike;

  @JsonKey(name: 'humidity')
  final num rawHumidity;

  MainData({
    required this.rawTemp,
    required this.rawFeelsLike,
    required this.rawHumidity,
  });

  double get temp => rawTemp.toDouble();

  double get feelsLike => rawFeelsLike.toDouble();

  int get humidity => rawHumidity.toInt();

  factory MainData.fromJson(Map<String, dynamic> json) =>
      _$MainDataFromJson(json);

  Map<String, dynamic> toJson() => _$MainDataToJson(this);
}

@JsonSerializable()
class WeatherInfo {
  final String description;
  final String icon;

  WeatherInfo({required this.description, required this.icon});

  factory WeatherInfo.fromJson(Map<String, dynamic> json) =>
      _$WeatherInfoFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherInfoToJson(this);
}

@JsonSerializable()
class WindData {
  @JsonKey(name: 'speed')
  final num rawSpeed;

  WindData({required this.rawSpeed});

  double get speed => rawSpeed.toDouble();

  factory WindData.fromJson(Map<String, dynamic> json) =>
      _$WindDataFromJson(json);

  Map<String, dynamic> toJson() => _$WindDataToJson(this);
}

@JsonSerializable()
class CoordData {
  @JsonKey(name: 'lat')
  final num rawLat;

  @JsonKey(name: 'lon')
  final num rawLon;

  CoordData({required this.rawLat, required this.rawLon});

  double get lat => rawLat.toDouble();

  double get lon => rawLon.toDouble();

  factory CoordData.fromJson(Map<String, dynamic> json) =>
      _$CoordDataFromJson(json);

  Map<String, dynamic> toJson() => _$CoordDataToJson(this);
}
