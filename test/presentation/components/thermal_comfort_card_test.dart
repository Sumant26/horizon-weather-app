import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/core/theme/app_theme.dart';
import 'package:horizon/core/utils/unit_converter.dart';
import 'package:horizon/domain/entities/thermal_comfort_entity.dart';
import 'package:horizon/presentation/components/thermal_comfort_card.dart';

void main() {
  testWidgets('ThermalComfortCard renders apparent temp and 3 factors',
      (tester) async {
    const comfort = ThermalComfortEntity(
      ambientTemp: 31.0,
      feelsLikeTemp: 33.0,
      solarRadiationDelta: 2.1,
      humidityDelta: 1.8,
      windChillDelta: -1.0,
      clothingInsulationClo: 0.45,
      clothingRecommendation: 'Ultralight linen and moisture-wicking tees',
      physiologicalSummary: 'High thermal retention',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: HorizonTheme(
          mode: VisualThemeMode.cozyWarm,
          child: Scaffold(
            body: ThermalComfortCard(
              thermalComfort: comfort,
              unit: TemperatureUnit.celsius,
            ),
          ),
        ),
      ),
    );

    expect(find.text('BIOCLIMATIC THERMAL COMFORT'), findsOneWidget);
    expect(find.text('0.45 CLO'), findsOneWidget);
    expect(find.text('33°C'), findsOneWidget);
    expect(find.text('apparent (vs 31°C actual)'), findsOneWidget);
    expect(find.text('Solar Radiation: '), findsOneWidget);
    expect(find.text('Humidity Vapor: '), findsOneWidget);
    expect(find.text('Wind Convection: '), findsOneWidget);
    expect(find.text('Ultralight linen and moisture-wicking tees'),
        findsOneWidget);
  });
}
