import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/core/utils/unit_converter.dart';
import 'package:horizon/domain/entities/air_quality_entity.dart';
import 'package:horizon/domain/entities/astronomy_entity.dart';
import 'package:horizon/domain/entities/biophilic_health_entity.dart';
import 'package:horizon/domain/entities/daily_forecast_entity.dart';
import 'package:horizon/domain/entities/deep_meteorology_entity.dart';
import 'package:horizon/domain/entities/hourly_forecast_entity.dart';
import 'package:horizon/domain/entities/location_entity.dart';
import 'package:horizon/domain/entities/minute_precipitation_entity.dart';
import 'package:horizon/domain/entities/weather_alert_entity.dart';
import 'package:horizon/domain/entities/weather_condition.dart';
import 'package:horizon/domain/entities/weather_entity.dart';
import 'package:horizon/domain/entities/wind_stream_entity.dart';
import 'package:horizon/domain/entities/yesterday_comparison_entity.dart';
import 'package:horizon/presentation/components/card_detail_modal.dart';
import 'package:horizon/presentation/utils/card_detail_factory.dart';

void main() {
  final testWeather = WeatherEntity(
    temperature: 24.0,
    feelsLike: 25.0,
    tempDifferenceYesterday: 1.5,
    humidity: 55.0,
    uvIndex: 6.0,
    cloudCover: 0.2,
    windSpeed: 12.0,
    condition: WeatherCondition.clearDay,
    timestamp: DateTime(2026, 9, 18, 12, 0),
    location: const LocationEntity(
        name: 'Shivajinagar', latitude: 18.52, longitude: 73.85),
    astronomy: AstronomyEntity(
      sunrise: DateTime(2026, 9, 18, 6, 15),
      sunset: DateTime(2026, 9, 18, 18, 30),
      sunProgress: 0.5,
      isDaylight: true,
      goldenHourMorning: DateTime(2026, 9, 18, 6, 45),
      goldenHourEvening: DateTime(2026, 9, 18, 17, 50),
    ),
    airQuality: const AirQualityEntity(
      aqi: 42,
      status: 'Clean',
      pm2_5: 9.5,
      pm10: 18.2,
      ozone: 24.0,
      recommendation: 'Air quality is pristine.',
    ),
    windStream: const WindStreamEntity(
      speedKmh: 12.0,
      gustKmh: 18.0,
      directionDegrees: 240.0,
      cardinalBearing: 'SW',
      beaufortScale: 'Gentle Breeze',
    ),
    biophilicHealth: const BiophilicHealthEntity(
      surfacePressureHpa: 1013.0,
      pressureDelta12h: 0.2,
      pressureTrend: PressureTrend.steady,
      headacheRiskStatus: 'Stable Barometric Equilibrium',
      headacheAdvice: 'Minimal risk of weather-induced headaches.',
      vitaminDWindow: '10:00 AM – 2:00 PM',
      vitaminDAdvice: 'Optimal daylight.',
      breathabilityScore: 'Optimal',
      dewPoint: 12.0,
      treePollen: PollenLevel.low,
      grassPollen: PollenLevel.low,
      weedPollen: PollenLevel.low,
      overallAllergenAdvice: 'Pristine pollen count.',
    ),
    minutePrecipitation: const MinutePrecipitationEntity(
      minutePoints: [],
      hasPrecipitation: false,
      summaryText: 'No rain in next 60 minutes.',
    ),
    yesterdayComparison: YesterdayComparisonEntity(
      todayHourlyTemps: List.generate(24, (i) => 20.0 + i * 0.3),
      yesterdayHourlyTemps: List.generate(24, (i) => 18.5 + i * 0.3),
    ),
    weatherAlerts: const WeatherAlertEntity(activeAlerts: []),
    deepMeteorology: const DeepMeteorologyEntity(
      visibilityKm: 25.8,
      cloudBaseMeters: 1800.0,
      directSolarRadiationWm2: 737.0,
      dewPointDepressionC: 10.6,
    ),
    hourlyForecast: List.generate(
      24,
      (i) => HourlyForecastEntity(
        time: DateTime(2026, 9, 18, i),
        temperature: 20.0 + i * 0.3,
        condition: WeatherCondition.clearDay,
        precipitationProbability: 10,
        uvIndex: 5.0,
      ),
    ),
    dailyForecast: [
      DailyForecastEntity(
        date: DateTime(2026, 9, 18),
        maxTemp: 28.0,
        minTemp: 18.0,
        condition: WeatherCondition.clearDay,
        maxUvIndex: 6.0,
        sunrise: DateTime(2026, 9, 18, 6, 15),
        sunset: DateTime(2026, 9, 18, 18, 30),
      ),
    ],
  );

  testWidgets(
      'CardDetailModal renders Precision Meteorology details and copy button',
      (WidgetTester tester) async {
    final content = CardDetailFactory.createPrecisionMeteorology(
      testWeather,
      TemperatureUnit.celsius,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => CardDetailModal.show(
                context: context,
                content: content,
                weather: testWeather,
                unit: TemperatureUnit.celsius,
              ),
              child: const Text('Open Modal'),
            ),
          ),
        ),
      ),
    );

    // Tap button to open modal
    await tester.tap(find.text('Open Modal'));
    await tester.pumpAndSettle();

    // Verify modal elements
    expect(find.text('Precision Meteorology Matrix'), findsOneWidget);
    expect(find.text('MICROCLIMATE SENSORS'), findsOneWidget);
    expect(find.text('737 W/m²'), findsNWidgets(2));
    expect(find.text('OPTICAL VISIBILITY'), findsOneWidget);
    expect(find.text('25.8 km'), findsOneWidget);
    expect(find.text('Copy Insight'), findsOneWidget);
    expect(find.text('Share Story'), findsOneWidget);

    // Tap copy insight
    await tester.tap(find.text('Copy Insight'));
    await tester.pump(const Duration(seconds: 3));
  });
}
