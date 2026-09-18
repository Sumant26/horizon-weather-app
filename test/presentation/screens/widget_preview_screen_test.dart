import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/core/theme/app_theme.dart';
import 'package:horizon/core/utils/unit_converter.dart';
import 'package:horizon/domain/entities/air_quality_entity.dart';
import 'package:horizon/domain/entities/astronomy_entity.dart';
import 'package:horizon/domain/entities/biophilic_health_entity.dart';
import 'package:horizon/domain/entities/deep_meteorology_entity.dart';
import 'package:horizon/domain/entities/hourly_forecast_entity.dart';
import 'package:horizon/domain/entities/location_entity.dart';
import 'package:horizon/domain/entities/minute_precipitation_entity.dart';
import 'package:horizon/domain/entities/weather_alert_entity.dart';
import 'package:horizon/domain/entities/weather_condition.dart';
import 'package:horizon/domain/entities/weather_entity.dart';
import 'package:horizon/domain/entities/wind_stream_entity.dart';
import 'package:horizon/domain/entities/yesterday_comparison_entity.dart';
import 'package:horizon/presentation/screens/widget_preview_screen.dart';

void main() {
  group('WidgetPreviewScreen Tests', () {
    late WeatherEntity weather;

    setUp(() {
      final now = DateTime(2026, 9, 18, 12, 0);
      weather = WeatherEntity(
        temperature: 22.0,
        feelsLike: 21.0,
        tempDifferenceYesterday: 2.5,
        humidity: 45.0,
        uvIndex: 3.5,
        cloudCover: 0.1,
        windSpeed: 10.0,
        condition: WeatherCondition.clearDay,
        timestamp: now,
        location: const LocationEntity(
          name: 'San Francisco',
          country: 'United States',
          latitude: 37.7749,
          longitude: -122.4194,
        ),
        astronomy: AstronomyEntity(
          sunrise: now,
          sunset: now.add(const Duration(hours: 12)),
          sunProgress: 0.5,
          isDaylight: true,
        ),
        airQuality:
            AirQualityEntity.fromValues(pm2_5: 8.0, pm10: 15.0, aqi: 20),
        windStream:
            WindStreamEntity.fromValues(speedKmh: 10.0, directionDegrees: 270),
        biophilicHealth: BiophilicHealthEntity.evaluate(
          surfacePressureHpa: 1015,
          pressureDelta12h: 0,
          uvIndex: 3.5,
          humidity: 45,
          temperature: 22,
        ),
        minutePrecipitation: MinutePrecipitationEntity.generate(
          isCurrentlyRaining: false,
          precipitationProbability: 0,
          hourlyPrecipitationMm: 0,
          now: now,
        ),
        yesterdayComparison: YesterdayComparisonEntity.fromHourlyData(
          todayTemps: List.filled(24, 22.0),
          baseDifference: 2.5,
        ),
        weatherAlerts: const WeatherAlertEntity(activeAlerts: []),
        deepMeteorology: const DeepMeteorologyEntity(
          visibilityKm: 15.0,
          cloudBaseMeters: 2000.0,
          directSolarRadiationWm2: 500.0,
          dewPointDepressionC: 9.0,
        ),
        hourlyForecast: [
          HourlyForecastEntity(
            time: now,
            temperature: 22.0,
            precipitationProbability: 0,
            condition: WeatherCondition.clearDay,
            uvIndex: 3.5,
          ),
        ],
        dailyForecast: const [],
      );
    });

    testWidgets('renders all 4 widget gallery layouts and titles',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: WidgetPreviewScreen(
            weather: weather,
            unit: TemperatureUnit.celsius,
            initialTheme: VisualThemeMode.cozyWarm,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('WIDGET GALLERY & DESIGNER'), findsOneWidget);
      expect(find.text('COMPACT 2x2 GLANCE'), findsOneWidget);
      expect(find.text('WIDE 4x2 DASHBOARD'), findsOneWidget);
      expect(find.text('LOCK SCREEN CAPSULE'), findsOneWidget);
      expect(find.text('DYNAMIC ISLAND LIVE ACTIVITY'), findsOneWidget);
    });
  });
}
