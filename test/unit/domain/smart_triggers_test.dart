import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/domain/entities/biophilic_health_entity.dart';
import 'package:horizon/domain/entities/minute_precipitation_entity.dart';
import 'package:horizon/domain/entities/smart_trigger_entity.dart';
import 'package:horizon/domain/entities/weather_condition.dart';

void main() {
  group('SmartTriggerEntity Tests', () {
    test('triggers rain onset alert when rain begins within 30 minutes', () {
      final triggers = SmartTriggerEntity.evaluate(
        minutePrecipitation: const MinutePrecipitationEntity(
          minutePoints: [
            MinuteRainPoint(minuteOffset: 0, intensityMmHr: 0.0),
            MinuteRainPoint(minuteOffset: 18, intensityMmHr: 1.5),
          ],
          hasPrecipitation: true,
          onsetMinute: 18,
          clearanceMinute: 55,
          summaryText: 'Rain starting in 18 min',
        ),
        biophilicHealth: const BiophilicHealthEntity(
          surfacePressureHpa: 1012.0,
          pressureDelta12h: 0.2,
          pressureTrend: PressureTrend.steady,
          headacheRiskStatus: 'Low',
          headacheAdvice: 'Nominal',
          treePollen: PollenLevel.low,
          grassPollen: PollenLevel.low,
          weedPollen: PollenLevel.low,
          overallAllergenAdvice: 'Pristine air',
          vitaminDWindow: '10 AM - 2 PM',
          vitaminDAdvice: 'Optimal synthesis',
          dewPoint: 14.0,
          breathabilityScore: 'Optimal',
        ),
        uvIndex: 4.0,
        condition: WeatherCondition.partlyCloudyDay,
      );

      final rainTrigger = triggers.triggers.firstWhere(
        (t) => t.category == TriggerCategory.rainOnset,
      );
      expect(rainTrigger.isTriggered, isTrue);
      expect(rainTrigger.message, contains('18 min'));
    });

    test('triggers rapid barometric drop migraine warning', () {
      final triggers = SmartTriggerEntity.evaluate(
        minutePrecipitation: const MinutePrecipitationEntity(
          minutePoints: [],
          hasPrecipitation: false,
          summaryText: 'No rain',
        ),
        biophilicHealth: const BiophilicHealthEntity(
          surfacePressureHpa: 998.0,
          pressureDelta12h: -3.5,
          pressureTrend: PressureTrend.droppingFast,
          headacheRiskStatus: 'High',
          headacheAdvice: 'Elevated migraine probability',
          treePollen: PollenLevel.low,
          grassPollen: PollenLevel.low,
          weedPollen: PollenLevel.low,
          overallAllergenAdvice: 'Pristine air',
          vitaminDWindow: '10 AM - 2 PM',
          vitaminDAdvice: 'Optimal synthesis',
          dewPoint: 14.0,
          breathabilityScore: 'Fair',
        ),
        uvIndex: 4.0,
        condition: WeatherCondition.overcast,
      );

      final pressureTrigger = triggers.triggers.firstWhere(
        (t) => t.category == TriggerCategory.barometricDrop,
      );
      expect(pressureTrigger.isTriggered, isTrue);
      expect(pressureTrigger.message, contains('headaches & migraines'));
    });
  });
}
