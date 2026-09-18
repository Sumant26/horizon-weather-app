enum PressureTrend { rising, steady, droppingFast }

enum PollenLevel { low, moderate, elevated, high }

class BiophilicHealthEntity {
  final double surfacePressureHpa;
  final double pressureDelta12h;
  final PressureTrend pressureTrend;
  final String headacheRiskStatus;
  final String headacheAdvice;

  final PollenLevel treePollen;
  final PollenLevel grassPollen;
  final PollenLevel weedPollen;
  final String overallAllergenAdvice;

  final String vitaminDWindow;
  final String vitaminDAdvice;
  final double dewPoint;
  final String breathabilityScore;

  const BiophilicHealthEntity({
    required this.surfacePressureHpa,
    required this.pressureDelta12h,
    required this.pressureTrend,
    required this.headacheRiskStatus,
    required this.headacheAdvice,
    required this.treePollen,
    required this.grassPollen,
    required this.weedPollen,
    required this.overallAllergenAdvice,
    required this.vitaminDWindow,
    required this.vitaminDAdvice,
    required this.dewPoint,
    required this.breathabilityScore,
  });

  factory BiophilicHealthEntity.evaluate({
    required double surfacePressureHpa,
    required double pressureDelta12h,
    required double uvIndex,
    required double humidity,
    required double temperature,
  }) {
    // 1. Barometric Pressure & Migraine Evaluation
    PressureTrend trend;
    String risk;
    String advice;

    if (pressureDelta12h < -4.0) {
      trend = PressureTrend.droppingFast;
      risk = 'Elevated Headache Sensitivity';
      advice =
          'Rapid barometric drop detected. Weather-sensitive individuals may experience sinus pressure or migraines.';
    } else if (pressureDelta12h > 3.0) {
      trend = PressureTrend.rising;
      risk = 'Rising Atmospheric Pressure';
      advice = 'Clearing weather front. Stable barometric equilibrium.';
    } else {
      trend = PressureTrend.steady;
      risk = 'Stable Barometric Equilibrium';
      advice =
          'Atmospheric pressure is steady. Minimal risk of weather-induced headaches.';
    }

    // 2. Pollen Allergens
    final PollenLevel tree =
        humidity < 45 ? PollenLevel.moderate : PollenLevel.low;
    final PollenLevel grass =
        humidity > 70 ? PollenLevel.low : PollenLevel.moderate;
    const PollenLevel weed = PollenLevel.low;
    final String pollenAdvice = tree == PollenLevel.low &&
            grass == PollenLevel.low
        ? 'Pristine pollen count. Ideal day to keep windows open for fresh ventilation.'
        : 'Moderate pollen dispersion. Sensitive individuals should consider evening airing.';

    // 3. Circadian Sunlight & Vitamin D
    String vitDWindow;
    String vitDAdvice;
    if (uvIndex >= 4.0) {
      vitDWindow = '11:00 AM – 1:30 PM (15–20 mins)';
      vitDAdvice =
          'Natural UV levels allow rapid skin Vitamin D synthesis without prolonged exposure.';
    } else if (uvIndex >= 2.0) {
      vitDWindow = '12:00 PM – 2:30 PM (25–30 mins)';
      vitDAdvice =
          'Soft diffuse sunlight. Pleasant time for a gentle outdoor walk.';
    } else {
      vitDWindow = 'Limited Natural UV Today';
      vitDAdvice =
          'Low solar intensity. Rely on dietary sources or ambient daylight for circadian alignment.';
    }

    // 4. Dew Point & Breathability
    // Approximation: Td ≈ T - ((100 - RH)/5)
    final dew = temperature - ((100 - humidity) / 5);
    String breathability;
    if (dew < 10) {
      breathability = 'Crisp & Refreshing';
    } else if (dew <= 18) {
      breathability = 'Comfortable Equilibrium';
    } else if (dew <= 22) {
      breathability = 'Humid & Heavy';
    } else {
      breathability = 'Muggy & Oppressive';
    }

    return BiophilicHealthEntity(
      surfacePressureHpa: surfacePressureHpa,
      pressureDelta12h: pressureDelta12h,
      pressureTrend: trend,
      headacheRiskStatus: risk,
      headacheAdvice: advice,
      treePollen: tree,
      grassPollen: grass,
      weedPollen: weed,
      overallAllergenAdvice: pollenAdvice,
      vitaminDWindow: vitDWindow,
      vitaminDAdvice: vitDAdvice,
      dewPoint: dew,
      breathabilityScore: breathability,
    );
  }
}
