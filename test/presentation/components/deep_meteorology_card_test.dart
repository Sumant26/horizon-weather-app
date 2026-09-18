import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/domain/entities/deep_meteorology_entity.dart';
import 'package:horizon/presentation/components/deep_meteorology_card.dart';

void main() {
  testWidgets('DeepMeteorologyCard renders 4 precision matrix quadrants',
      (WidgetTester tester) async {
    const deepMet = DeepMeteorologyEntity(
      visibilityKm: 18.0,
      cloudBaseMeters: 2400.0,
      directSolarRadiationWm2: 650.0,
      dewPointDepressionC: 8.0,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DeepMeteorologyCard(deepMeteorology: deepMet),
        ),
      ),
    );

    expect(find.text('PRECISION METEOROLOGY MATRIX'), findsOneWidget);
    expect(find.text('VISIBILITY'), findsOneWidget);
    expect(find.text('18.0 km'), findsOneWidget);
    expect(find.text('CLOUD CEILING'), findsOneWidget);
    expect(find.text('2400 m'), findsOneWidget);
    expect(find.text('SOLAR IRRADIANCE'), findsOneWidget);
    expect(find.text('650 W/m²'), findsOneWidget);
    expect(find.text('DEW DEPRESSION'), findsOneWidget);
    expect(find.text('8.0°C'), findsOneWidget);
  });

  testWidgets('DeepMeteorologyCard triggers onTap when tapped',
      (WidgetTester tester) async {
    bool tapped = false;
    const deepMet = DeepMeteorologyEntity(
      visibilityKm: 18.0,
      cloudBaseMeters: 2400.0,
      directSolarRadiationWm2: 650.0,
      dewPointDepressionC: 8.0,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DeepMeteorologyCard(
            deepMeteorology: deepMet,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(DeepMeteorologyCard));
    expect(tapped, isTrue);
  });
}
