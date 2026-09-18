import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/domain/entities/deep_meteorology_entity.dart';

void main() {
  group('DeepMeteorologyEntity Tests', () {
    test('evaluates visibility and cloud ceiling descriptions accurately', () {
      const deepMetPristine = DeepMeteorologyEntity(
        visibilityKm: 22.0,
        cloudBaseMeters: 3000.0,
        directSolarRadiationWm2: 850.0,
        dewPointDepressionC: 12.0,
      );

      expect(deepMetPristine.visibilityDescription, contains('Exceptional'));
      expect(deepMetPristine.cloudBaseDescription, contains('High Cirrus'));
      expect(deepMetPristine.visibilityMiles, closeTo(13.67, 0.1));
      expect(deepMetPristine.cloudBaseFeet, closeTo(9842.5, 0.5));

      const deepMetFog = DeepMeteorologyEntity(
        visibilityKm: 2.5,
        cloudBaseMeters: 400.0,
        directSolarRadiationWm2: 50.0,
        dewPointDepressionC: 0.8,
      );

      expect(deepMetFog.visibilityDescription, contains('Dense Mist'));
      expect(deepMetFog.cloudBaseDescription, contains('Low Stratus'));
    });
  });
}
