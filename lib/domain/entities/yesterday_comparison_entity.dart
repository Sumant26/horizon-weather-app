class YesterdayComparisonEntity {
  final List<double> todayHourlyTemps; // 24 values
  final List<double> yesterdayHourlyTemps; // 24 values

  const YesterdayComparisonEntity({
    required this.todayHourlyTemps,
    required this.yesterdayHourlyTemps,
  });

  factory YesterdayComparisonEntity.fromHourlyData({
    required List<double> todayTemps,
    List<double>? yesterdayTemps,
    required double baseDifference,
  }) {
    final today24 =
        todayTemps.length >= 24 ? todayTemps.sublist(0, 24) : todayTemps;
    final List<double> yesterday24;

    if (yesterdayTemps != null && yesterdayTemps.length >= 24) {
      yesterday24 = yesterdayTemps.sublist(0, 24);
    } else {
      // Calculate realistic yesterday curve using true differential base offset
      yesterday24 = today24.map((t) => t - baseDifference).toList();
    }

    return YesterdayComparisonEntity(
      todayHourlyTemps: today24,
      yesterdayHourlyTemps: yesterday24,
    );
  }

  double getDeltaAtHour(int hour) {
    if (hour < 0 ||
        hour >= todayHourlyTemps.length ||
        hour >= yesterdayHourlyTemps.length) {
      return 0.0;
    }
    return todayHourlyTemps[hour] - yesterdayHourlyTemps[hour];
  }
}
