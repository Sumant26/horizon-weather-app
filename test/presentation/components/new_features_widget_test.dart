import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/core/utils/unit_converter.dart';
import 'package:horizon/domain/entities/air_quality_entity.dart';
import 'package:horizon/domain/entities/astronomy_entity.dart';
import 'package:horizon/domain/entities/biophilic_health_entity.dart';
import 'package:horizon/domain/entities/daily_forecast_entity.dart';
import 'package:horizon/domain/entities/deep_meteorology_entity.dart';
import 'package:horizon/domain/entities/location_entity.dart';
import 'package:horizon/domain/entities/minute_precipitation_entity.dart';
import 'package:horizon/domain/entities/weather_alert_entity.dart';
import 'package:horizon/domain/entities/weather_condition.dart';
import 'package:horizon/domain/entities/weather_entity.dart';
import 'package:horizon/domain/entities/wind_stream_entity.dart';
import 'package:horizon/domain/entities/yesterday_comparison_entity.dart';
import 'package:horizon/presentation/components/audio_briefing_modal.dart';
import 'package:horizon/presentation/components/interactive_radar_modal.dart';
import 'package:horizon/presentation/components/off_grid_hike_exporter_modal.dart';

void main() {
  final now = DateTime.now();

  final testWeather = WeatherEntity(
    temperature: 15.0,
    feelsLike: 14.0,
    tempDifferenceYesterday: 0.0,
    humidity: 50.0,
    uvIndex: 3.0,
    cloudCover: 0.3,
    windSpeed: 14.0,
    condition: WeatherCondition.partlyCloudyDay,
    timestamp: now,
    location: const LocationEntity(
      name: 'Alpine Meadows',
      country: 'United States',
      latitude: 39.16,
      longitude: -120.24,
    ),
    astronomy: AstronomyEntity(
      sunrise: now,
      sunset: now,
      sunProgress: 0.5,
      isDaylight: true,
    ),
    airQuality: AirQualityEntity.fromValues(pm2_5: 4, pm10: 8, aqi: 12),
    windStream:
        WindStreamEntity.fromValues(speedKmh: 14.0, directionDegrees: 180.0),
    biophilicHealth: BiophilicHealthEntity.evaluate(
      surfacePressureHpa: 1015.0,
      pressureDelta12h: 0.0,
      uvIndex: 3.0,
      humidity: 50.0,
      temperature: 15.0,
    ),
    minutePrecipitation: MinutePrecipitationEntity.generate(
      isCurrentlyRaining: false,
      precipitationProbability: 0,
      hourlyPrecipitationMm: 0,
      now: now,
    ),
    yesterdayComparison: YesterdayComparisonEntity.fromHourlyData(
      todayTemps: List.filled(24, 15.0),
      baseDifference: 0.0,
    ),
    weatherAlerts: const WeatherAlertEntity(activeAlerts: []),
    deepMeteorology: const DeepMeteorologyEntity(
      visibilityKm: 15.0,
      cloudBaseMeters: 1200.0,
      directSolarRadiationWm2: 500.0,
      dewPointDepressionC: 6.0,
    ),
    dailyForecast: [
      DailyForecastEntity(
        date: now,
        minTemp: 10.0,
        maxTemp: 18.0,
        condition: WeatherCondition.partlyCloudyDay,
        sunrise: now,
        sunset: now,
        maxUvIndex: 3.0,
      ),
    ],
    hourlyForecast: const [],
  );

  group('New Feature Modal Widget Tests', () {
    testWidgets('InteractiveRadarModal renders canvas, layers, and probe',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InteractiveRadarModal(
              condition: testWeather.condition,
              windStream: testWeather.windStream,
              baseTemperatureC: testWeather.temperature,
              locationName: testWeather.locationName,
              speedUnit: SpeedUnit.kmh,
              tempUnit: TemperatureUnit.celsius,
            ),
          ),
        ),
      );

      expect(find.text('INTERACTIVE MICROCLIMATE RADAR'), findsOneWidget);
      expect(
          find.text('Alpine Meadows • 100 km Radius Corridor'), findsOneWidget);
      expect(find.text('Precipitation'), findsOneWidget);
      expect(find.text('Wind Vectors'), findsOneWidget);

      await tester.tap(find.text('Wind Vectors'));
      await tester.pump();

      expect(find.text('Wind Vectors'), findsOneWidget);
    });

    testWidgets('AudioBriefingModal renders visualizer and controls',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AudioBriefingModal(
              briefing: testWeather.dailyBriefing,
              locationName: testWeather.locationName,
            ),
          ),
        ),
      );

      expect(find.text('EDITORIAL VOICE BROADCAST'), findsOneWidget);
      expect(find.text('Alpine Meadows'), findsOneWidget);
      expect(find.text(testWeather.dailyBriefing.narrative), findsOneWidget);
    });

    testWidgets('OffGridHikeExporterModal renders matrix and export buttons',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OffGridHikeExporterModal(
              weather: testWeather,
              tempUnit: TemperatureUnit.celsius,
            ),
          ),
        ),
      );

      expect(find.text('OFF-GRID EXPEDITION DOSSIER'), findsOneWidget);
      expect(find.text('ALPINE MEADOWS'), findsOneWidget);
      expect(find.text('PRINT / PDF'), findsOneWidget);
      expect(find.text('MARKDOWN'), findsOneWidget);
    });
  });
}
