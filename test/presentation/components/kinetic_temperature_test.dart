import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
import 'package:horizon/presentation/components/kinetic_temperature.dart';

void main() {
  testWidgets('KineticTemperatureDisplay renders temperature and condition',
      (WidgetTester tester) async {
    final now = DateTime.now();
    final weather = WeatherEntity(
      temperature: 28.4,
      feelsLike: 30.0,
      tempDifferenceYesterday: 2.1,
      humidity: 60.0,
      uvIndex: 6.0,
      cloudCover: 0.1,
      windSpeed: 12.0,
      condition: WeatherCondition.clearDay,
      timestamp: now,
      location: LocationEntity.defaultLocation,
      astronomy: AstronomyEntity(
        sunrise: now,
        sunset: now,
        sunProgress: 0.5,
        isDaylight: true,
      ),
      airQuality: AirQualityEntity.fromValues(pm2_5: 10, pm10: 20, aqi: 25),
      windStream:
          WindStreamEntity.fromValues(speedKmh: 12.0, directionDegrees: 180),
      biophilicHealth: BiophilicHealthEntity.evaluate(
        surfacePressureHpa: 1013,
        pressureDelta12h: 0,
        uvIndex: 6,
        humidity: 60,
        temperature: 28.4,
      ),
      minutePrecipitation: MinutePrecipitationEntity.generate(
        isCurrentlyRaining: false,
        precipitationProbability: 0,
        hourlyPrecipitationMm: 0,
        now: now,
      ),
      yesterdayComparison: YesterdayComparisonEntity.fromHourlyData(
        todayTemps: List.filled(24, 28.4),
        baseDifference: 2.1,
      ),
      weatherAlerts: const WeatherAlertEntity(activeAlerts: []),
      deepMeteorology: const DeepMeteorologyEntity(
        visibilityKm: 18.0,
        cloudBaseMeters: 2500.0,
        directSolarRadiationWm2: 600.0,
        dewPointDepressionC: 10.0,
      ),
      hourlyForecast: const [],
      dailyForecast: const [],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: KineticTemperatureDisplay(
            data: weather,
            unit: TemperatureUnit.celsius,
          ),
        ),
      ),
    );

    expect(find.text('28°'), findsOneWidget);
    expect(find.text('Clear & Sunny'), findsOneWidget);
    expect(find.text('Feels like 30°C'), findsOneWidget);
    expect(find.text('2.1°C warmer than yesterday'), findsOneWidget);
  });
}
