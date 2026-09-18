import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/domain/entities/wind_stream_entity.dart';

void main() {
  group('WindStreamEntity Tests', () {
    test('converts degrees to correct cardinal bearings', () {
      final north =
          WindStreamEntity.fromValues(speedKmh: 10, directionDegrees: 0);
      expect(north.cardinalBearing, equals('N'));

      final east =
          WindStreamEntity.fromValues(speedKmh: 10, directionDegrees: 90);
      expect(east.cardinalBearing, equals('E'));

      final ssw =
          WindStreamEntity.fromValues(speedKmh: 15, directionDegrees: 200);
      expect(ssw.cardinalBearing, equals('SSW'));

      final northwest =
          WindStreamEntity.fromValues(speedKmh: 15, directionDegrees: 315);
      expect(northwest.cardinalBearing, equals('NW'));
    });

    test('maps wind speed to accurate Beaufort scale names', () {
      final calm =
          WindStreamEntity.fromValues(speedKmh: 0.5, directionDegrees: 180);
      expect(calm.beaufortScale, equals('Calm'));

      final gentle =
          WindStreamEntity.fromValues(speedKmh: 15, directionDegrees: 180);
      expect(gentle.beaufortScale, equals('Gentle Breeze'));

      final strong =
          WindStreamEntity.fromValues(speedKmh: 45, directionDegrees: 180);
      expect(strong.beaufortScale, equals('Strong Breeze'));
    });
  });
}
