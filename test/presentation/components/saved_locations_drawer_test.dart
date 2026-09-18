import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/domain/entities/location_entity.dart';
import 'package:horizon/domain/entities/settings_entity.dart';
import 'package:horizon/domain/repositories/settings_repository.dart';
import 'package:horizon/domain/usecases/search_locations.dart';
import 'package:horizon/presentation/components/saved_locations_drawer.dart';
import 'package:horizon/presentation/state/location_provider.dart';

class MockSettingsRepository implements SettingsRepository {
  List<LocationEntity> locations = LocationEntity.defaultSavedLocations;
  int activeIndex = 0;
  SettingsEntity settings = const SettingsEntity();

  @override
  Future<int> getActiveLocationIndex() async => activeIndex;

  @override
  Future<List<LocationEntity>> getSavedLocations() async => locations;

  @override
  Future<SettingsEntity> getSettings() async => settings;

  @override
  Future<void> saveActiveLocationIndex(int index) async => activeIndex = index;

  @override
  Future<void> saveLocations(List<LocationEntity> locs) async =>
      locations = locs;

  @override
  Future<void> saveSettings(SettingsEntity s) async => settings = s;
}

class MockSearchLocations implements SearchLocations {
  @override
  Future<List<LocationEntity>> call(String query) async {
    return [
      const LocationEntity(
        name: 'Tokyo',
        country: 'Japan',
        latitude: 35.6762,
        longitude: 139.6503,
      ),
    ];
  }
}

void main() {
  group('SavedLocationsDrawer Tests', () {
    late LocationNotifier locationNotifier;

    setUp(() {
      final repo = MockSettingsRepository();
      final search = MockSearchLocations();
      locationNotifier = LocationNotifier(
        settingsRepository: repo,
        searchLocations: search,
      );
    });

    testWidgets('renders saved locations list and title header',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SavedLocationsDrawer(locationNotifier: locationNotifier),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('SAVED LOCATIONS'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Shivajinagar Node'), findsOneWidget);
    });

    testWidgets('tapping a location selects it as active index',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SavedLocationsDrawer(locationNotifier: locationNotifier),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Shivajinagar Node'));
      await tester.pumpAndSettle();

      expect(locationNotifier.value.activeIndex, 0);
    });
  });
}
