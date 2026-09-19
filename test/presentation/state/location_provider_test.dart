import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/domain/entities/air_quality_entity.dart';
import 'package:horizon/domain/entities/location_entity.dart';
import 'package:horizon/domain/entities/weather_entity.dart';
import 'package:horizon/domain/repositories/settings_repository.dart';
import 'package:horizon/domain/repositories/weather_repository.dart';
import 'package:horizon/domain/usecases/detect_current_location.dart';
import 'package:horizon/domain/usecases/search_locations.dart';
import 'package:horizon/presentation/state/location_provider.dart';

class MockSettingsRepository implements SettingsRepository {
  List<LocationEntity> saved = List.from(LocationEntity.defaultSavedLocations);
  int activeIndex = 0;

  @override
  Future<List<LocationEntity>> getSavedLocations() async => saved;

  @override
  Future<void> saveLocations(List<LocationEntity> locations) async {
    saved = List.from(locations);
  }

  @override
  Future<int> getActiveLocationIndex() async => activeIndex;

  @override
  Future<void> saveActiveLocationIndex(int index) async {
    activeIndex = index;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockWeatherRepository implements WeatherRepository {
  LocationEntity? mockDetected;
  List<LocationEntity> searchResults = [];

  @override
  Future<LocationEntity?> detectCurrentLocation() async => mockDetected;

  @override
  Future<List<LocationEntity>> searchLocations(String query) async =>
      searchResults;

  @override
  Future<AirQualityEntity> getAirQuality(
      {required double latitude, required double longitude}) {
    throw UnimplementedError();
  }

  @override
  Future<WeatherEntity> getWeatherForecast(
      {required LocationEntity location, bool forceRefresh = false}) {
    throw UnimplementedError();
  }
}

void main() {
  late MockSettingsRepository settingsRepo;
  late MockWeatherRepository weatherRepo;
  late SearchLocations searchLocations;
  late DetectCurrentLocation detectCurrentLocation;
  late LocationNotifier locationNotifier;

  setUp(() async {
    settingsRepo = MockSettingsRepository();
    weatherRepo = MockWeatherRepository();
    searchLocations = SearchLocations(weatherRepo);
    detectCurrentLocation = DetectCurrentLocation(weatherRepo);
    locationNotifier = LocationNotifier(
      settingsRepository: settingsRepo,
      searchLocations: searchLocations,
      detectCurrentLocation: detectCurrentLocation,
    );
    await locationNotifier.loadLocations();
  });

  test('LocationNotifier detects and prepends current location', () async {
    const liveLoc = LocationEntity(
      name: 'London',
      country: 'United Kingdom',
      latitude: 51.5074,
      longitude: -0.1278,
      isCurrentLocation: true,
    );
    weatherRepo.mockDetected = liveLoc;

    await locationNotifier.detectCurrentLocation(autoSelect: true);

    expect(locationNotifier.value.savedLocations.first.name, 'London');
    expect(
        locationNotifier.value.savedLocations.first.isCurrentLocation, isTrue);
    expect(locationNotifier.value.activeIndex, 0);
  });

  test('LocationNotifier searches and adds new location', () async {
    const kyoto = LocationEntity(
      name: 'Kyoto',
      country: 'Japan',
      latitude: 35.0116,
      longitude: 135.7681,
    );
    weatherRepo.searchResults = [kyoto];

    await locationNotifier.search('Kyoto');
    expect(locationNotifier.value.searchResults.length, 1);
    expect(locationNotifier.value.searchResults.first.name, 'Kyoto');

    await locationNotifier.addAndSelectLocation(kyoto);
    expect(locationNotifier.value.savedLocations.any((l) => l.name == 'Kyoto'),
        isTrue);
    expect(locationNotifier.value.activeLocation.name, 'Kyoto');
  });

  test('LocationNotifier reorders locations accurately', () async {
    const paris = LocationEntity(
      name: 'Paris',
      country: 'France',
      latitude: 48.8566,
      longitude: 2.3522,
    );
    await locationNotifier.addAndSelectLocation(paris);
    final count = locationNotifier.value.savedLocations.length;

    await locationNotifier.reorderLocations(0, count - 1);
    expect(locationNotifier.value.savedLocations.last.name,
        LocationEntity.defaultLocation.name);
  });

  test('LocationNotifier removes location', () async {
    const tokyo = LocationEntity(
      name: 'Tokyo',
      country: 'Japan',
      latitude: 35.6762,
      longitude: 139.6503,
    );
    await locationNotifier.addAndSelectLocation(tokyo);
    final initialCount = locationNotifier.value.savedLocations.length;

    await locationNotifier.removeLocation(initialCount - 1);
    expect(locationNotifier.value.savedLocations.length, initialCount - 1);
  });
}
