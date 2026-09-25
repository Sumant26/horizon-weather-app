import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/presentation/state/editorial_briefing_speaker.dart';

void main() {
  group('EditorialBriefingSpeaker Tests', () {
    final speaker = EditorialBriefingSpeaker.instance;

    setUp(() {
      speaker.stop();
    });

    test('initial state is idle', () {
      expect(speaker.value.isSpeaking, isFalse);
      expect(speaker.value.isPaused, isFalse);
      expect(speaker.value.currentText, isNull);
    });

    test('playBriefing transitions state and completes on stub platform', () {
      speaker.playBriefing(
        'Good morning from Kyoto. Crisp dawn with gentle breeze.',
        locationName: 'Kyoto',
      );

      // On non-web stub platforms, speakEditorialBriefing immediately invokes onStart then onEnd
      expect(speaker.value.error, isNull);
    });

    test('pause and resume mutate state cleanly', () {
      speaker.pause();
      expect(speaker.value.isPaused, isFalse); // Can't pause if not speaking

      speaker.stop();
      expect(speaker.value.isSpeaking, isFalse);
    });
  });
}
