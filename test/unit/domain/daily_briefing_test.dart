import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/domain/entities/daily_briefing_entity.dart';
import 'package:horizon/domain/entities/weather_condition.dart';

void main() {
  group('DailyBriefingEntity Tests', () {
    test('computes morning greeting and birdsong soundscape for clear day', () {
      final briefing = DailyBriefingEntity.compute(
        timestamp: DateTime(2026, 9, 16, 7, 30),
        locationName: 'Shivajinagar Node',
        currentTemp: 22.0,
        tempDiffYesterday: 1.5,
        condition: WeatherCondition.clearDay,
        optimalWindow: '6:30 AM – 8:30 AM',
      );

      expect(briefing.period, BriefingPeriod.morning);
      expect(briefing.greeting, contains('Good morning, Shivajinagar Node'));
      expect(briefing.narrative, contains('1.5°C warmer than yesterday'));
      expect(briefing.recommendedSoundscape, SoundscapeType.morningBirdsong);
    });

    test('computes rain soundscape and narrative during rainy conditions', () {
      final briefing = DailyBriefingEntity.compute(
        timestamp: DateTime(2026, 9, 16, 14, 0),
        locationName: 'Koregaon Park',
        currentTemp: 24.0,
        tempDiffYesterday: -2.0,
        condition: WeatherCondition.rainy,
        optimalWindow: '11:00 AM – 1:00 PM',
      );

      expect(briefing.period, BriefingPeriod.afternoon);
      expect(briefing.narrative, contains('2.0°C cooler than yesterday'));
      expect(
          briefing.narrative, contains('Atmospheric precipitation is active'));
      expect(briefing.recommendedSoundscape, SoundscapeType.gentleRain);
    });
  });
}
