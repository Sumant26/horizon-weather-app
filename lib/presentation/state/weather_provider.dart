import 'package:flutter/material.dart';
import '../../data/models/weather_model.dart';
import '../../data/repositories/weather_repository.dart';

sealed class WeatherState { const WeatherState(); }
class WeatherLoading extends WeatherState { const WeatherLoading(); }
class WeatherError extends WeatherState { final String message; const WeatherError(this.message); }
class WeatherLoaded extends WeatherState { 
  final WeatherData data; 
  const WeatherLoaded(this.data); 
}

class WeatherNotifier extends ValueNotifier<WeatherState> {
  final WeatherRepository _repository;

  WeatherNotifier(this._repository) : super(const WeatherLoading());

  Future<void> refreshForecast() async {
    try {
      final data = await _repository.fetchLocalMicroclimateForecast();
      value = WeatherLoaded(data);
    } catch (e) {
      value = const WeatherError("Unable to securely synchronize with your local node.");
    }
  }
}
