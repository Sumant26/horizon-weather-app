import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/core/utils/unit_converter.dart';
import 'package:horizon/domain/entities/yesterday_comparison_entity.dart';
import 'package:horizon/presentation/components/yesterday_comparison_chart.dart';

void main() {
  testWidgets('YesterdayComparisonChart renders dual curve and responds to tap',
      (WidgetTester tester) async {
    final comparison = YesterdayComparisonEntity(
      todayHourlyTemps: List.generate(24, (i) => 20.0 + (i * 0.4)),
      yesterdayHourlyTemps: List.generate(24, (i) => 18.0 + (i * 0.4)),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YesterdayComparisonChart(
            comparison: comparison,
            unit: TemperatureUnit.celsius,
          ),
        ),
      ),
    );

    expect(find.text('24-HOUR YESTERDAY OVERLAY'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Yesterday'), findsOneWidget);
    expect(find.text('12 AM'), findsOneWidget);
    expect(find.text('12 PM'), findsOneWidget);
    expect(find.text('11 PM'), findsOneWidget);

    // Tap on the chart to move scrubber cursor
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();
  });
}
