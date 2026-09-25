import 'air_quality_entity.dart';
import 'astronomy_entity.dart';
import 'biophilic_health_entity.dart';
import 'daily_briefing_entity.dart';
import 'daily_forecast_entity.dart';
import 'deep_meteorology_entity.dart';
import 'hourly_forecast_entity.dart';
import 'journey_entity.dart';
import 'location_entity.dart';
import 'minute_precipitation_entity.dart';
import 'smart_trigger_entity.dart';
import 'thermal_comfort_entity.dart';
import 'weather_alert_entity.dart';
import 'weather_condition.dart';
import 'wind_stream_entity.dart';
import 'yesterday_comparison_entity.dart';

class WeatherEntity {
  final double temperature;
  final double feelsLike;
  final double tempDifferenceYesterday;
  final double humidity;
  final double uvIndex;
  final double cloudCover;
  final double windSpeed;
  final WeatherCondition condition;
  final DateTime timestamp;
  final LocationEntity location;
  final AstronomyEntity astronomy;
  final AirQualityEntity airQuality;
  final WindStreamEntity windStream;
  final BiophilicHealthEntity biophilicHealth;
  final MinutePrecipitationEntity minutePrecipitation;
  final YesterdayComparisonEntity yesterdayComparison;
  final WeatherAlertEntity weatherAlerts;
  final DeepMeteorologyEntity deepMeteorology;
  final List<HourlyForecastEntity> hourlyForecast;
  final List<DailyForecastEntity> dailyForecast;
  final bool isFromCache;

  const WeatherEntity({
    required this.temperature,
    required this.feelsLike,
    required this.tempDifferenceYesterday,
    required this.humidity,
    required this.uvIndex,
    required this.cloudCover,
    required this.windSpeed,
    required this.condition,
    required this.timestamp,
    required this.location,
    required this.astronomy,
    required this.airQuality,
    required this.windStream,
    required this.biophilicHealth,
    required this.minutePrecipitation,
    required this.yesterdayComparison,
    required this.weatherAlerts,
    required this.deepMeteorology,
    required this.hourlyForecast,
    required this.dailyForecast,
    this.isFromCache = false,
  });

  String get locationName => location.name;

  // Feature: Daily Briefing & Ambient Soundscape
  DailyBriefingEntity get dailyBriefing => DailyBriefingEntity.compute(
        timestamp: timestamp,
        locationName: location.name,
        currentTemp: temperature,
        tempDiffYesterday: tempDifferenceYesterday,
        condition: condition,
        optimalWindow: '6:30 AM – 8:45 AM',
      );

  // Feature: Route & Commute Journey Simulator
  JourneyEntity get journey => JourneyEntity.simulate(
        origin: location.name,
        destination: 'North Technology District',
        baseTemp: temperature,
        baseCondition: condition,
        baseWindSpeed: windSpeed,
        basePrecipitationProb:
            minutePrecipitation.hasPrecipitation ? 65.0 : 15.0,
      );

  // Feature: Bioclimatic Thermal Comfort Breakdown
  ThermalComfortEntity get thermalComfort => ThermalComfortEntity.compute(
        ambientTemp: temperature,
        humidity: humidity,
        windSpeedKmh: windSpeed,
        uvIndex: uvIndex,
        isDaytime: astronomy.isDaylight,
      );

  // Feature: Proactive Smart Triggers & Notifications
  SmartTriggerEntity get smartTriggers => SmartTriggerEntity.evaluate(
        minutePrecipitation: minutePrecipitation,
        biophilicHealth: biophilicHealth,
        uvIndex: uvIndex,
        condition: condition,
      );

  // Feature 1: Cozy & Human-First Glanceable Summary
  String get humanSummary {
    final diff = tempDifferenceYesterday.abs().toStringAsFixed(1);
    final comparison = tempDifferenceYesterday < 0 ? 'cooler' : 'warmer';

    switch (condition) {
      case WeatherCondition.rainy:
      case WeatherCondition.drizzle:
        return "Soft gentle showers outside. It's about $diff°C $comparison than yesterday—perfect cozy tea weather.";
      case WeatherCondition.extremeHeat:
        return "Warm radiant sun out there. Noticeably $comparison than yesterday afternoon. Seek some calm shade.";
      case WeatherCondition.clearNight:
      case WeatherCondition.partlyCloudyNight:
        return "Crisp and tranquil night under open skies. About $diff°C $comparison than yesterday evening.";
      case WeatherCondition.overcast:
      case WeatherCondition.foggy:
        return "The sky is wrapped in a soft blanket of clouds. Mellow and $diff°C $comparison than yesterday.";
      case WeatherCondition.snowy:
        return "Gentle snow flurries falling. A crisp $diff°C $comparison than yesterday—bundle up warm.";
      case WeatherCondition.thunderstorm:
        return "Distant thunder rolling through. Safe and sound indoors while the storm clears.";
      case WeatherCondition.clearDay:
      case WeatherCondition.partlyCloudyDay:
        return "A serene, comfortable day. About $diff°C $comparison than yesterday at this exact hour.";
    }
  }

  // Feature 2: Night Sky Clarity Index (Stargazing Window)
  String? get nightSkyClarity {
    if (astronomy.isDaylight) {
      return null;
    }
    if (cloudCover > 0.45) {
      return 'Sky Clarity: Soft haze (Passing cloud cover)';
    }
    if (humidity > 78) {
      return 'Sky Clarity: Fair (Atmospheric mist)';
    }
    return 'Sky Clarity: Pristine (Crisp view of stars & constellations)';
  }

  // Feature 3: Minimalist Wardrobe & Gear Recommendations
  List<String> get recommendedGear {
    final List<String> gear = [];
    if (uvIndex >= 5) {
      gear.add('Sunglasses');
    }
    if (condition == WeatherCondition.rainy ||
        condition == WeatherCondition.drizzle) {
      gear.add('Umbrella');
    }
    if (temperature < 17) {
      gear.add('Warm Knit Sweater');
    } else if (temperature < 22) {
      gear.add('Light Jacket');
    }
    if (temperature > 28) {
      gear.add('Water Flask');
    }
    if (condition == WeatherCondition.snowy) {
      gear.add('Cozy Scarf');
    }
    if (gear.isEmpty) {
      gear.add('Just yourself & good company');
    }
    return gear;
  }
}
