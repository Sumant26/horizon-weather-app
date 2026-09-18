import 'package:flutter/material.dart';

enum CircadianPhase {
  dawn,
  sunrise,
  goldenMorning,
  solarNoon,
  goldenHour,
  twilightDusk,
  deepNight,
}

class CircadianThemeEngine {
  CircadianThemeEngine._();

  /// Computes the exact Circadian Solar Phase based on local time
  static CircadianPhase getPhase(DateTime time) {
    final hour = time.hour + (time.minute / 60.0);

    if (hour >= 5.0 && hour < 6.5) {
      return CircadianPhase.dawn;
    } else if (hour >= 6.5 && hour < 8.0) {
      return CircadianPhase.sunrise;
    } else if (hour >= 8.0 && hour < 12.0) {
      return CircadianPhase.goldenMorning;
    } else if (hour >= 12.0 && hour < 16.0) {
      return CircadianPhase.solarNoon;
    } else if (hour >= 16.0 && hour < 18.5) {
      return CircadianPhase.goldenHour;
    } else if (hour >= 18.5 && hour < 21.0) {
      return CircadianPhase.twilightDusk;
    } else {
      return CircadianPhase.deepNight;
    }
  }

  /// Returns a rich editorial background gradient matched to the solar phase
  static LinearGradient getGradient(DateTime time) {
    final phase = getPhase(time);

    switch (phase) {
      case CircadianPhase.dawn:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0E0F1A),
            Color(0xFF1A1528),
            Color(0xFF0A0B12),
          ],
        );

      case CircadianPhase.sunrise:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF140E18),
            Color(0xFF26161B),
            Color(0xFF0D0C14),
          ],
        );

      case CircadianPhase.goldenMorning:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A1018),
            Color(0xFF121E2A),
            Color(0xFF080C14),
          ],
        );

      case CircadianPhase.solarNoon:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF080D16),
            Color(0xFF0F1A28),
            Color(0xFF06090F),
          ],
        );

      case CircadianPhase.goldenHour:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF160E0C),
            Color(0xFF281610),
            Color(0xFF0D0A0C),
          ],
        );

      case CircadianPhase.twilightDusk:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0B0D18),
            Color(0xFF16152B),
            Color(0xFF07070F),
          ],
        );

      case CircadianPhase.deepNight:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF060608),
            Color(0xFF0A0C12),
            Color(0xFF040406),
          ],
        );
    }
  }

  /// Returns the subtle ambient accent color for the active phase
  static Color getAmbientAccent(DateTime time) {
    final phase = getPhase(time);

    switch (phase) {
      case CircadianPhase.dawn:
        return const Color(0xFFA5B4FC); // Soft lavender
      case CircadianPhase.sunrise:
        return const Color(0xFFF472B6); // Rose amber
      case CircadianPhase.goldenMorning:
        return const Color(0xFF38BDF8); // Crisp sky cyan
      case CircadianPhase.solarNoon:
        return const Color(0xFF60A5FA); // High daylight blue
      case CircadianPhase.goldenHour:
        return const Color(0xFFD97757); // Warm sunset ember
      case CircadianPhase.twilightDusk:
        return const Color(0xFF818CF8); // Twilight indigo
      case CircadianPhase.deepNight:
        return const Color(0xFF7E9F8E); // Starlight sage
    }
  }

  /// Human-readable title for UI headers and telemetry
  static String getPhaseName(CircadianPhase phase) {
    switch (phase) {
      case CircadianPhase.dawn:
        return 'Misty Dawn';
      case CircadianPhase.sunrise:
        return 'Solar Sunrise';
      case CircadianPhase.goldenMorning:
        return 'Golden Morning';
      case CircadianPhase.solarNoon:
        return 'Solar Noon';
      case CircadianPhase.goldenHour:
        return 'Golden Hour';
      case CircadianPhase.twilightDusk:
        return 'Twilight Dusk';
      case CircadianPhase.deepNight:
        return 'Deep OLED Night';
    }
  }
}
