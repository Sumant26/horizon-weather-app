import '../entities/biophilic_health_entity.dart';

class CalculateBiophilicMetrics {
  const CalculateBiophilicMetrics();

  BiophilicHealthEntity call({
    required double surfacePressureHpa,
    required double pressureDelta12h,
    required double uvIndex,
    required double humidity,
    required double temperature,
  }) {
    return BiophilicHealthEntity.evaluate(
      surfacePressureHpa: surfacePressureHpa,
      pressureDelta12h: pressureDelta12h,
      uvIndex: uvIndex,
      humidity: humidity,
      temperature: temperature,
    );
  }
}
