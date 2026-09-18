import '../../core/theme/app_theme.dart';
import '../../core/utils/unit_converter.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/local_weather_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final LocalWeatherDatasource _localDatasource;

  SettingsRepositoryImpl({LocalWeatherDatasource? localDatasource})
      : _localDatasource = localDatasource ?? LocalWeatherDatasourceImpl();

  @override
  Future<SettingsEntity> getSettings() async {
    final map = await _localDatasource.getSettings();
    if (map == null) return const SettingsEntity();

    final tempUnitStr = map['temp_unit'] as String?;
    final speedUnitStr = map['speed_unit'] as String?;
    final themeStr = map['theme_mode'] as String?;

    return SettingsEntity(
      temperatureUnit: tempUnitStr == 'fahrenheit'
          ? TemperatureUnit.fahrenheit
          : TemperatureUnit.celsius,
      speedUnit: speedUnitStr == 'mph' ? SpeedUnit.mph : SpeedUnit.kmh,
      themeMode: themeStr == 'oled'
          ? VisualThemeMode.oledMinimalist
          : (themeStr == 'slate'
              ? VisualThemeMode.slateAtmosphere
              : VisualThemeMode.cozyWarm),
    );
  }

  @override
  Future<void> saveSettings(SettingsEntity settings) async {
    final map = {
      'temp_unit': settings.temperatureUnit.name,
      'speed_unit': settings.speedUnit.name,
      'theme_mode': settings.themeMode == VisualThemeMode.oledMinimalist
          ? 'oled'
          : (settings.themeMode == VisualThemeMode.slateAtmosphere
              ? 'slate'
              : 'cozy'),
    };
    await _localDatasource.saveSettings(map);
  }

  @override
  Future<List<LocationEntity>> getSavedLocations() async {
    final list = await _localDatasource.getSavedLocations();
    if (list == null || list.isEmpty) {
      return LocationEntity.defaultSavedLocations;
    }
    return list.map((item) {
      return LocationEntity(
        name: item['name'] as String? ?? 'Location',
        admin1: item['admin1'] as String?,
        country: item['country'] as String?,
        latitude: (item['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (item['longitude'] as num?)?.toDouble() ?? 0.0,
        isCurrentLocation: item['is_current'] == true,
      );
    }).toList();
  }

  @override
  Future<void> saveLocations(List<LocationEntity> locations) async {
    final list = locations.map((loc) {
      return {
        'name': loc.name,
        'admin1': loc.admin1,
        'country': loc.country,
        'latitude': loc.latitude,
        'longitude': loc.longitude,
        'is_current': loc.isCurrentLocation,
      };
    }).toList();
    await _localDatasource.saveLocations(list);
  }

  @override
  Future<int> getActiveLocationIndex() =>
      _localDatasource.getActiveLocationIndex();

  @override
  Future<void> saveActiveLocationIndex(int index) =>
      _localDatasource.saveActiveLocationIndex(index);
}
