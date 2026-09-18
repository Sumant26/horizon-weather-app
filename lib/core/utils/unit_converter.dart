enum TemperatureUnit { celsius, fahrenheit }

enum SpeedUnit { kmh, mph }

class UnitConverter {
  UnitConverter._();

  static double toFahrenheit(double celsius) => (celsius * 9 / 5) + 32;

  static double toCelsius(double fahrenheit) => (fahrenheit - 32) * 5 / 9;

  static double formatTemperature(double celsius, TemperatureUnit unit) {
    if (unit == TemperatureUnit.fahrenheit) {
      return toFahrenheit(celsius);
    }
    return celsius;
  }

  static String formatTemperatureString(double celsius, TemperatureUnit unit,
      {bool includeSymbol = true}) {
    final value = formatTemperature(celsius, unit).round();
    final symbol = unit == TemperatureUnit.celsius ? '°C' : '°F';
    return includeSymbol ? '$value$symbol' : '$value°';
  }

  static double toMph(double kmh) => kmh * 0.621371;

  static String formatSpeedString(double kmh, SpeedUnit unit) {
    if (unit == SpeedUnit.mph) {
      return '${toMph(kmh).toStringAsFixed(1)} mph';
    }
    return '${kmh.toStringAsFixed(1)} km/h';
  }
}
