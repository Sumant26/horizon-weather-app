import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/core/constants/app_colors.dart';
import 'package:horizon/core/utils/unit_converter.dart';
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
import 'package:horizon/presentation/state/browser_pwa_coordinator.dart';

void main() {
  group('BrowserPwaCoordinator Tests', () {
    final coordinator = BrowserPwaCoordinator.instance;
    final now = DateTime.now();

    final testWeather = WeatherEntity(
      temperature: 19.5,
      feelsLike: 19.0,
      tempDifferenceYesterday: 1.5,
      humidity: 55.0,
      uvIndex: 4.0,
      cloudCover: 0.1,
      windSpeed: 12.0,
      condition: WeatherCondition.clearDay,
      timestamp: now,
      location: const LocationEntity(
        name: 'San Francisco',
        country: 'United States',
        latitude: 37.77,
        longitude: -122.41,
      ),
      astronomy: AstronomyEntity(
        sunrise: now,
        sunset: now,
        sunProgress: 0.5,
        isDaylight: true,
      ),
      airQuality: AirQualityEntity.fromValues(pm2_5: 8, pm10: 14, aqi: 20),
      windStream:
          WindStreamEntity.fromValues(speedKmh: 12, directionDegrees: 280),
      biophilicHealth: BiophilicHealthEntity.evaluate(
        surfacePressureHpa: 1014,
        pressureDelta12h: 0.2,
        uvIndex: 4,
        humidity: 55,
        temperature: 19.5,
      ),
      minutePrecipitation: MinutePrecipitationEntity.generate(
        isCurrentlyRaining: false,
        precipitationProbability: 0,
        hourlyPrecipitationMm: 0,
        now: now,
      ),
      yesterdayComparison: YesterdayComparisonEntity.fromHourlyData(
        todayTemps: List.filled(24, 19.5),
        baseDifference: 1.5,
      ),
      weatherAlerts: const WeatherAlertEntity(
        activeAlerts: [
          WeatherAlertItem(
            title: 'High UV Index Advisory',
            description: 'Apply SPF 30+ sun protection.',
            severity: AlertSeverity.advisory,
            icon: Icons.wb_sunny_rounded,
            badgeColor: AppColors.softAmber,
          ),
        ],
      ),
      deepMeteorology: const DeepMeteorologyEntity(
        visibilityKm: 20.0,
        cloudBaseMeters: 2500,
        directSolarRadiationWm2: 600,
        dewPointDepressionC: 8.0,
      ),
      dailyForecast: const [],
      hourlyForecast: const [],
    );

    test('syncWithWeather executes without throwing on all conditions', () {
      expect(
        () => coordinator.syncWithWeather(testWeather, TemperatureUnit.celsius),
        returnsNormally,
      );

      final rainyWeather = WeatherEntity(
        temperature: 14.0,
        feelsLike: 13.0,
        tempDifferenceYesterday: -3.0,
        humidity: 90.0,
        uvIndex: 1.0,
        cloudCover: 0.9,
        windSpeed: 22.0,
        condition: WeatherCondition.rainy,
        timestamp: now,
        location: testWeather.location,
        astronomy: testWeather.astronomy,
        airQuality: testWeather.airQuality,
        windStream: testWeather.windStream,
        biophilicHealth: testWeather.biophilicHealth,
        minutePrecipitation: MinutePrecipitationEntity.generate(
          isCurrentlyRaining: true,
          precipitationProbability: 90,
          hourlyPrecipitationMm: 4.5,
          now: now,
        ),
        yesterdayComparison: testWeather.yesterdayComparison,
        weatherAlerts: testWeather.weatherAlerts,
        deepMeteorology: testWeather.deepMeteorology,
        dailyForecast: const [],
        hourlyForecast: const [],
      );

      expect(
        () => coordinator.syncWithWeather(
            rainyWeather, TemperatureUnit.fahrenheit),
        returnsNormally,
      );
    });

    test('requestNotificationPermission invokes callback', () {
      bool called = false;
      coordinator.requestNotificationPermission((status) {
        called = true;
      });
      expect(called, isTrue);
    });
  });
}
