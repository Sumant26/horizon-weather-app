import 'hourly_forecast_entity.dart';

class ActivityProfile {
  final String id;
  final String name;
  final String icon;
  final double minTemp;
  final double maxTemp;
  final double maxWindSpeed;
  final int maxPrecipitationProb;
  final bool isCustom;

  const ActivityProfile({
    required this.id,
    required this.name,
    required this.icon,
    this.minTemp = 14.0,
    this.maxTemp = 24.0,
    this.maxWindSpeed = 25.0,
    this.maxPrecipitationProb = 20,
    this.isCustom = false,
  });

  /// Standard preset activity profiles
  static const List<ActivityProfile> presets = [
    ActivityProfile(
      id: 'running',
      name: 'Running',
      icon: '🏃',
      minTemp: 10.0,
      maxTemp: 22.0,
      maxWindSpeed: 20.0,
      maxPrecipitationProb: 25,
    ),
    ActivityProfile(
      id: 'cycling',
      name: 'Cycling',
      icon: '🚴',
      minTemp: 12.0,
      maxTemp: 26.0,
      maxWindSpeed: 18.0,
      maxPrecipitationProb: 15,
    ),
    ActivityProfile(
      id: 'dog_walking',
      name: 'Dog Walking',
      icon: '🐕',
      minTemp: 8.0,
      maxTemp: 28.0,
      maxWindSpeed: 30.0,
      maxPrecipitationProb: 30,
    ),
    ActivityProfile(
      id: 'tennis',
      name: 'Tennis & Padel',
      icon: '🎾',
      minTemp: 15.0,
      maxTemp: 28.0,
      maxWindSpeed: 15.0,
      maxPrecipitationProb: 10,
    ),
    ActivityProfile(
      id: 'outdoor_dining',
      name: 'Outdoor Dining',
      icon: '🍷',
      minTemp: 18.0,
      maxTemp: 29.0,
      maxWindSpeed: 16.0,
      maxPrecipitationProb: 10,
    ),
    ActivityProfile(
      id: 'photography',
      name: 'Golden Hour Photo',
      icon: '📸',
      minTemp: 5.0,
      maxTemp: 32.0,
      maxWindSpeed: 35.0,
      maxPrecipitationProb: 40,
    ),
    ActivityProfile(
      id: 'stargazing',
      name: 'Stargazing',
      icon: '🔭',
      minTemp: 0.0,
      maxTemp: 25.0,
      maxWindSpeed: 20.0,
      maxPrecipitationProb: 10,
    ),
  ];

  /// Evaluates 24-hour hourly forecast and returns the best matching window description and score.
  String evaluateOptimalWindow(List<HourlyForecastEntity> hourly) {
    if (hourly.isEmpty) {
      return '10:00 AM – 12:00 PM';
    }

    int bestStartIndex = -1;
    double bestScore = -1.0;

    for (int i = 0; i < hourly.length - 2; i++) {
      final hour1 = hourly[i];
      final hour2 = hourly[i + 1];

      // Calculate score based on temperature, wind, and precipitation match
      double score = 0.0;

      // Temp comfort (0-60 pts)
      final avgTemp = (hour1.temperature + hour2.temperature) / 2;
      if (avgTemp >= minTemp && avgTemp <= maxTemp) {
        score += 60.0;
      } else {
        final diff =
            avgTemp < minTemp ? (minTemp - avgTemp) : (avgTemp - maxTemp);
        score += (60.0 - (diff * 5)).clamp(0.0, 60.0);
      }

      // Rain probability & UV comfort (0-40 pts)
      final avgRain =
          (hour1.precipitationProbability + hour2.precipitationProbability) / 2;
      if (avgRain <= maxPrecipitationProb) {
        score += 40.0;
      } else {
        score +=
            (40.0 - (avgRain - maxPrecipitationProb) * 1.5).clamp(0.0, 40.0);
      }

      if (score > bestScore) {
        bestScore = score;
        bestStartIndex = i;
      }
    }

    if (bestStartIndex != -1 && bestStartIndex < hourly.length - 2) {
      final start = hourly[bestStartIndex].time.hour;
      final end = (start + 2) % 24;
      final startStr = _formatHour(start);
      final endStr = _formatHour(end);
      return '$startStr – $endStr';
    }

    return '10:00 AM – 12:00 PM';
  }

  static String _formatHour(int hour) {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:00 $period';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'minTemp': minTemp,
        'maxTemp': maxTemp,
        'maxWindSpeed': maxWindSpeed,
        'maxPrecipitationProb': maxPrecipitationProb,
        'isCustom': isCustom,
      };

  factory ActivityProfile.fromJson(Map<String, dynamic> json) =>
      ActivityProfile(
        id: json['id'] as String? ?? 'custom',
        name: json['name'] as String? ?? 'Custom Activity',
        icon: json['icon'] as String? ?? '🎯',
        minTemp: (json['minTemp'] as num?)?.toDouble() ?? 15.0,
        maxTemp: (json['maxTemp'] as num?)?.toDouble() ?? 25.0,
        maxWindSpeed: (json['maxWindSpeed'] as num?)?.toDouble() ?? 20.0,
        maxPrecipitationProb:
            (json['maxPrecipitationProb'] as num?)?.toInt() ?? 20,
        isCustom: json['isCustom'] as bool? ?? true,
      );
}
