import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/domain/entities/activity_entity.dart';
import 'package:horizon/domain/entities/air_quality_entity.dart';
import 'package:horizon/domain/entities/astronomy_entity.dart';
import 'package:horizon/domain/entities/biophilic_health_entity.dart';
import 'package:horizon/domain/entities/deep_meteorology_entity.dart';
import 'package:horizon/domain/entities/location_entity.dart';
import 'package:horizon/domain/entities/minute_precipitation_entity.dart';
import 'package:horizon/domain/entities/weather_alert_entity.dart';
import 'package:horizon/domain/entities/weather_condition.dart';
import 'package:horizon/domain/entities/weather_entity.dart';
import 'package:horizon/domain/entities/wind_stream_entity.dart';
import 'package:horizon/domain/entities/yesterday_comparison_entity.dart';
import 'package:horizon/domain/repositories/weather_repository.dart';
import 'package:horizon/domain/usecases/calculate_optimal_window.dart';
import 'package:horizon/domain/usecases/get_weather_forecast.dart';
import 'package:horizon/presentation/state/weather_provider.dart';

class MockWeatherRepository implements WeatherRepository {
  bool shouldFail = false;

  @override
  Future<WeatherEntity> getWeatherForecast(
      {required LocationEntity location, bool forceRefresh = false}) async {
    if (shouldFail) throw Exception('API Error');
    final now = DateTime(2026, 10, 14, 12, 0);
    return WeatherEntity(
      temperature: 24.0,
      feelsLike: 23.5,
      tempDifferenceYesterday: -1.2,
      humidity: 50.0,
      uvIndex: 4.0,
      cloudCover: 0.2,
      windSpeed: 8.0,
      condition: WeatherCondition.clearDay,
      timestamp: now,
      location: location,
      astronomy: AstronomyEntity(
        sunrise: DateTime(2026, 10, 14, 6, 0),
        sunset: DateTime(2026, 10, 14, 18, 0),
        sunProgress: 0.5,
        isDaylight: true,
      ),
      airQuality: AirQualityEntity.fromValues(pm2_5: 10.0, pm10: 20.0, aqi: 25),
      windStream:
          WindStreamEntity.fromValues(speedKmh: 8.0, directionDegrees: 180),
      biophilicHealth: BiophilicHealthEntity.evaluate(
        surfacePressureHpa: 1013,
        pressureDelta12h: 0,
        uvIndex: 4,
        humidity: 50,
        temperature: 24,
      ),
      minutePrecipitation: MinutePrecipitationEntity.generate(
        isCurrentlyRaining: false,
        precipitationProbability: 0,
        hourlyPrecipitationMm: 0,
        now: now,
      ),
      yesterdayComparison: YesterdayComparisonEntity.fromHourlyData(
        todayTemps: List.filled(24, 24.0),
        baseDifference: -1.2,
      ),
      weatherAlerts: const WeatherAlertEntity(activeAlerts: []),
      deepMeteorology: const DeepMeteorologyEntity(
        visibilityKm: 15.0,
        cloudBaseMeters: 2000.0,
        directSolarRadiationWm2: 500.0,
        dewPointDepressionC: 9.0,
      ),
      hourlyForecast: const [],
      dailyForecast: const [],
    );
  }

  @override
  Future<AirQualityEntity> getAirQuality(
      {required double latitude, required double longitude}) async {
    return AirQualityEntity.fromValues(pm2_5: 10.0, pm10: 20.0, aqi: 25);
  }

  @override
  Future<List<LocationEntity>> searchLocations(String query) async {
    return [LocationEntity.defaultLocation];
  }

  @override
  Future<LocationEntity?> detectCurrentLocation() async {
    return LocationEntity.defaultLocation;
  }
}

void main() {
  group('WeatherNotifier State Tests', () {
    late MockWeatherRepository mockRepo;
    late GetWeatherForecast getWeatherForecast;
    late WeatherNotifier notifier;

    setUp(() {
      mockRepo = MockWeatherRepository();
      getWeatherForecast = GetWeatherForecast(mockRepo);
      notifier = WeatherNotifier(
        getWeatherForecast: getWeatherForecast,
        calculateOptimalWindow: const CalculateOptimalWindow(),
      );
    });

    test('initial state is WeatherInitial', () {
      expect(notifier.value, isA<WeatherInitial>());
    });

    test('fetchWeatherForLocation transitions to WeatherLoaded upon success',
        () async {
      final states = <WeatherState>[];
      notifier.addListener(() => states.add(notifier.value));

      await notifier.fetchWeatherForLocation(LocationEntity.defaultLocation);

      expect(states.length, greaterThanOrEqualTo(2));
      expect(states.first, isA<WeatherLoading>());
      expect(states.last, isA<WeatherLoaded>());
      final loaded = states.last as WeatherLoaded;
      expect(loaded.data.temperature, equals(24.0));
      expect(loaded.data.location.name,
          equals(LocationEntity.defaultLocation.name));
    });

    test('selectActivity recalculates optimal window dynamically', () async {
      await notifier.fetchWeatherForLocation(LocationEntity.defaultLocation);
      expect((notifier.value as WeatherLoaded).selectedActivity,
          equals(OutdoorActivity.walking));

      notifier.selectActivity(OutdoorActivity.stargazing);
      expect((notifier.value as WeatherLoaded).selectedActivity,
          equals(OutdoorActivity.stargazing));
    });

    test('toggleGearItem updates packed checklist set', () async {
      await notifier.fetchWeatherForLocation(LocationEntity.defaultLocation);
      expect((notifier.value as WeatherLoaded).packedGear.isEmpty, isTrue);

      notifier.toggleGearItem('Sunglasses');
      expect(
          (notifier.value as WeatherLoaded).packedGear.contains('Sunglasses'),
          isTrue);

      notifier.toggleGearItem('Sunglasses');
      expect(
          (notifier.value as WeatherLoaded).packedGear.contains('Sunglasses'),
          isFalse);
    });

    test(
        'fetchWeatherForLocation transitions to WeatherErrorState upon failure',
        () async {
      mockRepo.shouldFail = true;
      await notifier.fetchWeatherForLocation(LocationEntity.defaultLocation);

      expect(notifier.value, isA<WeatherErrorState>());
    });
  });
}
