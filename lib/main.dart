import 'package:flutter/material.dart';

import 'data/services/weather_repository.dart';
import 'data/models/weather_model.dart';

void main() {
  runApp(const WeatherTestApp());
}

class WeatherTestApp extends StatelessWidget {
  const WeatherTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test API Météo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const WeatherTestScreen(),
    );
  }
}

class WeatherTestScreen extends StatefulWidget {
  const WeatherTestScreen({super.key});

  @override
  State<WeatherTestScreen> createState() => _WeatherTestScreenState();
}

class _WeatherTestScreenState extends State<WeatherTestScreen> {
  final TextEditingController _cityController = TextEditingController();
  final WeatherRepository _repository = WeatherRepository();

  bool _isLoading = false;
  String? _errorMessage;
  WeatherModel? _weatherData;

  @override
  void dispose() {
    _cityController.dispose();
    _repository.dispose();
    super.dispose();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _weatherData = null;
    });

    try {
      final weather = await _repository.getWeather(_cityController.text);
      setState(() {
        _weatherData = weather;
        _isLoading = false;
      });
    } on WeatherException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur inattendue : $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌤️ Test API Météo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Nom de la ville',
                hintText: 'Ex: Paris, Dakar, Lyon...',
                prefixIcon: Icon(Icons.location_city),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _fetchWeather(),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _isLoading ? null : _fetchWeather,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_download),
              label: Text(_isLoading ? 'Chargement...' : 'Tester l\'API'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),

            const SizedBox(height: 24),

            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if (_weatherData != null) _buildWeatherCard(_weatherData!),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard(WeatherModel weather) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  weather.iconUrl,
                  width: 64,
                  height: 64,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.cloud, size: 64),
                ),
                const SizedBox(width: 8),
                Text(
                  weather.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              weather.description,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),

            const Divider(height: 32),

            _buildDataRow(
              '🌡️ Température',
              '${weather.main.temp.toStringAsFixed(1)}°C',
            ),
            _buildDataRow(
              '🤔 Ressenti',
              '${weather.main.feelsLike.toStringAsFixed(1)}°C',
            ),
            _buildDataRow('💧 Humidité', '${weather.main.humidity}%'),
            _buildDataRow(
              '💨 Vent',
              '${weather.wind.speed.toStringAsFixed(1)} m/s',
            ),
            _buildDataRow('📍 Latitude', '${weather.coord.lat}'),
            _buildDataRow('📍 Longitude', '${weather.coord.lon}'),
            _buildDataRow('🖼️ Icône', weather.icon),

            const Divider(height: 32),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '✅ API OK — Parsing JSON réussi !',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
