import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/domain/entities/biophilic_health_entity.dart';
import 'package:horizon/presentation/components/biophilic_health_card.dart';

void main() {
  testWidgets('BiophilicHealthCard renders pressure, vitamin D, and pollen',
      (WidgetTester tester) async {
    final bio = BiophilicHealthEntity.evaluate(
      surfacePressureHpa: 1012.0,
      pressureDelta12h: -0.5,
      uvIndex: 5.0,
      humidity: 50.0,
      temperature: 24.0,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BiophilicHealthCard(biophilicHealth: bio),
        ),
      ),
    );

    expect(find.text('BIOPHILIC HEALTH & CIRCADIAN WELLNESS'), findsOneWidget);
    expect(
        find.textContaining('BAROMETRIC PRESSURE: 1012 hPa'), findsOneWidget);
    expect(find.textContaining('VITAMIN D EXPOSURE:'), findsOneWidget);
    expect(find.text('POLLEN ALLERGENS'), findsOneWidget);
    expect(find.text('BREATHABILITY'), findsOneWidget);
  });
}
