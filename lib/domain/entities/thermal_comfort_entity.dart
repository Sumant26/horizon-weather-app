import 'dart:math';
import 'package:flutter/foundation.dart';

@immutable
class ThermalComfortEntity {
  final double ambientTemp;
  final double feelsLikeTemp;
  final double solarRadiationDelta; // e.g. +2.1°C
  final double humidityDelta; // e.g. +1.8°C
  final double windChillDelta; // e.g. -1.2°C
  final double clothingInsulationClo; // e.g. 0.6 clo
  final String clothingRecommendation;
  final String physiologicalSummary;

  const ThermalComfortEntity({
    required this.ambientTemp,
    required this.feelsLikeTemp,
    required this.solarRadiationDelta,
    required this.humidityDelta,
    required this.windChillDelta,
    required this.clothingInsulationClo,
    required this.clothingRecommendation,
    required this.physiologicalSummary,
  });

  factory ThermalComfortEntity.compute({
    required double ambientTemp,
    required double humidity, // 0 - 100
    required double windSpeedKmh,
    required double uvIndex,
    required bool isDaytime,
  }) {
    // 1. Solar Radiation Heat Load
    final double solarDelta;
    if (isDaytime) {
      solarDelta = double.parse((uvIndex * 0.28 + 0.4).toStringAsFixed(1));
    } else {
      solarDelta = 0.0;
    }

    // 2. Humidity / Vapor Pressure Delta
    final double humidDelta;
    if (ambientTemp > 20) {
      final excessHumidity = max(0.0, humidity - 40.0);
      humidDelta = double.parse((excessHumidity * 0.045).toStringAsFixed(1));
    } else {
      humidDelta = 0.0;
    }

    // 3. Wind-Chill Convective Dissipation
    final double windDelta;
    if (windSpeedKmh > 5.0) {
      final windEffect = min(4.5, (windSpeedKmh - 5.0) * 0.11);
      windDelta = -double.parse(windEffect.toStringAsFixed(1));
    } else {
      windDelta = 0.0;
    }

    final apparent = ambientTemp + solarDelta + humidDelta + windDelta;
    final feelsLike = double.parse(apparent.toStringAsFixed(1));

    // 4. Clothing Insulation clo Index
    final double clo;
    final String clothes;
    final String summary;

    if (feelsLike >= 30) {
      clo = 0.35;
      clothes = 'Ultralight linen, breathable mesh, moisture-wicking tees';
      summary =
          'High thermal retention. Body requires maximum skin aeration and hydration.';
    } else if (feelsLike >= 22) {
      clo = 0.60;
      clothes = 'Lightweight cotton shirt, relaxed chinos or shorts';
      summary =
          'Near-neutral thermal equilibrium. Minimal physiological heat strain.';
    } else if (feelsLike >= 15) {
      clo = 1.00;
      clothes = 'Long sleeve knit, light cardigan or structured windbreaker';
      summary =
          'Gentle convective cooling. Light insulating layer prevents chill.';
    } else {
      clo = 1.65;
      clothes = 'Thermal base layer, wool sweater, wind-resistant outer shell';
      summary =
          'Substantial body heat loss. Multi-tier trapping insulation recommended.';
    }

    return ThermalComfortEntity(
      ambientTemp: ambientTemp,
      feelsLikeTemp: feelsLike,
      solarRadiationDelta: solarDelta,
      humidityDelta: humidDelta,
      windChillDelta: windDelta,
      clothingInsulationClo: clo,
      clothingRecommendation: clothes,
      physiologicalSummary: summary,
    );
  }
}
