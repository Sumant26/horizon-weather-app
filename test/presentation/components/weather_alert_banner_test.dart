import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/domain/entities/weather_alert_entity.dart';
import 'package:horizon/presentation/components/weather_alert_banner.dart';

void main() {
  testWidgets('WeatherAlertBanner renders active alerts and expands on tap',
      (WidgetTester tester) async {
    const alertItem = WeatherAlertItem(
      title: 'High Wind Advisory',
      description: 'Strong gusts expected in the afternoon.',
      severity: AlertSeverity.severe,
      icon: Icons.wind_power_rounded,
      badgeColor: Colors.orange,
    );
    const alertEntity = WeatherAlertEntity(activeAlerts: [alertItem]);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: WeatherAlertBanner(alerts: alertEntity),
        ),
      ),
    );

    expect(find.text('High Wind Advisory'), findsOneWidget);
    expect(find.text('Atmospheric Event Notice'), findsOneWidget);

    // Tap to expand
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(
        find.text('Strong gusts expected in the afternoon.'), findsOneWidget);
  });
}
