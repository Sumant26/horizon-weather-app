import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/domain/entities/activity_entity.dart';
import 'package:horizon/domain/entities/hourly_forecast_entity.dart';
import 'package:horizon/domain/entities/weather_condition.dart';
import 'package:horizon/domain/usecases/calculate_optimal_window.dart';

void main() {
  group('CalculateOptimalWindow UseCase Tests', () {
    const calculator = CalculateOptimalWindow();
    final now = DateTime(2026, 10, 14, 14, 0);

    final hourlyList = List.generate(24, (i) {
      final hourTime = DateTime(2026, 10, 14, i, 0);
      return HourlyForecastEntity(
        time: hourTime,
        temperature: (i >= 11 && i <= 15) ? 32.0 : 22.0,
        precipitationProbability: (i >= 14 && i <= 16) ? 70 : 5,
        condition: (i >= 14 && i <= 16)
            ? WeatherCondition.rainy
            : WeatherCondition.clearDay,
        uvIndex: (i >= 11 && i <= 14) ? 8.0 : 1.0,
      );
    });

    test('evaluates stargazing window for nighttime with high comfort', () {
      final result = calculator(
        activity: OutdoorActivity.stargazing,
        hourlyForecast: hourlyList,
        now: now,
      );

      expect(result.activity, equals(OutdoorActivity.stargazing));
      expect(result.comfortScore, greaterThanOrEqualTo(85));
      expect(result.reasoning, contains('clear sky visibility'));
    });

    test('evaluates photography for golden hour lighting', () {
      final result = calculator(
        activity: OutdoorActivity.photography,
        hourlyForecast: hourlyList,
        now: now,
      );

      expect(result.activity, equals(OutdoorActivity.photography));
      expect(result.reasoning, contains('golden hour'));
    });

    test('evaluates running window to avoid peak heat & rain', () {
      final result = calculator(
        activity: OutdoorActivity.running,
        hourlyForecast: hourlyList,
        now: now,
      );

      expect(result.activity, equals(OutdoorActivity.running));
      expect(result.comfortScore, greaterThanOrEqualTo(80));
    });
  });
}
