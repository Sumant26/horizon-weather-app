import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/domain/entities/thermal_comfort_entity.dart';

void main() {
  group('ThermalComfortEntity Tests', () {
    test('computes solar radiation load and humidity factor accurately', () {
      final comfort = ThermalComfortEntity.compute(
        ambientTemp: 31.0,
        humidity: 68.0,
        windSpeedKmh: 8.0,
        uvIndex: 6.5,
        isDaytime: true,
      );

      expect(comfort.ambientTemp, 31.0);
      expect(comfort.solarRadiationDelta, greaterThan(0.0));
      expect(comfort.humidityDelta, greaterThan(0.0));
      expect(comfort.feelsLikeTemp, greaterThan(comfort.ambientTemp));
      expect(comfort.clothingInsulationClo, lessThanOrEqualTo(0.60));
    });

    test('computes wind-chill convective cooling during brisk weather', () {
      final comfort = ThermalComfortEntity.compute(
        ambientTemp: 14.0,
        humidity: 35.0,
        windSpeedKmh: 28.0,
        uvIndex: 1.0,
        isDaytime: false,
      );

      expect(comfort.solarRadiationDelta, 0.0);
      expect(comfort.windChillDelta, lessThan(0.0));
      expect(comfort.feelsLikeTemp, lessThan(comfort.ambientTemp));
      expect(comfort.clothingInsulationClo, greaterThanOrEqualTo(1.0));
    });
  });
}
