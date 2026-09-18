import 'package:flutter/material.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/detect_current_location.dart';
import '../../domain/usecases/search_locations.dart';

class LocationState {
  final List<LocationEntity> savedLocations;
  final int activeIndex;
  final List<LocationEntity> searchResults;
  final bool isSearching;
  final bool isLocating;

  const LocationState({
    required this.savedLocations,
    this.activeIndex = 0,
    this.searchResults = const [],
    this.isSearching = false,
    this.isLocating = false,
  });

  LocationEntity get activeLocation {
    if (savedLocations.isEmpty) return LocationEntity.defaultLocation;
    if (activeIndex >= savedLocations.length) return savedLocations.first;
    return savedLocations[activeIndex];
  }

  LocationState copyWith({
    List<LocationEntity>? savedLocations,
    int? activeIndex,
    List<LocationEntity>? searchResults,
    bool? isSearching,
    bool? isLocating,
  }) {
    return LocationState(
      savedLocations: savedLocations ?? this.savedLocations,
      activeIndex: activeIndex ?? this.activeIndex,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      isLocating: isLocating ?? this.isLocating,
    );
  }
}

class LocationNotifier extends ValueNotifier<LocationState> {
  final SettingsRepository _settingsRepository;
  final SearchLocations _searchLocations;
  final DetectCurrentLocation _detectCurrentLocation;

  LocationNotifier({
    required SettingsRepository settingsRepository,
    required SearchLocations searchLocations,
    required DetectCurrentLocation detectCurrentLocation,
  })  : _settingsRepository = settingsRepository,
        _searchLocations = searchLocations,
        _detectCurrentLocation = detectCurrentLocation,
        super(const LocationState(
            savedLocations: LocationEntity.defaultSavedLocations)) {
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    final saved = await _settingsRepository.getSavedLocations();
    final index = await _settingsRepository.getActiveLocationIndex();
    value = value.copyWith(
      savedLocations: saved,
      activeIndex: index.clamp(0, saved.isEmpty ? 0 : saved.length - 1),
    );
  }

  Future<void> detectCurrentLocation({bool autoSelect = true}) async {
    value = value.copyWith(isLocating: true);
    try {
      final detected = await _detectCurrentLocation();
      if (detected != null) {
        final currentIdx = value.savedLocations.indexWhere(
          (loc) =>
              loc.isCurrentLocation ||
              ((loc.latitude - detected.latitude).abs() < 0.05 &&
                  (loc.longitude - detected.longitude).abs() < 0.05),
        );

        List<LocationEntity> updated;
        int targetIndex;

        if (currentIdx != -1) {
          updated = List<LocationEntity>.from(value.savedLocations);
          updated[currentIdx] = detected;
          targetIndex = autoSelect ? currentIdx : value.activeIndex;
        } else {
          updated = [detected, ...value.savedLocations];
          targetIndex = autoSelect ? 0 : value.activeIndex + 1;
        }

        value = value.copyWith(
          savedLocations: updated,
          activeIndex: targetIndex,
          isLocating: false,
        );
        await _settingsRepository.saveLocations(updated);
        await _settingsRepository.saveActiveLocationIndex(targetIndex);
        return;
      }
    } catch (_) {
      // Graceful degradation
    }
    value = value.copyWith(isLocating: false);
  }

  Future<void> setActiveLocation(int index) async {
    if (index >= 0 && index < value.savedLocations.length) {
      value = value.copyWith(activeIndex: index);
      await _settingsRepository.saveActiveLocationIndex(index);
    }
  }

  Future<void> addAndSelectLocation(LocationEntity location) async {
    // Check if location already exists
    final existsIndex = value.savedLocations.indexWhere(
      (loc) =>
          loc.latitude == location.latitude &&
          loc.longitude == location.longitude,
    );

    if (existsIndex != -1) {
      await setActiveLocation(existsIndex);
    } else {
      final updated = List<LocationEntity>.from(value.savedLocations)
        ..add(location);
      final newIndex = updated.length - 1;
      value = value.copyWith(
          savedLocations: updated, activeIndex: newIndex, searchResults: []);
      await _settingsRepository.saveLocations(updated);
      await _settingsRepository.saveActiveLocationIndex(newIndex);
    }
  }

  Future<void> removeLocation(int index) async {
    if (value.savedLocations.length <= 1) return; // Keep at least one
    final updated = List<LocationEntity>.from(value.savedLocations)
      ..removeAt(index);
    final newActiveIndex = (value.activeIndex >= updated.length)
        ? updated.length - 1
        : value.activeIndex;
    value =
        value.copyWith(savedLocations: updated, activeIndex: newActiveIndex);
    await _settingsRepository.saveLocations(updated);
    await _settingsRepository.saveActiveLocationIndex(newActiveIndex);
  }

  Future<void> reorderLocations(int oldIndex, int newIndex) async {
    if (oldIndex < 0 ||
        oldIndex >= value.savedLocations.length ||
        newIndex < 0 ||
        newIndex >= value.savedLocations.length) {
      return;
    }
    final updated = List<LocationEntity>.from(value.savedLocations);
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);

    // Calculate new active index if affected
    int newActiveIndex = value.activeIndex;
    if (value.activeIndex == oldIndex) {
      newActiveIndex = newIndex;
    } else if (oldIndex < value.activeIndex && newIndex >= value.activeIndex) {
      newActiveIndex--;
    } else if (oldIndex > value.activeIndex && newIndex <= value.activeIndex) {
      newActiveIndex++;
    }

    value =
        value.copyWith(savedLocations: updated, activeIndex: newActiveIndex);
    await _settingsRepository.saveLocations(updated);
    await _settingsRepository.saveActiveLocationIndex(newActiveIndex);
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      value = value.copyWith(searchResults: [], isSearching: false);
      return;
    }

    value = value.copyWith(isSearching: true);
    try {
      final results = await _searchLocations(query);
      value = value.copyWith(searchResults: results, isSearching: false);
    } catch (_) {
      value = value.copyWith(searchResults: [], isSearching: false);
    }
  }

  void clearSearch() {
    value = value.copyWith(searchResults: [], isSearching: false);
  }
}
