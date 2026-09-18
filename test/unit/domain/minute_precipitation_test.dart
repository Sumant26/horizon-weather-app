import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/domain/entities/minute_precipitation_entity.dart';

void main() {
  group('MinutePrecipitationEntity Tests', () {
    final now = DateTime(2026, 10, 14, 15, 30);

    test('generates dry 60-minute curve when no precipitation is present', () {
      final precip = MinutePrecipitationEntity.generate(
        isCurrentlyRaining: false,
        precipitationProbability: 5,
        hourlyPrecipitationMm: 0.0,
        now: now,
      );

      expect(precip.hasPrecipitation, isFalse);
      expect(precip.minutePoints.length, equals(60));
      expect(precip.minutePoints.every((p) => p.intensityMmHr == 0.0), isTrue);
      expect(precip.summaryText, contains('No rain expected'));
    });

    test('generates ongoing rain curve tapering off when currently raining',
        () {
      final precip = MinutePrecipitationEntity.generate(
        isCurrentlyRaining: true,
        precipitationProbability: 95,
        hourlyPrecipitationMm: 4.5,
        now: now,
      );

      expect(precip.hasPrecipitation, isTrue);
      expect(precip.onsetMinute, equals(0));
      expect(precip.clearanceMinute, equals(35));
      expect(precip.minutePoints.first.intensityMmHr, greaterThan(0.0));
      expect(precip.summaryText, contains('Rain underway'));
    });

    test('generates upcoming rain onset curve when rain is imminent', () {
      final precip = MinutePrecipitationEntity.generate(
        isCurrentlyRaining: false,
        precipitationProbability: 75,
        hourlyPrecipitationMm: 2.0,
        now: now,
      );

      expect(precip.hasPrecipitation, isTrue);
      expect(precip.onsetMinute, equals(18));
      expect(precip.clearanceMinute, equals(45));
      expect(precip.minutePoints[0].intensityMmHr, equals(0.0));
      expect(precip.minutePoints[20].intensityMmHr, greaterThan(0.0));
      expect(precip.summaryText, contains('Light rain starting in 18 min'));
    });
  });
}
