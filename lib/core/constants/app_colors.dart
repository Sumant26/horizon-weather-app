import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/circadian_theme_engine.dart';

class AppColors {
  AppColors._();

  // Cozy Atmosphere Background Gradients (3-stop deep atmospheric transitions)
  static const List<Color> clearDayGradient = [
    Color(0xFF382315), // Warm honey-amber dusk
    Color(0xFF22160E), // Cozy dark roasted espresso
    Color(0xFF140D09), // Deep rich ground
  ];

  static const List<Color> clearNightGradient = [
    Color(0xFF0F1B2E), // Midnight celestial indigo
    Color(0xFF0B121F), // Deep starry twilight
    Color(0xFF060910), // Velvet obsidian
  ];

  static const List<Color> rainyGradient = [
    Color(0xFF1B2B38), // Cozy atmospheric slate teal
    Color(0xFF131D27), // Soft rain dusk
    Color(0xFF0B1015), // Deep flannel charcoal
  ];

  static const List<Color> overcastGradient = [
    Color(0xFF282E37), // Soft heather mist
    Color(0xFF1A1F26), // Cozy wool graphite
    Color(0xFF101317), // Deep flannel grey
  ];

  static const List<Color> warmHeatGradient = [
    Color(0xFF4D2012), // Radiant terracotta hearth
    Color(0xFF2E130B), // Warm roasted clay
    Color(0xFF180A06), // Deep rich amber obsidian
  ];

  // Slate Minimalist Gradients
  static const List<Color> slateClearDayGradient = [
    Color(0xFF1E293B), // Slate 800
    Color(0xFF0F172A), // Slate 900
    Color(0xFF020617), // Slate 950
  ];

  static const List<Color> slateNightGradient = [
    Color(0xFF0F172A),
    Color(0xFF070B14),
    Color(0xFF020408),
  ];

  static const List<Color> slateRainGradient = [
    Color(0xFF162536),
    Color(0xFF0D1722),
    Color(0xFF060B11),
  ];

  static const List<Color> slateOvercastGradient = [
    Color(0xFF232A36),
    Color(0xFF151B24),
    Color(0xFF0A0D12),
  ];

  // Pitch OLED Minimalist Gradient
  static const List<Color> oledGradient = [
    Color(0xFF000000),
    Color(0xFF000000),
    Color(0xFF000000),
  ];

  // Highlights & Accents
  static const Color honeyGold = Color(0xFFF6AD55);
  static const Color warmSage = Color(0xFF9AE6B4);
  static const Color softAmber = Color(0xFFFBD38D);
  static const Color warmTerracotta = Color(0xFFED8936);
  static const Color twilightCyan = Color(0xFF81E6D9);
  static const Color icyCyan = Color(0xFF38BDF8);
  static const Color softLinen = Color(0xFFFAF6F0); // Warm ivory linen

  // Dynamic Theme Primary Accent
  static Color primaryAccent(VisualThemeMode mode) {
    switch (mode) {
      case VisualThemeMode.oledMinimalist:
        return Colors.white;
      case VisualThemeMode.slateAtmosphere:
        return icyCyan;
      case VisualThemeMode.nordicPine:
        return warmSage;
      case VisualThemeMode.cozyWarm:
        return honeyGold;
    }
  }

  /// Returns a rich complementary solid card background that pairs with the background
  static Color getComplementaryCardColor({
    VisualThemeMode mode = VisualThemeMode.cozyWarm,
    dynamic condition,
    DateTime? time,
  }) {
    if (mode == VisualThemeMode.oledMinimalist) {
      return const Color(0xFF0D0D0D);
    }
    if (mode == VisualThemeMode.slateAtmosphere) {
      return const Color(0xFF172033);
    }
    if (mode == VisualThemeMode.nordicPine) {
      return const Color(0xFF10201A);
    }

    final condName = condition?.toString() ?? '';
    if (condName.contains('rain') ||
        condName.contains('drizzle') ||
        condName.contains('thunderstorm')) {
      return const Color(0xFF182632);
    }
    if (condName.contains('extremeHeat')) {
      return const Color(0xFF35160C);
    }
    if (condName.contains('overcast') ||
        condName.contains('foggy') ||
        condName.contains('snowy')) {
      return const Color(0xFF20252D);
    }

    // Circadian Solar Phase complementary color
    final phase = CircadianThemeEngine.getPhase(time ?? DateTime.now());
    switch (phase) {
      case CircadianPhase.dawn:
        return const Color(0xFF1E1A2E);
      case CircadianPhase.sunrise:
        return const Color(0xFF281921);
      case CircadianPhase.goldenMorning:
        return const Color(0xFF121F2D);
      case CircadianPhase.solarNoon:
        return const Color(0xFF101E2E);
      case CircadianPhase.goldenHour:
        return const Color(0xFF2C1914);
      case CircadianPhase.twilightDusk:
        return const Color(0xFF1A1833);
      case CircadianPhase.deepNight:
        return const Color(0xFF12151D);
    }
  }

  /// Returns a subtle, harmonizing border color that complements the card surface
  static Color getComplementaryCardBorder({
    VisualThemeMode mode = VisualThemeMode.cozyWarm,
    dynamic condition,
    DateTime? time,
  }) {
    if (mode == VisualThemeMode.oledMinimalist) {
      return const Color(0xFF242424);
    }
    if (mode == VisualThemeMode.slateAtmosphere) {
      return const Color(0xFF29384E);
    }
    if (mode == VisualThemeMode.nordicPine) {
      return const Color(0xFF1E3B31);
    }

    final condName = condition?.toString() ?? '';
    if (condName.contains('rain') ||
        condName.contains('drizzle') ||
        condName.contains('thunderstorm')) {
      return const Color(0xFF2B4458);
    }
    if (condName.contains('extremeHeat')) {
      return const Color(0xFF5E2715);
    }
    if (condName.contains('overcast') ||
        condName.contains('foggy') ||
        condName.contains('snowy')) {
      return const Color(0xFF3B4450);
    }

    final phase = CircadianThemeEngine.getPhase(time ?? DateTime.now());
    switch (phase) {
      case CircadianPhase.dawn:
        return const Color(0xFF383050);
      case CircadianPhase.sunrise:
        return const Color(0xFF4C2C39);
      case CircadianPhase.goldenMorning:
        return const Color(0xFF223850);
      case CircadianPhase.solarNoon:
        return const Color(0xFF203752);
      case CircadianPhase.goldenHour:
        return const Color(0xFF522E24);
      case CircadianPhase.twilightDusk:
        return const Color(0xFF36325C);
      case CircadianPhase.deepNight:
        return const Color(0xFF232A38);
    }
  }

  // Dynamic Theme Card Decoration with complementary color matching
  static BoxDecoration cardDecoration(
    VisualThemeMode mode, {
    Color? accentBorder,
    dynamic condition,
    DateTime? time,
  }) {
    final bgColor = getComplementaryCardColor(
      mode: mode,
      condition: condition,
      time: time,
    );
    final borderColor = accentBorder ??
        getComplementaryCardBorder(
          mode: mode,
          condition: condition,
          time: time,
        );

    return BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: borderColor,
        width: 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.35),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  // Backward-compatible fallback for cozy card decoration
  static BoxDecoration cozyCardDecoration({
    VisualThemeMode mode = VisualThemeMode.cozyWarm,
    Color? accentBorder,
    dynamic condition,
    DateTime? time,
  }) =>
      cardDecoration(
        mode,
        accentBorder: accentBorder,
        condition: condition,
        time: time,
      );
}
