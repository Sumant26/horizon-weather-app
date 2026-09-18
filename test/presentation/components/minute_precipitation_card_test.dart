import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/domain/entities/minute_precipitation_entity.dart';
import 'package:horizon/presentation/components/minute_precipitation_card.dart';

void main() {
  testWidgets('MinutePrecipitationCard renders 60-min rain curve summary',
      (WidgetTester tester) async {
    final precip = MinutePrecipitationEntity.generate(
      isCurrentlyRaining: true,
      precipitationProbability: 90,
      hourlyPrecipitationMm: 3.2,
      now: DateTime(2026, 10, 14, 14, 0),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MinutePrecipitationCard(minutePrecipitation: precip),
        ),
      ),
    );

    expect(find.text('NEXT-HOUR PRECIPITATION'), findsOneWidget);
    expect(find.textContaining('Rain underway'), findsOneWidget);
    expect(find.text('Now'), findsOneWidget);
    expect(find.text('30 min'), findsOneWidget);
    expect(find.text('60 min'), findsOneWidget);
  });
}
