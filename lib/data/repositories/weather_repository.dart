import 'dart:math';
import '../models/weather_model.dart';

class WeatherRepository {
  // Simulates an end-to-end stripped, performance-optimized response from a reverse proxy architecture
  Future<WeatherData> fetchLocalMicroclimateForecast() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Ultra snappy response simulation
    
    final now = DateTime.now();
    final isNight = now.hour < 6 || now.hour > 18;
    
    // Simulating localized weather fluctuations safely
    final dynamicConditions = [
      WeatherCondition.clearDay, 
      WeatherCondition.overcast, 
      WeatherCondition.rainy
    ];
    final activeDayCondition = dynamicConditions[Random().nextInt(dynamicConditions.length)];

    return WeatherData(
      temperature: isNight ? 20.4 : 29.8,
      tempDifferenceYesterday: -2.3, 
      humidity: isNight ? 72.0 : 48.0,
      uvIndex: isNight ? 0.0 : 6.8,
      cloudCover: isNight ? 0.05 : 0.2,
      condition: isNight ? WeatherCondition.clearNight : activeDayCondition,
      timestamp: now,
      neighborhoodName: "Shivajinagar Node",
    );
  }
}
