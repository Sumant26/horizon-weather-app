class MinuteRainPoint {
  final int minuteOffset; // 0 to 59
  final double intensityMmHr; // 0.0 to 20.0 mm/hr

  const MinuteRainPoint({
    required this.minuteOffset,
    required this.intensityMmHr,
  });
}

class MinutePrecipitationEntity {
  final List<MinuteRainPoint> minutePoints; // 60 data points
  final int? onsetMinute; // minute from now when rain starts
  final int? clearanceMinute; // minute from now when rain stops
  final String summaryText;
  final bool hasPrecipitation;

  const MinutePrecipitationEntity({
    required this.minutePoints,
    this.onsetMinute,
    this.clearanceMinute,
    required this.summaryText,
    required this.hasPrecipitation,
  });

  factory MinutePrecipitationEntity.generate({
    required bool isCurrentlyRaining,
    required int precipitationProbability,
    required double hourlyPrecipitationMm,
    required DateTime now,
  }) {
    final List<MinuteRainPoint> points = [];
    int? onset;
    int? clearance;

    if (!isCurrentlyRaining && precipitationProbability < 20) {
      for (int i = 0; i < 60; i++) {
        points.add(MinuteRainPoint(minuteOffset: i, intensityMmHr: 0.0));
      }
      return MinutePrecipitationEntity(
        minutePoints: points,
        summaryText: 'No rain expected in the next 60 minutes.',
        hasPrecipitation: false,
      );
    }

    // Model realistic next-hour rain curve
    if (isCurrentlyRaining) {
      onset = 0;
      clearance = 35; // typical shower duration
      for (int i = 0; i < 60; i++) {
        if (i < 35) {
          final intensity =
              (hourlyPrecipitationMm * (1.0 - (i / 40.0))).clamp(0.4, 8.0);
          points
              .add(MinuteRainPoint(minuteOffset: i, intensityMmHr: intensity));
        } else {
          points.add(MinuteRainPoint(minuteOffset: i, intensityMmHr: 0.0));
        }
      }
      final clearTime = now.add(Duration(minutes: clearance));
      final hourStr = clearTime.hour > 12
          ? clearTime.hour - 12
          : (clearTime.hour == 0 ? 12 : clearTime.hour);
      final ampm = clearTime.hour >= 12 ? 'PM' : 'AM';
      final minStr = clearTime.minute.toString().padLeft(2, '0');
      return MinutePrecipitationEntity(
        minutePoints: points,
        onsetMinute: 0,
        clearanceMinute: clearance,
        summaryText:
            'Rain underway, tapering off around $hourStr:$minStr $ampm.',
        hasPrecipitation: true,
      );
    } else {
      onset = 18;
      clearance = 45;
      for (int i = 0; i < 60; i++) {
        if (i >= 18 && i <= 45) {
          const intensity = 1.8;
          points
              .add(MinuteRainPoint(minuteOffset: i, intensityMmHr: intensity));
        } else {
          points.add(MinuteRainPoint(minuteOffset: i, intensityMmHr: 0.0));
        }
      }
      final clearTime = now.add(Duration(minutes: clearance));
      final hourStr = clearTime.hour > 12
          ? clearTime.hour - 12
          : (clearTime.hour == 0 ? 12 : clearTime.hour);
      final ampm = clearTime.hour >= 12 ? 'PM' : 'AM';
      final minStr = clearTime.minute.toString().padLeft(2, '0');
      return MinutePrecipitationEntity(
        minutePoints: points,
        onsetMinute: onset,
        clearanceMinute: clearance,
        summaryText:
            'Light rain starting in $onset min, tapering off around $hourStr:$minStr $ampm.',
        hasPrecipitation: true,
      );
    }
  }
}
