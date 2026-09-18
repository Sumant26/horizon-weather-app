import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/unit_converter.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsNotifier extends ValueNotifier<SettingsEntity> {
  final SettingsRepository _repository;

  SettingsNotifier(this._repository) : super(const SettingsEntity()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _repository.getSettings();
    value = settings;
  }

  Future<void> toggleTemperatureUnit() async {
    final newUnit = value.temperatureUnit == TemperatureUnit.celsius
        ? TemperatureUnit.fahrenheit
        : TemperatureUnit.celsius;
    value = value.copyWith(temperatureUnit: newUnit);
    await _repository.saveSettings(value);
  }

  Future<void> toggleSpeedUnit() async {
    final newUnit =
        value.speedUnit == SpeedUnit.kmh ? SpeedUnit.mph : SpeedUnit.kmh;
    value = value.copyWith(speedUnit: newUnit);
    await _repository.saveSettings(value);
  }

  Future<void> setThemeMode(VisualThemeMode mode) async {
    value = value.copyWith(themeMode: mode);
    await _repository.saveSettings(value);
  }
}
