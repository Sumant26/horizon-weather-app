import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/core/utils/unit_converter.dart';

void main() {
  group('UnitConverter Tests', () {
    test('converts Celsius to Fahrenheit correctly', () {
      expect(UnitConverter.toFahrenheit(0), equals(32.0));
      expect(UnitConverter.toFahrenheit(100), equals(212.0));
      expect(UnitConverter.toFahrenheit(25), equals(77.0));
    });

    test('converts Fahrenheit to Celsius correctly', () {
      expect(UnitConverter.toCelsius(32), equals(0.0));
      expect(UnitConverter.toCelsius(212), equals(100.0));
      expect(UnitConverter.toCelsius(77), equals(25.0));
    });

    test('formatTemperatureString formats accurately', () {
      expect(
          UnitConverter.formatTemperatureString(22.4, TemperatureUnit.celsius),
          equals('22°C'));
      expect(
          UnitConverter.formatTemperatureString(
              22.4, TemperatureUnit.fahrenheit),
          equals('72°F'));
      expect(
          UnitConverter.formatTemperatureString(22.4, TemperatureUnit.celsius,
              includeSymbol: false),
          equals('22°'));
    });

    test('converts km/h to mph correctly', () {
      expect(UnitConverter.toMph(10), closeTo(6.21, 0.01));
      expect(UnitConverter.formatSpeedString(15.0, SpeedUnit.kmh),
          equals('15.0 km/h'));
      expect(UnitConverter.formatSpeedString(15.0, SpeedUnit.mph),
          equals('9.3 mph'));
    });
  });
}
