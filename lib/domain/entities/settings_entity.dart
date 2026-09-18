import '../../core/theme/app_theme.dart';
import '../../core/utils/unit_converter.dart';

class SettingsEntity {
  final TemperatureUnit temperatureUnit;
  final SpeedUnit speedUnit;
  final VisualThemeMode themeMode;

  const SettingsEntity({
    this.temperatureUnit = TemperatureUnit.celsius,
    this.speedUnit = SpeedUnit.kmh,
    this.themeMode = VisualThemeMode.cozyWarm,
  });

  SettingsEntity copyWith({
    TemperatureUnit? temperatureUnit,
    SpeedUnit? speedUnit,
    VisualThemeMode? themeMode,
  }) {
    return SettingsEntity(
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      speedUnit: speedUnit ?? this.speedUnit,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
