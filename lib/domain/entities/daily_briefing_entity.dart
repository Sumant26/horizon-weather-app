import 'package:flutter/foundation.dart';
import 'weather_condition.dart';

enum BriefingPeriod { morning, afternoon, evening, night }

enum SoundscapeType {
  gentleRain,
  morningBirdsong,
  forestBreeze,
  hearthEmbers,
  starlitChimes,
}

@immutable
class DailyBriefingEntity {
  final BriefingPeriod period;
  final String greeting;
  final String narrative;
  final String keyHighlight;
  final SoundscapeType recommendedSoundscape;
  final String soundscapeName;
  final String soundscapeDescription;

  const DailyBriefingEntity({
    required this.period,
    required this.greeting,
    required this.narrative,
    required this.keyHighlight,
    required this.recommendedSoundscape,
    required this.soundscapeName,
    required this.soundscapeDescription,
  });

  factory DailyBriefingEntity.compute({
    required DateTime timestamp,
    required String locationName,
    required double currentTemp,
    required double tempDiffYesterday,
    required WeatherCondition condition,
    required String optimalWindow,
  }) {
    final hour = timestamp.hour;
    final BriefingPeriod period;
    final String greeting;

    if (hour >= 5 && hour < 12) {
      period = BriefingPeriod.morning;
      greeting = 'Good morning, $locationName';
    } else if (hour >= 12 && hour < 17) {
      period = BriefingPeriod.afternoon;
      greeting = 'Good afternoon, $locationName';
    } else if (hour >= 17 && hour < 22) {
      period = BriefingPeriod.evening;
      greeting = 'Good evening, $locationName';
    } else {
      period = BriefingPeriod.night;
      greeting = 'Serene night, $locationName';
    }

    final diffAbs = tempDiffYesterday.abs().toStringAsFixed(1);
    final diffWord = tempDiffYesterday >= 0 ? 'warmer' : 'cooler';
    final tempComparison =
        'Today is tracking about $diffAbs°C $diffWord than yesterday at this time.';

    final String conditionInsight;
    final SoundscapeType soundscape;
    final String soundName;
    final String soundDesc;

    switch (condition) {
      case WeatherCondition.rainy:
      case WeatherCondition.drizzle:
      case WeatherCondition.thunderstorm:
        conditionInsight =
            'Atmospheric precipitation is active. Keep an umbrella close and enjoy the grounding petrichor.';
        soundscape = SoundscapeType.gentleRain;
        soundName = 'Nordic Rain Pitter-Patter';
        soundDesc = 'Calming steady raindrops on cedar shingles';
      case WeatherCondition.clearNight:
      case WeatherCondition.partlyCloudyNight:
        conditionInsight =
            'Stargazing visibility is exceptional tonight. Ambient air is crisp and settling peacefully.';
        soundscape = SoundscapeType.starlitChimes;
        soundName = 'Celestial Ambient Twilight';
        soundDesc = 'Deep sub-bass air tones with ethereal shimmer';
      case WeatherCondition.clearDay:
      case WeatherCondition.partlyCloudyDay:
        if (period == BriefingPeriod.morning) {
          conditionInsight =
              'Golden sunlight with clean atmospheric dispersion. Optimal outdoor window: $optimalWindow.';
          soundscape = SoundscapeType.morningBirdsong;
          soundName = 'Highland Dawn Chorus';
          soundDesc = 'Early morning warblers and gentle pine breeze';
        } else {
          conditionInsight =
              'Comfortable ambient conditions. Optimal outdoor window: $optimalWindow.';
          soundscape = SoundscapeType.forestBreeze;
          soundName = 'Alpine Canopy Rustle';
          soundDesc = 'Soft wind moving through birch trees';
        }
      case WeatherCondition.extremeHeat:
        conditionInsight =
            'Thermal load is elevated today. Hydrate proactively and favor indoor or shaded movement.';
        soundscape = SoundscapeType.forestBreeze;
        soundName = 'Shaded Oasis Stream';
        soundDesc = 'Cool mountain brook flowing over river stone';
      case WeatherCondition.overcast:
      case WeatherCondition.foggy:
      case WeatherCondition.snowy:
        conditionInsight =
            'Muted overcast lighting and steady barometric conditions. Optimal window: $optimalWindow.';
        soundscape = SoundscapeType.hearthEmbers;
        soundName = 'Warm Cedar Hearth';
        soundDesc = 'Subtle wood crackle and comforting warmth';
    }

    final narrative = '$greeting. $tempComparison $conditionInsight';
    final keyHighlight =
        '${tempDiffYesterday >= 0 ? '↑' : '↓'} $diffAbs°C vs Yesterday • $optimalWindow';

    return DailyBriefingEntity(
      period: period,
      greeting: greeting,
      narrative: narrative,
      keyHighlight: keyHighlight,
      recommendedSoundscape: soundscape,
      soundscapeName: soundName,
      soundscapeDescription: soundDesc,
    );
  }
}
