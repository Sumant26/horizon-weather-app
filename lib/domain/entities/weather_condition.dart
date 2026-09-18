enum WeatherCondition {
  clearDay,
  clearNight,
  partlyCloudyDay,
  partlyCloudyNight,
  overcast,
  foggy,
  drizzle,
  rainy,
  thunderstorm,
  snowy,
  extremeHeat;

  static WeatherCondition fromWmoCode(int code, {required bool isNight}) {
    // WMO Weather interpretation codes (WW) from Open-Meteo
    switch (code) {
      case 0:
        return isNight
            ? WeatherCondition.clearNight
            : WeatherCondition.clearDay;
      case 1:
      case 2:
        return isNight
            ? WeatherCondition.partlyCloudyNight
            : WeatherCondition.partlyCloudyDay;
      case 3:
        return WeatherCondition.overcast;
      case 45:
      case 48:
        return WeatherCondition.foggy;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return WeatherCondition.drizzle;
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
        return WeatherCondition.rainy;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return WeatherCondition.snowy;
      case 95:
      case 96:
      case 99:
        return WeatherCondition.thunderstorm;
      default:
        return isNight
            ? WeatherCondition.clearNight
            : WeatherCondition.clearDay;
    }
  }

  String get displayName {
    switch (this) {
      case WeatherCondition.clearDay:
        return 'Clear & Sunny';
      case WeatherCondition.clearNight:
        return 'Clear Night';
      case WeatherCondition.partlyCloudyDay:
        return 'Partly Cloudy';
      case WeatherCondition.partlyCloudyNight:
        return 'Passing Clouds';
      case WeatherCondition.overcast:
        return 'Overcast';
      case WeatherCondition.foggy:
        return 'Misty Fog';
      case WeatherCondition.drizzle:
        return 'Gentle Drizzle';
      case WeatherCondition.rainy:
        return 'Rain Showers';
      case WeatherCondition.thunderstorm:
        return 'Thunderstorm';
      case WeatherCondition.snowy:
        return 'Snow Flurries';
      case WeatherCondition.extremeHeat:
        return 'High Heat';
    }
  }
}
