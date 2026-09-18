import 'package:flutter/foundation.dart';
import 'biophilic_health_entity.dart';
import 'minute_precipitation_entity.dart';
import 'weather_condition.dart';

enum TriggerCategory {
  rainOnset,
  barometricDrop,
  goldenHour,
  solarUv,
}

@immutable
class SmartTriggerItem {
  final String id;
  final TriggerCategory category;
  final String title;
  final String message;
  final String timestampSummary;
  final bool isTriggered;
  final bool isEnabled;

  const SmartTriggerItem({
    required this.id,
    required this.category,
    required this.title,
    required this.message,
    required this.timestampSummary,
    required this.isTriggered,
    this.isEnabled = true,
  });

  SmartTriggerItem copyWith({bool? isEnabled}) {
    return SmartTriggerItem(
      id: id,
      category: category,
      title: title,
      message: message,
      timestampSummary: timestampSummary,
      isTriggered: isTriggered,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

@immutable
class SmartTriggerEntity {
  final List<SmartTriggerItem> triggers;

  const SmartTriggerEntity({required this.triggers});

  int get activeTriggerCount =>
      triggers.where((t) => t.isTriggered && t.isEnabled).length;

  factory SmartTriggerEntity.evaluate({
    required MinutePrecipitationEntity minutePrecipitation,
    required BiophilicHealthEntity biophilicHealth,
    required double uvIndex,
    required WeatherCondition condition,
  }) {
    final List<SmartTriggerItem> list = [];

    // 1. Rain Onset Trigger
    final hasRainSoon = minutePrecipitation.hasPrecipitation &&
        minutePrecipitation.onsetMinute != null &&
        minutePrecipitation.onsetMinute! <= 30;

    list.add(
      SmartTriggerItem(
        id: 'rain_onset',
        category: TriggerCategory.rainOnset,
        title: 'Rain Onset Proximity',
        message: hasRainSoon
            ? 'Showers initiating in ~${minutePrecipitation.onsetMinute} min at your node. Umbrella recommended.'
            : 'No immediate precipitation detected within the next 45 minutes.',
        timestampSummary: hasRainSoon
            ? 'In ${minutePrecipitation.onsetMinute} min'
            : 'Clear window',
        isTriggered: hasRainSoon,
      ),
    );

    // 2. Barometric Drop Migraine Advisory Trigger
    final isDroppingFast =
        biophilicHealth.pressureTrend == PressureTrend.droppingFast;

    list.add(
      SmartTriggerItem(
        id: 'barometric_drop',
        category: TriggerCategory.barometricDrop,
        title: 'Rapid Barometric Drop Warning',
        message: isDroppingFast
            ? 'Atmospheric pressure dropping >2.5 hPa/hr. Elevated probability of weather-related headaches & migraines.'
            : 'Barometric curve is calm and stable with nominal biometric strain.',
        timestampSummary: isDroppingFast ? 'Next 3 Hours' : 'Nominal',
        isTriggered: isDroppingFast,
      ),
    );

    // 3. Golden Hour Photography Trigger
    final isClearOrScattered = condition == WeatherCondition.clearDay ||
        condition == WeatherCondition.partlyCloudyDay;

    list.add(
      SmartTriggerItem(
        id: 'golden_hour',
        category: TriggerCategory.goldenHour,
        title: 'Golden Hour Photography Window',
        message: isClearOrScattered
            ? 'Clean horizon and scattering profile: optimal warm golden light estimated between 5:50 PM and 6:35 PM.'
            : 'Dense overcast diffusion will soften ambient evening tones.',
        timestampSummary:
            isClearOrScattered ? '5:50 PM - 6:35 PM' : 'Diffused lighting',
        isTriggered: isClearOrScattered,
      ),
    );

    // 4. Solar UV Peak Advisory Trigger
    final isHighUv = uvIndex >= 6.0;

    list.add(
      SmartTriggerItem(
        id: 'solar_uv',
        category: TriggerCategory.solarUv,
        title: 'Extreme Solar Radiation Advisory',
        message: isHighUv
            ? 'UV Index peaking at ${uvIndex.toStringAsFixed(1)}. Apply SPF 50+ sunscreen and seek shade during midday hours.'
            : 'UV radiation is at safe, gentle levels (${uvIndex.toStringAsFixed(1)}).',
        timestampSummary: isHighUv ? 'Peak Midday UV' : 'Safe UV',
        isTriggered: isHighUv,
      ),
    );

    return SmartTriggerEntity(triggers: list);
  }
}
