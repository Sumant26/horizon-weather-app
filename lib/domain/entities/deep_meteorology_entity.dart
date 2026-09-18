class DeepMeteorologyEntity {
  final double visibilityKm;
  final double cloudBaseMeters;
  final double directSolarRadiationWm2;
  final double dewPointDepressionC;

  const DeepMeteorologyEntity({
    required this.visibilityKm,
    required this.cloudBaseMeters,
    required this.directSolarRadiationWm2,
    required this.dewPointDepressionC,
  });

  String get visibilityDescription {
    if (visibilityKm >= 15.0) return 'Exceptional (Pristine)';
    if (visibilityKm >= 10.0) return 'Clear';
    if (visibilityKm >= 5.0) return 'Moderate Haze';
    return 'Dense Mist / Fog';
  }

  String get cloudBaseDescription {
    if (cloudBaseMeters >= 2500) return 'High Cirrus';
    if (cloudBaseMeters >= 1200) return 'Mid Altocumulus';
    return 'Low Stratus Deck';
  }

  double get visibilityMiles => visibilityKm * 0.621371;
  double get cloudBaseFeet => cloudBaseMeters * 3.28084;
}
