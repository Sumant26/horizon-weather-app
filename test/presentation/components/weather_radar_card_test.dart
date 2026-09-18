import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/core/utils/unit_converter.dart';
import 'package:horizon/domain/entities/weather_condition.dart';
import 'package:horizon/domain/entities/wind_stream_entity.dart';
import 'package:horizon/presentation/components/weather_radar_card.dart';

void main() {
  testWidgets(
      'WeatherRadarCard toggles between rain radar and wind streamlines',
      (WidgetTester tester) async {
    final wind = WindStreamEntity.fromValues(
      speedKmh: 18.0,
      directionDegrees: 210.0,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeatherRadarCard(
            condition: WeatherCondition.rainy,
            windStream: wind,
            speedUnit: SpeedUnit.kmh,
          ),
        ),
      ),
    );

    // Initial mode is Precipitation Radar
    expect(find.text('PRECIPITATION RADAR'), findsOneWidget);
    expect(find.text('Range: 50 km radius'), findsOneWidget);

    // Tap Wind Segment button and pump frame
    await tester.tap(find.text('Wind'));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('WIND VECTOR STREAMLINES'), findsOneWidget);
    expect(find.text('BEAUFORT SCALE'), findsOneWidget);
    expect(find.text('Gentle Breeze'), findsOneWidget);
  });
}
