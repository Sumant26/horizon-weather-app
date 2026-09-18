import 'weather_condition.dart';

class DailyForecastEntity {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final WeatherCondition condition;
  final DateTime sunrise;
  final DateTime sunset;
  final double maxUvIndex;

  const DailyForecastEntity({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.sunrise,
    required this.sunset,
    required this.maxUvIndex,
  });
}
