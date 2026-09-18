class AstronomyEntity {
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime? goldenHourMorning;
  final DateTime? goldenHourEvening;
  final double sunProgress; // 0.0 at sunrise, 0.5 at noon, 1.0 at sunset
  final bool isDaylight;

  const AstronomyEntity({
    required this.sunrise,
    required this.sunset,
    this.goldenHourMorning,
    this.goldenHourEvening,
    required this.sunProgress,
    required this.isDaylight,
  });

  factory AstronomyEntity.fromTimes({
    required DateTime sunrise,
    required DateTime sunset,
    required DateTime now,
  }) {
    final isDaylight = now.isAfter(sunrise) && now.isBefore(sunset);
    final totalDaylightMinutes = sunset.difference(sunrise).inMinutes;
    final elapsedMinutes = now.difference(sunrise).inMinutes;

    double progress = 0.0;
    if (totalDaylightMinutes > 0) {
      progress = (elapsedMinutes / totalDaylightMinutes).clamp(0.0, 1.0);
    }

    return AstronomyEntity(
      sunrise: sunrise,
      sunset: sunset,
      goldenHourMorning: sunrise.add(const Duration(minutes: 45)),
      goldenHourEvening: sunset.subtract(const Duration(minutes: 45)),
      sunProgress: progress,
      isDaylight: isDaylight,
    );
  }
}
