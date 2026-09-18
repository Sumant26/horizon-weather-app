import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/domain/entities/yesterday_comparison_entity.dart';

void main() {
  group('YesterdayComparisonEntity Tests', () {
    test('calculates delta at specific hour accurately', () {
      const comp = YesterdayComparisonEntity(
        todayHourlyTemps: [20.0, 21.0, 22.0, 23.0, 24.0],
        yesterdayHourlyTemps: [18.0, 19.5, 22.0, 25.0, 20.0],
      );

      expect(comp.getDeltaAtHour(0), closeTo(2.0, 0.01));
      expect(comp.getDeltaAtHour(1), closeTo(1.5, 0.01));
      expect(comp.getDeltaAtHour(2), closeTo(0.0, 0.01));
      expect(comp.getDeltaAtHour(3), closeTo(-2.0, 0.01));
      expect(comp.getDeltaAtHour(4), closeTo(4.0, 0.01));
      expect(comp.getDeltaAtHour(99), equals(0.0)); // Out of bounds guard
    });

    test('fromHourlyData generates synthetic yesterday curve when not provided',
        () {
      final today = List.generate(24, (i) => 20.0 + (i * 0.5));
      final comp = YesterdayComparisonEntity.fromHourlyData(
        todayTemps: today,
        baseDifference: 2.0, // Today is 2.0°C warmer than yesterday
      );

      expect(comp.todayHourlyTemps.length, equals(24));
      expect(comp.yesterdayHourlyTemps.length, equals(24));
      expect(comp.getDeltaAtHour(0), closeTo(2.0, 0.01));
      expect(comp.getDeltaAtHour(12), closeTo(2.0, 0.01));
    });
  });
}
