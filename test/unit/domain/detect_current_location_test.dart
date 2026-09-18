import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/domain/entities/air_quality_entity.dart';
import 'package:horizon/domain/entities/location_entity.dart';
import 'package:horizon/domain/entities/weather_entity.dart';
import 'package:horizon/domain/repositories/weather_repository.dart';
import 'package:horizon/domain/usecases/detect_current_location.dart';

class MockWeatherRepository implements WeatherRepository {
  LocationEntity? mockDetected;

  @override
  Future<LocationEntity?> detectCurrentLocation() async {
    return mockDetected;
  }

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

  @override
  Future<List<LocationEntity>> searchLocations(String query) {
    throw UnimplementedError();
  }
}

void main() {
  late MockWeatherRepository repository;
  late DetectCurrentLocation usecase;

  setUp(() {
    repository = MockWeatherRepository();
    usecase = DetectCurrentLocation(repository);
  });

  test('DetectCurrentLocation returns detected location entity when found',
      () async {
    const expected = LocationEntity(
      name: 'San Francisco',
      admin1: 'California',
      country: 'United States',
      latitude: 37.7749,
      longitude: -122.4194,
      isCurrentLocation: true,
    );
    repository.mockDetected = expected;

    final result = await usecase();

    expect(result, isNotNull);
    expect(result?.name, 'San Francisco');
    expect(result?.isCurrentLocation, isTrue);
    expect(result?.latitude, 37.7749);
  });

  test('DetectCurrentLocation returns null when detection fails', () async {
    repository.mockDetected = null;

    final result = await usecase();

    expect(result, isNull);
  });
}
