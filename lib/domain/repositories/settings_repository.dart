import '../entities/location_entity.dart';
import '../entities/settings_entity.dart';

abstract class SettingsRepository {
  Future<SettingsEntity> getSettings();
  Future<void> saveSettings(SettingsEntity settings);
  Future<List<LocationEntity>> getSavedLocations();
  Future<void> saveLocations(List<LocationEntity> locations);
  Future<int> getActiveLocationIndex();
  Future<void> saveActiveLocationIndex(int index);
}
