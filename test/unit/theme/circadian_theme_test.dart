import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/core/theme/circadian_theme_engine.dart';

void main() {
  group('CircadianThemeEngine Solar Phase Tests', () {
    test('resolves Dawn between 05:00 and 06:30', () {
      final time = DateTime(2026, 9, 18, 5, 45);
      expect(CircadianThemeEngine.getPhase(time), CircadianPhase.dawn);
      expect(
          CircadianThemeEngine.getPhaseName(CircadianPhase.dawn), 'Misty Dawn');
    });

    test('resolves Sunrise between 06:30 and 08:00', () {
      final time = DateTime(2026, 9, 18, 7, 15);
      expect(CircadianThemeEngine.getPhase(time), CircadianPhase.sunrise);
    });

    test('resolves Golden Morning between 08:00 and 12:00', () {
      final time = DateTime(2026, 9, 18, 9, 30);
      expect(CircadianThemeEngine.getPhase(time), CircadianPhase.goldenMorning);
    });

    test('resolves Solar Noon between 12:00 and 16:00', () {
      final time = DateTime(2026, 9, 18, 13, 0);
      expect(CircadianThemeEngine.getPhase(time), CircadianPhase.solarNoon);
    });

    test('resolves Golden Hour between 16:00 and 18:30', () {
      final time = DateTime(2026, 9, 18, 17, 30);
      expect(CircadianThemeEngine.getPhase(time), CircadianPhase.goldenHour);
    });

    test('resolves Twilight Dusk between 18:30 and 21:00', () {
      final time = DateTime(2026, 9, 18, 19, 45);
      expect(CircadianThemeEngine.getPhase(time), CircadianPhase.twilightDusk);
    });

    test('resolves Deep OLED Night between 21:00 and 05:00', () {
      final timeLate = DateTime(2026, 9, 18, 23, 30);
      final timeEarly = DateTime(2026, 9, 18, 2, 0);

      expect(CircadianThemeEngine.getPhase(timeLate), CircadianPhase.deepNight);
      expect(
          CircadianThemeEngine.getPhase(timeEarly), CircadianPhase.deepNight);
    });

    test(
        'returns valid LinearGradient and non-null ambient accent for every phase',
        () {
      for (final phase in CircadianPhase.values) {
        final time = switch (phase) {
          CircadianPhase.dawn => DateTime(2026, 9, 18, 5, 30),
          CircadianPhase.sunrise => DateTime(2026, 9, 18, 7, 0),
          CircadianPhase.goldenMorning => DateTime(2026, 9, 18, 10, 0),
          CircadianPhase.solarNoon => DateTime(2026, 9, 18, 13, 0),
          CircadianPhase.goldenHour => DateTime(2026, 9, 18, 17, 0),
          CircadianPhase.twilightDusk => DateTime(2026, 9, 18, 19, 0),
          CircadianPhase.deepNight => DateTime(2026, 9, 18, 23, 0),
        };

        final gradient = CircadianThemeEngine.getGradient(time);
        final accent = CircadianThemeEngine.getAmbientAccent(time);

        expect(gradient.colors.length, greaterThanOrEqualTo(2));
        expect(accent, isA<Color>());
      }
    });
  });
}
