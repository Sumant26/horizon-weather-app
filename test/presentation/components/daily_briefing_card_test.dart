import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/core/theme/app_theme.dart';
import 'package:horizon/domain/entities/daily_briefing_entity.dart';
import 'package:horizon/presentation/components/daily_briefing_card.dart';

void main() {
  testWidgets('DailyBriefingCard renders narrative and toggles soundscape',
      (tester) async {
    const briefing = DailyBriefingEntity(
      period: BriefingPeriod.morning,
      greeting: 'Good morning, Shivajinagar Node',
      narrative: 'Today is tracking 2.4°C warmer than yesterday.',
      keyHighlight: '↑ 2.4°C vs Yesterday',
      recommendedSoundscape: SoundscapeType.morningBirdsong,
      soundscapeName: 'Highland Dawn Chorus',
      soundscapeDescription: 'Early morning warblers and gentle pine breeze',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: HorizonTheme(
          mode: VisualThemeMode.cozyWarm,
          child: Scaffold(
            body: DailyBriefingCard(briefing: briefing),
          ),
        ),
      ),
    );

    expect(find.text('HORIZON DAILY BRIEFING'), findsOneWidget);
    expect(find.text('MORNING'), findsOneWidget);
    expect(find.text('Today is tracking 2.4°C warmer than yesterday.'),
        findsOneWidget);
    expect(find.text('Highland Dawn Chorus'), findsOneWidget);

    // Tap to play soundscape
    await tester.tap(find.text('Highland Dawn Chorus'));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);
  });
}
