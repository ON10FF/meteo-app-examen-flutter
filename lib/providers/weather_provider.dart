import 'package:flutter/material.dart';
import 'dart:async';
import '../data/services/weather_service.dart';
import '../data/models/weather_model.dart';
import '../core/constants/api_constants.dart';

class WeatherProvider extends ChangeNotifier {
  double _progress = 0.0;
  int _messageIndex = 0;
  bool _isComplete = false;
  bool _hasError = false;
  String _errorMessage = '';
  List<WeatherModel> _weathers = [];
  Timer? _progressTimer;
  Timer? _messageTimer;

  double get progress => _progress;
  int get messageIndex => _messageIndex;
  bool get isComplete => _isComplete;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  List<WeatherModel> get weathers => _weathers;

  final List<String> messages = [
    'Nous téléchargeons les données...',
    'C\'est presque fini...',
    'Plus que quelques secondes avant d\'avoir le résultat...',
  ];

  final WeatherService _service = WeatherService();

  void startLoading() {
    _reset();
    _startProgressAnimation();
    _startMessageRotation();
    _fetchAllCities();
  }

  void _reset() {
    _progress = 0.0;
    _messageIndex = 0;
    _isComplete = false;
    _hasError = false;
    _errorMessage = '';
    _weathers = [];
    _progressTimer?.cancel();
    _messageTimer?.cancel();
    notifyListeners();
  }

  void _startProgressAnimation() {
    _progressTimer = Timer.periodic(
      const Duration(milliseconds: 200),
          (timer) {
        if (_progress < 0.95) {
          _progress += 0.01;
          notifyListeners();
        } else {
          timer.cancel();
        }
      },
    );
  }

  void _startMessageRotation() {
    _messageTimer = Timer.periodic(
      const Duration(seconds: 3),
          (_) {
        _messageIndex = (_messageIndex + 1) % messages.length;
        notifyListeners();
      },
    );
  }

  Future<void> _fetchAllCities() async {
    try {
      final results = await Future.wait(
        ApiConstants.cities.map((city) => _service.getWeatherForCity(city)),
      );
      _weathers = results;
      _progress = 1.0;
      _isComplete = true;
      _progressTimer?.cancel();
      _messageTimer?.cancel();
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _progressTimer?.cancel();
      _messageTimer?.cancel();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _messageTimer?.cancel();
    super.dispose();
  }
}