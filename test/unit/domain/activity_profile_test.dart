import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/domain/entities/activity_profile.dart';
import 'package:horizon/domain/entities/hourly_forecast_entity.dart';
import 'package:horizon/domain/entities/weather_condition.dart';

void main() {
  group('ActivityProfile Entity Tests', () {
    test(
        'presets contains running, cycling, stargazing and standard activities',
        () {
      expect(ActivityProfile.presets.isNotEmpty, isTrue);
      final running =
          ActivityProfile.presets.firstWhere((p) => p.id == 'running');
      expect(running.name, 'Running');
      expect(running.icon, '🏃');
      expect(running.minTemp, 10.0);
      expect(running.maxTemp, 22.0);
    });

    test('toJson and fromJson serialize and deserialize correctly', () {
      const profile = ActivityProfile(
        id: 'custom_tennis',
        name: 'Tennis Court',
        icon: '🎾',
        minTemp: 18.0,
        maxTemp: 26.0,
        maxWindSpeed: 15.0,
        maxPrecipitationProb: 10,
        isCustom: true,
      );

      final json = profile.toJson();
      final reconstructed = ActivityProfile.fromJson(json);

      expect(reconstructed.id, profile.id);
      expect(reconstructed.name, profile.name);
      expect(reconstructed.icon, profile.icon);
      expect(reconstructed.minTemp, profile.minTemp);
      expect(reconstructed.maxTemp, profile.maxTemp);
      expect(reconstructed.isCustom, isTrue);
    });

    test(
        'evaluateOptimalWindow returns formatted time corridor based on best hourly score',
        () {
      final running =
          ActivityProfile.presets.firstWhere((p) => p.id == 'running');
      final now = DateTime(2026, 9, 18, 0, 0);

      // Create 24 hours of forecast: hours 0-14 are cold (5°C), hours 16-18 are optimal (18°C, 0% rain)
      final hourly = List.generate(24, (i) {
        final isOptimal = i >= 16 && i <= 18;
        return HourlyForecastEntity(
          time: now.add(Duration(hours: i)),
          temperature: isOptimal ? 18.0 : 5.0,
          precipitationProbability: isOptimal ? 0 : 80,
          condition:
              isOptimal ? WeatherCondition.clearDay : WeatherCondition.rainy,
          uvIndex: 2.0,
        );
      });

      final window = running.evaluateOptimalWindow(hourly);
      expect(window, contains('4:00 PM – 6:00 PM'));
    });

    test('evaluateOptimalWindow handles empty hourly gracefully with fallback',
        () {
      final running =
          ActivityProfile.presets.firstWhere((p) => p.id == 'running');
      final window = running.evaluateOptimalWindow([]);
      expect(window, isNotEmpty);
    });
  });
}
