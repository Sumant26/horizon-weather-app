class AirQualityEntity {
  final double pm2_5;
  final double pm10;
  final int aqi;
  final double? ozone;
  final String status;
  final String recommendation;

  const AirQualityEntity({
    required this.pm2_5,
    required this.pm10,
    required this.aqi,
    this.ozone,
    required this.status,
    required this.recommendation,
  });

  factory AirQualityEntity.fromValues({
    required double pm2_5,
    required double pm10,
    required int aqi,
    double? ozone,
  }) {
    String status;
    String recommendation;

    if (aqi <= 30) {
      status = 'Pure & Crisp';
      recommendation =
          'Air quality is pristine. Perfect for deep breaths and outdoor walks.';
    } else if (aqi <= 60) {
      status = 'Good';
      recommendation =
          'Fresh air quality. Ideal for jogging, cycling, and sitting outdoors.';
    } else if (aqi <= 100) {
      status = 'Moderate';
      recommendation =
          'Acceptable air. Sensitive individuals may take gentle precautions.';
    } else if (aqi <= 150) {
      status = 'Hazy / Unhealthy for Sensitive';
      recommendation =
          'Elevated fine particles. Consider shortening intense outdoor sessions.';
    } else {
      status = 'Poor Air Quality';
      recommendation =
          'Atmospheric stagnation. Best to keep windows closed and rest indoors.';
    }

    return AirQualityEntity(
      pm2_5: pm2_5,
      pm10: pm10,
      aqi: aqi,
      ozone: ozone,
      status: status,
      recommendation: recommendation,
    );
  }
}
