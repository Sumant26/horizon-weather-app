import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum VisualThemeMode { cozyWarm, oledMinimalist, slateAtmosphere, nordicPine }

class HorizonTheme extends InheritedWidget {
  final VisualThemeMode mode;

  const HorizonTheme({
    super.key,
    required this.mode,
    required super.child,
  });

  static VisualThemeMode of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<HorizonTheme>();
    return provider?.mode ?? VisualThemeMode.cozyWarm;
  }

  @override
  bool updateShouldNotify(HorizonTheme oldWidget) => mode != oldWidget.mode;
}

class AppTheme {
  AppTheme._();

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0F1115),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.honeyGold,
      secondary: AppColors.warmSage,
      surface: Color(0xFF161A20),
      onSurface: AppColors.softLinen,
    ),
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 96,
        fontWeight: FontWeight.w200,
        letterSpacing: -4,
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w300,
        color: AppColors.softLinen,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        height: 1.45,
        color: Colors.white70,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.8,
        color: Colors.white38,
      ),
    ),
  );
}
