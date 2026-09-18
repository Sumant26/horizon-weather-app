import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/domain/entities/biophilic_health_entity.dart';

void main() {
  group('BiophilicHealthEntity Tests', () {
    test('detects rapid barometric pressure drop and flags headache risk', () {
      final bio = BiophilicHealthEntity.evaluate(
        surfacePressureHpa: 1004.0,
        pressureDelta12h: -5.5,
        uvIndex: 4.0,
        humidity: 60.0,
        temperature: 22.0,
      );

      expect(bio.pressureTrend, equals(PressureTrend.droppingFast));
      expect(bio.headacheRiskStatus, contains('Elevated Headache Sensitivity'));
      expect(bio.headacheAdvice, contains('sinus pressure or migraines'));
    });

    test('evaluates steady barometric pressure under stable fronts', () {
      final bio = BiophilicHealthEntity.evaluate(
        surfacePressureHpa: 1016.0,
        pressureDelta12h: 0.5,
        uvIndex: 5.0,
        humidity: 45.0,
        temperature: 24.0,
      );

      expect(bio.pressureTrend, equals(PressureTrend.steady));
      expect(bio.headacheRiskStatus, contains('Stable'));
    });

    test('computes Vitamin D circadian exposure window for high UV', () {
      final bioHighUv = BiophilicHealthEntity.evaluate(
        surfacePressureHpa: 1013.0,
        pressureDelta12h: 0.0,
        uvIndex: 6.0,
        humidity: 40.0,
        temperature: 26.0,
      );

      expect(bioHighUv.vitaminDWindow, contains('11:00 AM – 1:30 PM'));
      expect(
          bioHighUv.vitaminDAdvice, contains('rapid skin Vitamin D synthesis'));
    });

    test('calculates dew point and breathability comfort scores', () {
      final crisp = BiophilicHealthEntity.evaluate(
        surfacePressureHpa: 1015.0,
        pressureDelta12h: 0.0,
        uvIndex: 3.0,
        humidity: 40.0,
        temperature: 18.0,
      );

      expect(crisp.breathabilityScore, equals('Crisp & Refreshing'));
    });
  });
}
