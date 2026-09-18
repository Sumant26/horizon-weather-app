import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/haptic_feedback_util.dart';
import '../../core/utils/unit_converter.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/entities/weather_entity.dart';
import '../state/settings_provider.dart';
import 'widget_preview_screen.dart';

class SettingsSheet extends StatelessWidget {
  final SettingsNotifier settingsNotifier;
  final WeatherEntity? weather;

  const SettingsSheet({
    super.key,
    required this.settingsNotifier,
    this.weather,
  });

  static Future<void> show(
    BuildContext context, {
    required SettingsNotifier notifier,
    WeatherEntity? weather,
  }) {
    HapticFeedbackHelper.medium();
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SettingsSheet(
        settingsNotifier: notifier,
        weather: weather,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SettingsEntity>(
      valueListenable: settingsNotifier,
      builder: (context, settings, _) {
        final mode = settings.themeMode;
        final sheetBg = switch (mode) {
          VisualThemeMode.oledMinimalist => const Color(0xFF0A0A0A),
          VisualThemeMode.slateAtmosphere => const Color(0xFF0F172A),
          VisualThemeMode.nordicPine => const Color(0xFF0B1412),
          VisualThemeMode.cozyWarm => const Color(0xFF1C1713),
        };
        final borderColor = switch (mode) {
          VisualThemeMode.oledMinimalist => const Color(0xFF262626),
          VisualThemeMode.slateAtmosphere => const Color(0xFF334155),
          VisualThemeMode.nordicPine =>
            AppColors.warmSage.withValues(alpha: 0.2),
          VisualThemeMode.cozyWarm =>
            AppColors.honeyGold.withValues(alpha: 0.18),
        };
        final accent = AppColors.primaryAccent(mode);

        return Container(
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(top: BorderSide(color: borderColor, width: 1.0)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'PREFERENCES & UNITS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.0,
                  color: Colors.white38,
                ),
              ),
              const SizedBox(height: 18),
              // Temperature Unit Toggle
              _SettingTile(
                icon: Icons.thermostat_rounded,
                accentColor: accent,
                title: 'Temperature Unit',
                subtitle: settings.temperatureUnit == TemperatureUnit.celsius
                    ? 'Metric (°C)'
                    : 'Imperial (°F)',
                trailing: SegmentedButton<TemperatureUnit>(
                  segments: const [
                    ButtonSegment(
                        value: TemperatureUnit.celsius, label: Text('°C')),
                    ButtonSegment(
                        value: TemperatureUnit.fahrenheit, label: Text('°F')),
                  ],
                  selected: {settings.temperatureUnit},
                  onSelectionChanged: (set) {
                    HapticFeedbackHelper.selection();
                    settingsNotifier.toggleTemperatureUnit();
                  },
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Wind Speed Unit Toggle
              _SettingTile(
                icon: Icons.air_rounded,
                accentColor: accent,
                title: 'Wind Speed Unit',
                subtitle: settings.speedUnit == SpeedUnit.kmh
                    ? 'Kilometers/hour (km/h)'
                    : 'Miles/hour (mph)',
                trailing: SegmentedButton<SpeedUnit>(
                  segments: const [
                    ButtonSegment(value: SpeedUnit.kmh, label: Text('km/h')),
                    ButtonSegment(value: SpeedUnit.mph, label: Text('mph')),
                  ],
                  selected: {settings.speedUnit},
                  onSelectionChanged: (set) {
                    HapticFeedbackHelper.selection();
                    settingsNotifier.toggleSpeedUnit();
                  },
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Visual Theme Variants
              _SettingTile(
                icon: Icons.palette_outlined,
                accentColor: accent,
                title: 'Visual Theme',
                subtitle: switch (settings.themeMode) {
                  VisualThemeMode.cozyWarm =>
                    'Cozy Warm (Warm Earth Gradients)',
                  VisualThemeMode.oledMinimalist => 'Deep OLED Black (Pitch)',
                  VisualThemeMode.slateAtmosphere => 'Slate Minimalist',
                  VisualThemeMode.nordicPine => 'Nordic Frosted Pine',
                },
                trailing: DropdownButton<VisualThemeMode>(
                  value: settings.themeMode,
                  dropdownColor: sheetBg,
                  underline: const SizedBox.shrink(),
                  icon: Icon(Icons.arrow_drop_down, color: accent),
                  items: const [
                    DropdownMenuItem(
                      value: VisualThemeMode.cozyWarm,
                      child: Text('Cozy Warm',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                    DropdownMenuItem(
                      value: VisualThemeMode.oledMinimalist,
                      child: Text('OLED Black',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                    DropdownMenuItem(
                      value: VisualThemeMode.slateAtmosphere,
                      child: Text('Slate',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                    DropdownMenuItem(
                      value: VisualThemeMode.nordicPine,
                      child: Text('Nordic Pine',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                  ],
                  onChanged: (mode) {
                    if (mode != null) {
                      HapticFeedbackHelper.selection();
                      settingsNotifier.setThemeMode(mode);
                    }
                  },
                ),
              ),
              const SizedBox(height: 14),
              // Home Screen & Lock Screen Widgets Designer
              if (weather != null)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.pop(context);
                      WidgetPreviewScreen.show(
                        context,
                        weather: weather!,
                        unit: settings.temperatureUnit,
                        initialTheme: mode,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: accent.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.widgets_outlined, size: 20, color: accent),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Glanceable System Widgets',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Preview iOS & Android Home/Lock screen templates',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded,
                              size: 14, color: Colors.white38),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final Color accentColor;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingTile({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: accentColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.white54),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
