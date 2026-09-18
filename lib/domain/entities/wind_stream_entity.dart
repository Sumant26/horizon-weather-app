class WindStreamEntity {
  final double speedKmh;
  final double gustKmh;
  final double directionDegrees; // 0 - 360
  final String cardinalBearing; // N, NE, E, SE, S, SW, W, NW
  final String beaufortScale; // e.g. "Gentle Breeze", "Moderate Breeze"

  const WindStreamEntity({
    required this.speedKmh,
    required this.gustKmh,
    required this.directionDegrees,
    required this.cardinalBearing,
    required this.beaufortScale,
  });

  factory WindStreamEntity.fromValues({
    required double speedKmh,
    double? gustKmh,
    required double directionDegrees,
  }) {
    final bearing = _degreesToBearing(directionDegrees);
    final beaufort = _speedToBeaufort(speedKmh);
    return WindStreamEntity(
      speedKmh: speedKmh,
      gustKmh: gustKmh ?? (speedKmh * 1.35),
      directionDegrees: directionDegrees,
      cardinalBearing: bearing,
      beaufortScale: beaufort,
    );
  }

  static String _degreesToBearing(double degrees) {
    const directions = [
      'N',
      'NNE',
      'NE',
      'ENE',
      'E',
      'ESE',
      'SE',
      'SSE',
      'S',
      'SSW',
      'SW',
      'WSW',
      'W',
      'WNW',
      'NW',
      'NNW'
    ];
    final idx = ((degrees + 11.25) % 360 / 22.5).floor();
    return directions[idx % 16];
  }

  static String _speedToBeaufort(double kmh) {
    if (kmh < 1) return 'Calm';
    if (kmh <= 5) return 'Light Air';
    if (kmh <= 11) return 'Light Breeze';
    if (kmh <= 19) return 'Gentle Breeze';
    if (kmh <= 28) return 'Moderate Breeze';
    if (kmh <= 38) return 'Fresh Breeze';
    if (kmh <= 49) return 'Strong Breeze';
    if (kmh <= 61) return 'Near Gale';
    if (kmh <= 74) return 'Gale';
    return 'Strong Gale';
  }
}
