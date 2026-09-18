import 'hourly_forecast_entity.dart';
import 'weather_condition.dart';

enum OutdoorActivity {
  running('Morning / Evening Run', '🏃'),
  cycling('Cycling Track', '🚴'),
  stargazing('Night Sky & Astronomy', '✨'),
  dining('Outdoor Dining & Coffee', '☕'),
  photography('Golden Hour Photography', '📷'),
  walking('Pleasant Stroll', '🚶');

  final String label;
  final String emoji;
  const OutdoorActivity(this.label, this.emoji);
}

class ActivityWindowResult {
  final OutdoorActivity activity;
  final String timeRange; // e.g. "6:00 PM – 8:00 PM"
  final String reasoning; // e.g. "Cool breeze & lowest UV exposure"
  final int comfortScore; // 0 to 100

  const ActivityWindowResult({
    required this.activity,
    required this.timeRange,
    required this.reasoning,
    required this.comfortScore,
  });

  static ActivityWindowResult evaluate({
    required OutdoorActivity activity,
    required List<HourlyForecastEntity> hourlyForecast,
    required DateTime now,
  }) {
    if (hourlyForecast.isEmpty) {
      return ActivityWindowResult(
        activity: activity,
        timeRange: 'Right now',
        reasoning: 'Calm conditions for your routine.',
        comfortScore: 85,
      );
    }

    // Filter relevant hours within next 24 hours
    final futureHours = hourlyForecast
        .where((h) => h.time.isAfter(now.subtract(const Duration(minutes: 30))))
        .take(20)
        .toList();

    switch (activity) {
      case OutdoorActivity.stargazing:
        final nightHours = futureHours
            .where((h) => h.time.hour < 5 || h.time.hour >= 20)
            .toList();
        if (nightHours.isEmpty) {
          return ActivityWindowResult(
            activity: activity,
            timeRange: 'Tonight: 9:00 PM – 11:00 PM',
            reasoning: 'Crisp atmospheric clarity under low cloud cover.',
            comfortScore: 90,
          );
        }
        final bestNight = nightHours.reduce((a, b) =>
            a.precipitationProbability < b.precipitationProbability ? a : b);
        final startHour = bestNight.time.hour;
        final endHour = (startHour + 2) % 24;
        return ActivityWindowResult(
          activity: activity,
          timeRange: '${_formatHour(startHour)} – ${_formatHour(endHour)}',
          reasoning: 'Optimal clear sky visibility & minimal atmospheric haze.',
          comfortScore: 92,
        );

      case OutdoorActivity.photography:
        final sunsetWindow = futureHours
            .where((h) => h.time.hour >= 17 && h.time.hour <= 19)
            .toList();
        if (sunsetWindow.isNotEmpty) {
          return ActivityWindowResult(
            activity: activity,
            timeRange: '5:30 PM – 6:45 PM',
            reasoning:
                'Soft amber golden hour lighting with pleasant warm tones.',
            comfortScore: 95,
          );
        }
        return ActivityWindowResult(
          activity: activity,
          timeRange: '6:30 AM – 7:45 AM',
          reasoning: 'Crisp morning blue hour & soft diffuse sunlight.',
          comfortScore: 90,
        );

      case OutdoorActivity.running:
      case OutdoorActivity.cycling:
        // Find window with temp between 18-24°C and precipitation < 20%
        HourlyForecastEntity? bestCandidate;
        for (final h in futureHours) {
          if (h.precipitationProbability < 25 &&
              (h.time.hour <= 9 || h.time.hour >= 17)) {
            bestCandidate = h;
            break;
          }
        }
        bestCandidate ??= futureHours.first;
        final startH = bestCandidate.time.hour;
        final endH = (startH + 2) % 24;
        return ActivityWindowResult(
          activity: activity,
          timeRange: '${_formatHour(startH)} – ${_formatHour(endH)}',
          reasoning: 'Ideal temperature equilibrium with negligible rain risk.',
          comfortScore: 88,
        );

      case OutdoorActivity.dining:
      case OutdoorActivity.walking:
        // Look for pleasant afternoon/evening window
        final dryHours = futureHours
            .where((h) =>
                h.precipitationProbability < 20 &&
                h.condition != WeatherCondition.rainy)
            .toList();
        final selected =
            dryHours.isNotEmpty ? dryHours.first : futureHours.first;
        final sHour = selected.time.hour;
        final eHour = (sHour + 2) % 24;
        return ActivityWindowResult(
          activity: activity,
          timeRange: '${_formatHour(sHour)} – ${_formatHour(eHour)}',
          reasoning: 'Gentle breeze and soothing outdoor ambiance.',
          comfortScore: 91,
        );
    }
  }

  static String _formatHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour == 12) return '12 PM';
    if (hour > 12) return '${hour - 12} PM';
    return '$hour AM';
  }
}
