// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherModel _$WeatherModelFromJson(Map<String, dynamic> json) => WeatherModel(
  name: json['name'] as String,
  main: MainData.fromJson(json['main'] as Map<String, dynamic>),
  weather: (json['weather'] as List<dynamic>)
      .map((e) => WeatherInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
  wind: WindData.fromJson(json['wind'] as Map<String, dynamic>),
  coord: CoordData.fromJson(json['coord'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WeatherModelToJson(WeatherModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'main': instance.main.toJson(),
      'weather': instance.weather.map((e) => e.toJson()).toList(),
      'wind': instance.wind.toJson(),
      'coord': instance.coord.toJson(),
    };

MainData _$MainDataFromJson(Map<String, dynamic> json) => MainData(
  rawTemp: json['temp'] as num,
  rawFeelsLike: json['feels_like'] as num,
  rawHumidity: json['humidity'] as num,
);

Map<String, dynamic> _$MainDataToJson(MainData instance) => <String, dynamic>{
  'temp': instance.rawTemp,
  'feels_like': instance.rawFeelsLike,
  'humidity': instance.rawHumidity,
};

WeatherInfo _$WeatherInfoFromJson(Map<String, dynamic> json) => WeatherInfo(
  description: json['description'] as String,
  icon: json['icon'] as String,
);

Map<String, dynamic> _$WeatherInfoToJson(WeatherInfo instance) =>
    <String, dynamic>{
      'description': instance.description,
      'icon': instance.icon,
    };

WindData _$WindDataFromJson(Map<String, dynamic> json) =>
    WindData(rawSpeed: json['speed'] as num);

Map<String, dynamic> _$WindDataToJson(WindData instance) => <String, dynamic>{
  'speed': instance.rawSpeed,
};

CoordData _$CoordDataFromJson(Map<String, dynamic> json) =>
    CoordData(rawLat: json['lat'] as num, rawLon: json['lon'] as num);

Map<String, dynamic> _$CoordDataToJson(CoordData instance) => <String, dynamic>{
  'lat': instance.rawLat,
  'lon': instance.rawLon,
};
