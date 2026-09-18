import '../entities/activity_entity.dart';
import '../entities/hourly_forecast_entity.dart';

class CalculateOptimalWindow {
  const CalculateOptimalWindow();

  ActivityWindowResult call({
    required OutdoorActivity activity,
    required List<HourlyForecastEntity> hourlyForecast,
    required DateTime now,
  }) {
    return ActivityWindowResult.evaluate(
      activity: activity,
      hourlyForecast: hourlyForecast,
      now: now,
    );
  }
}
