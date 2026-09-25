import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/core/utils/unit_converter.dart';
import 'package:horizon/domain/entities/air_quality_entity.dart';
import 'package:horizon/domain/entities/astronomy_entity.dart';
import 'package:horizon/domain/entities/biophilic_health_entity.dart';
import 'package:horizon/domain/entities/daily_forecast_entity.dart';
import 'package:horizon/domain/entities/deep_meteorology_entity.dart';
import 'package:horizon/domain/entities/hike_dossier_entity.dart';
import 'package:horizon/domain/entities/location_entity.dart';
import 'package:horizon/domain/entities/minute_precipitation_entity.dart';
import 'package:horizon/domain/entities/weather_alert_entity.dart';
import 'package:horizon/domain/entities/weather_condition.dart';
import 'package:horizon/domain/entities/weather_entity.dart';
import 'package:horizon/domain/entities/wind_stream_entity.dart';
import 'package:horizon/domain/entities/yesterday_comparison_entity.dart';

void main() {
  group('HikeDossierEntity Tests', () {
    final now = DateTime(2026, 10, 14, 8, 30);
    final sunrise = DateTime(2026, 10, 14, 6, 15);
    final sunset = DateTime(2026, 10, 14, 19, 22);

    final testWeather = WeatherEntity(
      temperature: 12.0,
      feelsLike: 11.0,
      tempDifferenceYesterday: -2.0,
      humidity: 82.0,
      uvIndex: 4.0,
      cloudCover: 0.7,
      windSpeed: 18.0,
      condition: WeatherCondition.drizzle,
      timestamp: now,
      location: const LocationEntity(
        name: 'Mount Rainier Base',
        country: 'United States',
        latitude: 46.85,
        longitude: -121.76,
      ),
      astronomy: AstronomyEntity(
        sunrise: sunrise,
        sunset: sunset,
        sunProgress: 0.2,
        isDaylight: true,
      ),
      airQuality: AirQualityEntity.fromValues(pm2_5: 5.0, pm10: 10.0, aqi: 15),
      windStream: WindStreamEntity.fromValues(
        speedKmh: 18.0,
        directionDegrees: 240.0,
      ),
      biophilicHealth: BiophilicHealthEntity.evaluate(
        surfacePressureHpa: 1012.0,
        pressureDelta12h: -2.4,
        uvIndex: 4.0,
        humidity: 82.0,
        temperature: 12.0,
      ),
      minutePrecipitation: MinutePrecipitationEntity.generate(
        isCurrentlyRaining: true,
        precipitationProbability: 80,
        hourlyPrecipitationMm: 1.5,
        now: now,
      ),
      yesterdayComparison: YesterdayComparisonEntity.fromHourlyData(
        todayTemps: List.filled(24, 12.0),
        baseDifference: -2.0,
      ),
      weatherAlerts: const WeatherAlertEntity(activeAlerts: []),
      deepMeteorology: const DeepMeteorologyEntity(
        visibilityKm: 8.0,
        cloudBaseMeters: 450.0,
        directSolarRadiationWm2: 250.0,
        dewPointDepressionC: 1.5,
      ),
      dailyForecast: [
        DailyForecastEntity(
          date: now,
          minTemp: 8.0,
          maxTemp: 14.0,
          condition: WeatherCondition.drizzle,
          sunrise: sunrise,
          sunset: sunset,
          maxUvIndex: 4.0,
        ),
      ],
      hourlyForecast: const [],
    );

    test('generates accurate HikeDossierEntity from weather', () {
      final dossier = HikeDossierEntity.fromWeather(
        testWeather,
        tempUnit: TemperatureUnit.celsius,
      );

      expect(dossier.locationName, equals('Mount Rainier Base'));
      expect(dossier.currentTempFormatted, equals('12°C'));
      expect(dossier.sunriseTime, contains('06:15'));
      expect(dossier.sunsetTime, contains('07:22'));
      expect(dossier.safetyAdvisory, contains('Precipitation'));
      expect(dossier.barometricTrend, contains('hPa'));
    });

    test('toHtmlDocument generates valid HTML structure with matrix', () {
      final dossier = HikeDossierEntity.fromWeather(
        testWeather,
        tempUnit: TemperatureUnit.celsius,
      );
      final html = dossier.toHtmlDocument(TemperatureUnit.celsius);

      expect(html, contains('<h1>HORIZON OFF-GRID EXPEDITION DOSSIER</h1>'));
      expect(html, contains('Mount Rainier Base'));
      expect(html, contains('7-DAY MICROCLIMATE MATRIX'));
      expect(html, contains('06:15'));
    });

    test('toMarkdownDocument generates clean markdown format', () {
      final dossier = HikeDossierEntity.fromWeather(
        testWeather,
        tempUnit: TemperatureUnit.celsius,
      );
      final md = dossier.toMarkdownDocument(TemperatureUnit.celsius);

      expect(md, startsWith('# HORIZON OFF-GRID EXPEDITION DOSSIER'));
      expect(md, contains('Mount Rainier Base'));
      expect(md, contains('## Daylight Window'));
      expect(md, contains('- [ ]'));
    });
  });
}
