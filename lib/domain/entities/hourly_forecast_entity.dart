import 'weather_condition.dart';

class HourlyForecastEntity {
  final DateTime time;
  final double temperature;
  final int precipitationProbability;
  final WeatherCondition condition;
  final double uvIndex;

  const HourlyForecastEntity({
    required this.time,
    required this.temperature,
    required this.precipitationProbability,
    required this.condition,
    required this.uvIndex,
  });
}
