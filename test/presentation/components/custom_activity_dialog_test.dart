import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/domain/entities/activity_profile.dart';
import 'package:horizon/presentation/components/custom_activity_dialog.dart';

void main() {
  group('CustomActivityDialog Tests', () {
    testWidgets('renders title, textfield and slider controls', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomActivityDialog(
              onSaved: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('CUSTOM ACTIVITY PROFILE'), findsOneWidget);
      expect(find.text('ACTIVITY NAME'), findsOneWidget);
      expect(find.text('SELECT ICON'), findsOneWidget);
      expect(find.text('Save Activity Profile'), findsOneWidget);
    });

    testWidgets('saving triggers callback with constructed ActivityProfile',
        (tester) async {
      ActivityProfile? saved;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomActivityDialog(
              onSaved: (p) => saved = p,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Activity Profile'));
      await tester.pumpAndSettle();

      expect(saved, isNotNull);
      expect(saved!.name, isNotEmpty);
      expect(saved!.isCustom, isTrue);
    });
  });
}
