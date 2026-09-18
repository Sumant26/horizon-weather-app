import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/domain/entities/journey_entity.dart';
import 'package:horizon/domain/entities/weather_condition.dart';

void main() {
  group('JourneyEntity Tests', () {
    test('simulates optimal safety corridor during calm conditions', () {
      final journey = JourneyEntity.simulate(
        origin: 'Shivajinagar',
        destination: 'Baner Hills',
        baseTemp: 28.0,
        baseCondition: WeatherCondition.clearDay,
        baseWindSpeed: 12.0,
        basePrecipitationProb: 0.0,
      );

      expect(journey.safetyTier, TravelSafetyTier.optimal);
      expect(journey.safetyScore, greaterThanOrEqualTo(80));
      expect(journey.waypoints.length, 3);
      expect(journey.waypoints.first.label, 'Shivajinagar');
      expect(journey.waypoints.last.label, 'Baner Hills');
    });

    test('simulates cautious/severe safety corridor during high rain and wind',
        () {
      final journey = JourneyEntity.simulate(
        origin: 'Shivajinagar',
        destination: 'Hinjawadi',
        baseTemp: 22.0,
        baseCondition: WeatherCondition.thunderstorm,
        baseWindSpeed: 48.0,
        basePrecipitationProb: 80.0,
      );

      expect(journey.safetyScore, lessThan(60));
      expect(journey.safetyTier,
          isIn([TravelSafetyTier.cautious, TravelSafetyTier.severe]));
    });
  });
}
