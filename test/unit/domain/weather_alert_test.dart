import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/domain/entities/weather_alert_entity.dart';
import 'package:horizon/domain/entities/weather_condition.dart';

void main() {
  group('WeatherAlertEntity Tests', () {
    test('detects high wind and gale alerts', () {
      final alertEntity = WeatherAlertEntity.evaluate(
        temperature: 20.0,
        windSpeedKmh: 52.0,
        gustKmh: 65.0,
        uvIndex: 4.0,
        condition: WeatherCondition.overcast,
        tempDifferenceYesterday: 0.0,
      );

      expect(alertEntity.hasAlerts, isTrue);
      expect(alertEntity.activeAlerts.any((a) => a.title.contains('High Wind')),
          isTrue);
    });

    test('detects extreme solar UV advisory', () {
      final alertEntity = WeatherAlertEntity.evaluate(
        temperature: 28.0,
        windSpeedKmh: 10.0,
        gustKmh: null,
        uvIndex: 9.5,
        condition: WeatherCondition.clearDay,
        tempDifferenceYesterday: 0.0,
      );

      expect(alertEntity.hasAlerts, isTrue);
      expect(alertEntity.activeAlerts.any((a) => a.title.contains('Solar')),
          isTrue);
    });

    test('detects thunderstorm warning', () {
      final alertEntity = WeatherAlertEntity.evaluate(
        temperature: 19.0,
        windSpeedKmh: 20.0,
        gustKmh: null,
        uvIndex: 1.0,
        condition: WeatherCondition.thunderstorm,
        tempDifferenceYesterday: 0.0,
      );

      expect(alertEntity.hasAlerts, isTrue);
      expect(
          alertEntity.activeAlerts
              .any((a) => a.title.contains('Thunderstorm Warning')),
          isTrue);
    });

    test('detects rapid cooling trend / atmospheric front', () {
      final alertEntity = WeatherAlertEntity.evaluate(
        temperature: 12.0,
        windSpeedKmh: 15.0,
        gustKmh: null,
        uvIndex: 2.0,
        condition: WeatherCondition.overcast,
        tempDifferenceYesterday: -5.5,
      );

      expect(alertEntity.hasAlerts, isTrue);
      expect(
          alertEntity.activeAlerts
              .any((a) => a.title.contains('Sharp Cooling Trend')),
          isTrue);
    });

    test('returns empty alerts when conditions are calm and pleasant', () {
      final alertEntity = WeatherAlertEntity.evaluate(
        temperature: 22.0,
        windSpeedKmh: 10.0,
        gustKmh: null,
        uvIndex: 4.0,
        condition: WeatherCondition.clearDay,
        tempDifferenceYesterday: 1.0,
      );

      expect(alertEntity.hasAlerts, isFalse);
      expect(alertEntity.activeAlerts, isEmpty);
    });
  });
}
