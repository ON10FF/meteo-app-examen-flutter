import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/models/weather_model.dart';

class WeatherTable extends StatelessWidget {
  final List<WeatherModel> weathers;
  const WeatherTable({super.key, required this.weathers});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: weathers.length,
      itemBuilder: (context, index) {
        final weather = weathers[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Image.network(
              'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
              width: 50,
              height: 50,
            ),
            title: Text(
              weather.cityName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(weather.description),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${weather.temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${weather.humidity}% 💧',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            onTap: () => Navigator.pushNamed(
              context,
              '/detail',
              arguments: weather,
            ),
          ),
        ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.3);
      },
    );
  }
}