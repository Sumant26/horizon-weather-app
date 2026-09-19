class LocationEntity {
  final String name;
  final String? country;
  final String? admin1; // State / Province
  final double latitude;
  final double longitude;
  final bool isCurrentLocation;

  const LocationEntity({
    required this.name,
    this.country,
    this.admin1,
    required this.latitude,
    required this.longitude,
    this.isCurrentLocation = false,
  });

  String get fullDisplayName {
    final parts = [name];
    if (admin1 != null && admin1!.isNotEmpty && admin1 != name) {
      parts.add(admin1!);
    }
    if (country != null && country!.isNotEmpty) {
      parts.add(country!);
    }
    return parts.join(', ');
  }

  // Pre-configured default locations
  static const LocationEntity defaultLocation = LocationEntity(
    name: 'Shivajinagar Node',
    admin1: 'Bengaluru',
    country: 'India',
    latitude: 12.9716,
    longitude: 77.5946,
    isCurrentLocation: true,
  );

  static const List<LocationEntity> defaultSavedLocations = [
    defaultLocation,
  ];
}
