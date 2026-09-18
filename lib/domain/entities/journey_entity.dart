import 'package:flutter/foundation.dart';
import 'weather_condition.dart';

@immutable
class JourneyWaypoint {
  final String label;
  final String timeOffset;
  final double temperature;
  final WeatherCondition condition;
  final double rainProbability; // 0 - 100%
  final double windSpeedKmh;

  const JourneyWaypoint({
    required this.label,
    required this.timeOffset,
    required this.temperature,
    required this.condition,
    required this.rainProbability,
    required this.windSpeedKmh,
  });
}

enum TravelSafetyTier { optimal, cautious, severe }

@immutable
class JourneyEntity {
  final String originNode;
  final String destinationNode;
  final Duration estimatedDuration;
  final List<JourneyWaypoint> waypoints;
  final int safetyScore; // 0 - 100
  final TravelSafetyTier safetyTier;
  final String safetySummary;
  final String recommendedAction;

  const JourneyEntity({
    required this.originNode,
    required this.destinationNode,
    required this.estimatedDuration,
    required this.waypoints,
    required this.safetyScore,
    required this.safetyTier,
    required this.safetySummary,
    required this.recommendedAction,
  });

  factory JourneyEntity.simulate({
    required String origin,
    required String destination,
    required double baseTemp,
    required WeatherCondition baseCondition,
    required double baseWindSpeed,
    required double basePrecipitationProb,
  }) {
    // Generate realistic waypoints along route
    final waypoints = [
      JourneyWaypoint(
        label: origin,
        timeOffset: 'Depart 0 min',
        temperature: baseTemp,
        condition: baseCondition,
        rainProbability: basePrecipitationProb,
        windSpeedKmh: baseWindSpeed,
      ),
      JourneyWaypoint(
        label: 'Mid-Corridor',
        timeOffset: '+18 min',
        temperature: baseTemp - 0.4,
        condition: baseCondition,
        rainProbability: (basePrecipitationProb * 1.1).clamp(0.0, 100.0),
        windSpeedKmh: (baseWindSpeed * 1.08).clamp(0.0, 120.0),
      ),
      JourneyWaypoint(
        label: destination,
        timeOffset: 'Arrive +35 min',
        temperature: baseTemp - 0.8,
        condition: baseCondition,
        rainProbability: (basePrecipitationProb * 1.2).clamp(0.0, 100.0),
        windSpeedKmh: (baseWindSpeed * 1.15).clamp(0.0, 120.0),
      ),
    ];

    int score = 95;
    if (basePrecipitationProb > 50) score -= 30;
    if (basePrecipitationProb > 20) score -= 15;
    if (baseWindSpeed > 35) score -= 20;
    if (baseWindSpeed > 20) score -= 10;
    score = score.clamp(20, 100);

    final TravelSafetyTier tier;
    final String summary;
    final String action;

    if (score >= 80) {
      tier = TravelSafetyTier.optimal;
      summary = 'Clear, steady transit corridor with dry pavement.';
      action = 'Ideal commute conditions. Normal travel speed.';
    } else if (score >= 50) {
      tier = TravelSafetyTier.cautious;
      summary = 'Moderate crosswinds and slick road moisture expected.';
      action = 'Allow +10 mins extra buffer and maintain safe following gap.';
    } else {
      tier = TravelSafetyTier.severe;
      summary = 'High precipitation risk and reduced braking visibility.';
      action =
          'Delay non-essential transit or equip waterproof foul-weather gear.';
    }

    return JourneyEntity(
      originNode: origin,
      destinationNode: destination,
      estimatedDuration: const Duration(minutes: 35),
      waypoints: waypoints,
      safetyScore: score,
      safetyTier: tier,
      safetySummary: summary,
      recommendedAction: action,
    );
  }
}
