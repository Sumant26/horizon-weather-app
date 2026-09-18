import 'package:flutter_test/flutter_test.dart';
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

void main() {
  group('WeatherEntity Domain Tests', () {
    final now = DateTime(2026, 10, 14, 21, 0); // 9 PM night
    final astronomyNight = AstronomyEntity(
      sunrise: DateTime(2026, 10, 14, 6, 0),
      sunset: DateTime(2026, 10, 14, 18, 0),
      sunProgress: 1.0,
      isDaylight: false,
    );
    final astronomyDay = AstronomyEntity(
      sunrise: DateTime(2026, 10, 14, 6, 0),
      sunset: DateTime(2026, 10, 14, 18, 0),
      sunProgress: 0.5,
      isDaylight: true,
    );
    final aqi = AirQualityEntity.fromValues(pm2_5: 12.0, pm10: 20.0, aqi: 25);
    final wind =
        WindStreamEntity.fromValues(speedKmh: 12, directionDegrees: 180);
    final bio = BiophilicHealthEntity.evaluate(
      surfacePressureHpa: 1013,
      pressureDelta12h: 0,
      uvIndex: 4,
      humidity: 50,
      temperature: 22,
    );
    final minutePrecip = MinutePrecipitationEntity.generate(
      isCurrentlyRaining: false,
      precipitationProbability: 0,
      hourlyPrecipitationMm: 0,
      now: now,
    );
    final yesterdayComp = YesterdayComparisonEntity.fromHourlyData(
      todayTemps: List.filled(24, 20.0),
      baseDifference: 0.0,
    );
    const alerts = WeatherAlertEntity(activeAlerts: []);
    const deepMet = DeepMeteorologyEntity(
      visibilityKm: 16.0,
      cloudBaseMeters: 2200.0,
      directSolarRadiationWm2: 450.0,
      dewPointDepressionC: 8.5,
    );

    test(
        'humanSummary computes cozy text based on condition and yesterday comparison',
        () {
      final rainyWeather = WeatherEntity(
        temperature: 19.0,
        feelsLike: 18.0,
        tempDifferenceYesterday: -2.5,
        humidity: 80.0,
        uvIndex: 2.0,
        cloudCover: 0.9,
        windSpeed: 10.0,
        condition: WeatherCondition.rainy,
        timestamp: now,
        location: LocationEntity.defaultLocation,
        astronomy: astronomyNight,
        airQuality: aqi,
        windStream: wind,
        biophilicHealth: bio,
        minutePrecipitation: minutePrecip,
        yesterdayComparison: yesterdayComp,
        weatherAlerts: alerts,
        deepMeteorology: deepMet,
        hourlyForecast: const [],
        dailyForecast: const [],
      );

      expect(rainyWeather.humanSummary, contains('Soft gentle showers'));
      expect(rainyWeather.humanSummary, contains('2.5°C cooler'));
      expect(rainyWeather.humanSummary, contains('cozy tea weather'));
    });

    test('recommendedGear selects items according to environmental thresholds',
        () {
      final coldRainyWeather = WeatherEntity(
        temperature: 15.0,
        feelsLike: 14.0,
        tempDifferenceYesterday: 0.0,
        humidity: 85.0,
        uvIndex: 6.0,
        cloudCover: 0.8,
        windSpeed: 5.0,
        condition: WeatherCondition.rainy,
        timestamp: now,
        location: LocationEntity.defaultLocation,
        astronomy: astronomyNight,
        airQuality: aqi,
        windStream: wind,
        biophilicHealth: bio,
        minutePrecipitation: minutePrecip,
        yesterdayComparison: yesterdayComp,
        weatherAlerts: alerts,
        deepMeteorology: deepMet,
        hourlyForecast: const [],
        dailyForecast: const [],
      );

      final gear = coldRainyWeather.recommendedGear;
      expect(gear, contains('Sunglasses')); // UV >= 5
      expect(gear, contains('Umbrella')); // Rainy
      expect(gear, contains('Warm Knit Sweater')); // Temp < 17
    });

    test(
        'nightSkyClarity returns null during daylight and evaluates clarity at night',
        () {
      final dayWeather = WeatherEntity(
        temperature: 24.0,
        feelsLike: 24.0,
        tempDifferenceYesterday: 1.0,
        humidity: 40.0,
        uvIndex: 5.0,
        cloudCover: 0.1,
        windSpeed: 6.0,
        condition: WeatherCondition.clearDay,
        timestamp: DateTime(2026, 10, 14, 12, 0),
        location: LocationEntity.defaultLocation,
        astronomy: astronomyDay,
        airQuality: aqi,
        windStream: wind,
        biophilicHealth: bio,
        minutePrecipitation: minutePrecip,
        yesterdayComparison: yesterdayComp,
        weatherAlerts: alerts,
        deepMeteorology: deepMet,
        hourlyForecast: const [],
        dailyForecast: const [],
      );

      expect(dayWeather.nightSkyClarity, isNull);

      final clearNightWeather = WeatherEntity(
        temperature: 18.0,
        feelsLike: 18.0,
        tempDifferenceYesterday: -1.0,
        humidity: 50.0,
        uvIndex: 0.0,
        cloudCover: 0.1,
        windSpeed: 4.0,
        condition: WeatherCondition.clearNight,
        timestamp: now,
        location: LocationEntity.defaultLocation,
        astronomy: astronomyNight,
        airQuality: aqi,
        windStream: wind,
        biophilicHealth: bio,
        minutePrecipitation: minutePrecip,
        yesterdayComparison: yesterdayComp,
        weatherAlerts: alerts,
        deepMeteorology: deepMet,
        hourlyForecast: const [],
        dailyForecast: const [],
      );

      expect(clearNightWeather.nightSkyClarity, contains('Pristine'));
    });

    test('AirQualityEntity evaluates health status tiers', () {
      final pure = AirQualityEntity.fromValues(pm2_5: 8.0, pm10: 15.0, aqi: 25);
      expect(pure.status, equals('Pure & Crisp'));

      final mod = AirQualityEntity.fromValues(pm2_5: 35.0, pm10: 60.0, aqi: 85);
      expect(mod.status, equals('Moderate'));
    });
  });
}
