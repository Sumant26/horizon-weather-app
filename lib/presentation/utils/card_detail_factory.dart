import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/unit_converter.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/entities/journey_entity.dart';
import '../../domain/entities/weather_entity.dart';
import '../components/card_detail_modal.dart';

class CardDetailFactory {
  /// 1. Precision Meteorology Matrix
  static CardDetailContent createPrecisionMeteorology(
      WeatherEntity weather, TemperatureUnit unit) {
    final m = weather.deepMeteorology;
    final dewPoint =
        (weather.temperature - m.dewPointDepressionC).toStringAsFixed(1);
    return CardDetailContent(
      title: 'Precision Meteorology Matrix',
      category: 'Microclimate Sensors',
      icon: Icons.grain_rounded,
      accentColor: AppColors.softAmber,
      heroValue: '${m.directSolarRadiationWm2.toStringAsFixed(0)} W/m²',
      heroSubtitle:
          'Solar Irradiance Flux with ${m.dewPointDepressionC.toStringAsFixed(1)}°C Dew Depression margin',
      metrics: [
        DetailMetricItem(
          label: 'OPTICAL VISIBILITY',
          value: '${m.visibilityKm.toStringAsFixed(1)} km',
          subtitle: m.visibilityDescription,
          icon: Icons.visibility_outlined,
        ),
        DetailMetricItem(
          label: 'CLOUD CEILING',
          value: '${m.cloudBaseMeters.toStringAsFixed(0)} m',
          subtitle: m.cloudBaseDescription,
          icon: Icons.cloud_outlined,
        ),
        DetailMetricItem(
          label: 'SOLAR IRRADIANCE',
          value: '${m.directSolarRadiationWm2.toStringAsFixed(0)} W/m²',
          subtitle: 'Direct solar flux',
          icon: Icons.wb_sunny_outlined,
        ),
        DetailMetricItem(
          label: 'DEW DEPRESSION',
          value: '${m.dewPointDepressionC.toStringAsFixed(1)}°C',
          subtitle: 'Condensation threshold',
          icon: Icons.opacity_outlined,
        ),
        DetailMetricItem(
          label: 'DEW POINT',
          value: '$dewPoint°C',
          subtitle: 'Moisture saturation',
          icon: Icons.water_drop_outlined,
        ),
        DetailMetricItem(
          label: 'BAROMETRIC ALTITUDE',
          value: '${(m.cloudBaseMeters * 3.28084).toStringAsFixed(0)} ft',
          subtitle: 'Base AGL',
          icon: Icons.height_rounded,
        ),
      ],
      meteorologicalContext:
          'Dew point depression measures the temperature gap before air reaches 100% relative humidity. A margin of ${m.dewPointDepressionC.toStringAsFixed(1)}°C indicates stable air with low immediate fog risk. Solar irradiance flux represents peak incoming radiation penetrating the cloud ceiling layer.',
      practicalTakeaways: [
        'Optimal optical visibility of ${m.visibilityKm.toStringAsFixed(1)} km provides clear long-range scenic vistas.',
        'Cloud base ceiling at ${m.cloudBaseMeters.toStringAsFixed(0)} meters gives ample open airspace overhead.',
        'Low condensation likelihood ensures outdoor gear and vehicles remain free of dew accumulation.',
      ],
      shareableSummary:
          'Horizon Precision Matrix: Visibility ${m.visibilityKm.toStringAsFixed(1)}km, Cloud Ceiling ${m.cloudBaseMeters.toStringAsFixed(0)}m, Solar Flux ${m.directSolarRadiationWm2.toStringAsFixed(0)} W/m².',
    );
  }

  /// 2. Bioclimatic Thermal Comfort Breakdown
  static CardDetailContent createThermalComfort(
      WeatherEntity weather, TemperatureUnit unit) {
    final tc = weather.thermalComfort;
    final ambientStr =
        UnitConverter.formatTemperatureString(tc.ambientTemp, unit);
    final feelsLikeStr =
        UnitConverter.formatTemperatureString(tc.feelsLikeTemp, unit);

    return CardDetailContent(
      title: 'Bioclimatic Thermal Comfort',
      category: 'Perceived Sensation',
      icon: Icons.thermostat_auto_rounded,
      accentColor: AppColors.honeyGold,
      heroValue: feelsLikeStr,
      heroSubtitle: 'Apparent perceived temperature (vs $ambientStr actual)',
      metrics: [
        DetailMetricItem(
          label: 'SOLAR RADIATION',
          value: '+${tc.solarRadiationDelta.toStringAsFixed(1)}°C',
          subtitle: 'Radiant thermal load',
          icon: Icons.wb_sunny_rounded,
        ),
        DetailMetricItem(
          label: 'HUMIDITY VAPOR',
          value: '+${tc.humidityDelta.toStringAsFixed(1)}°C',
          subtitle: 'Latent heat burden',
          icon: Icons.water_drop_rounded,
        ),
        DetailMetricItem(
          label: 'WIND CONVECTION',
          value: '${tc.windChillDelta.toStringAsFixed(1)}°C',
          subtitle: 'Convective skin cooling',
          icon: Icons.air_rounded,
        ),
        DetailMetricItem(
          label: 'CLOTHING CLO',
          value: '${tc.clothingInsulationClo} CLO',
          subtitle: 'Thermal resistance target',
          icon: Icons.checkroom_rounded,
        ),
      ],
      meteorologicalContext:
          'Human thermal comfort balances ambient temperature, skin evaporation resistance, solar absorption, and wind boundary layer displacement. Today solar heating contributes +${tc.solarRadiationDelta.toStringAsFixed(1)}°C, while wind convection pulls ${tc.windChillDelta.abs().toStringAsFixed(1)}°C of heat from exposed surfaces.',
      practicalTakeaways: [
        'Recommended clothing: ${tc.clothingRecommendation}.',
        'Maintain hydration if active outdoors under direct solar exposure.',
        'Thermal comfort equilibrium is best maintained with breathable layered fabrics.',
      ],
      shareableSummary:
          'Thermal Comfort: Feels like $feelsLikeStr (Actual: $ambientStr). CLO: ${tc.clothingInsulationClo} — ${tc.clothingRecommendation}.',
    );
  }

  /// 3. Biophilic Health & Circadian Wellness
  static CardDetailContent createBiophilicHealth(
      WeatherEntity weather, TemperatureUnit unit) {
    final bh = weather.biophilicHealth;
    return CardDetailContent(
      title: 'Biophilic & Circadian Wellness',
      category: 'Human Biometeorology',
      icon: Icons.spa_rounded,
      accentColor: AppColors.warmSage,
      heroValue: '${bh.surfacePressureHpa.toStringAsFixed(0)} hPa',
      heroSubtitle: 'Barometric status: ${bh.headacheRiskStatus}',
      metrics: [
        DetailMetricItem(
          label: 'PRESSURE TREND',
          value: bh.pressureTrend.name.toUpperCase(),
          subtitle: '${bh.surfacePressureHpa.toStringAsFixed(1)} hPa',
          icon: Icons.speed_rounded,
        ),
        DetailMetricItem(
          label: 'VITAMIN D WINDOW',
          value: bh.vitaminDWindow,
          subtitle: 'Circadian optimal',
          icon: Icons.wb_sunny_outlined,
        ),
        DetailMetricItem(
          label: 'BREATHABILITY',
          value: bh.breathabilityScore,
          subtitle: 'Moisture comfort tier',
          icon: Icons.air_rounded,
        ),
        DetailMetricItem(
          label: 'ALLERGEN LOAD',
          value: 'Tree: ${bh.treePollen.name.toUpperCase()}',
          subtitle: 'Grass: ${bh.grassPollen.name.toUpperCase()}',
          icon: Icons.eco_outlined,
        ),
      ],
      meteorologicalContext:
          'Rapid shifts in atmospheric barometric pressure influence sinus cavities and vascular flow. ${bh.headacheAdvice} Natural circadian daylight cycles indicate an optimal vitamin D window at ${bh.vitaminDWindow}.',
      practicalTakeaways: [
        bh.headacheAdvice,
        bh.vitaminDAdvice,
        'Breathability rating is ${bh.breathabilityScore} for prolonged outdoor respiration.',
      ],
      shareableSummary:
          'Biophilic Wellness: Pressure ${bh.surfacePressureHpa.toStringAsFixed(0)} hPa (${bh.headacheRiskStatus}), Vit D Window: ${bh.vitaminDWindow}.',
    );
  }

  /// 4. Daily Briefing Card
  static CardDetailContent createDailyBriefing(
      WeatherEntity weather, TemperatureUnit unit) {
    final b = weather.dailyBriefing;
    return CardDetailContent(
      title: 'Horizon Daily Briefing',
      category: 'Editorial Synthesis',
      icon: Icons.auto_awesome_rounded,
      accentColor: AppColors.honeyGold,
      heroValue: b.period.name.toUpperCase(),
      heroSubtitle:
          'Editorial briefing synthesized for ${weather.location.name}',
      metrics: [
        DetailMetricItem(
          label: 'SOUNDSCAPE',
          value: b.soundscapeName,
          subtitle: b.soundscapeDescription,
          icon: Icons.music_note_rounded,
        ),
        DetailMetricItem(
          label: 'HIGHLIGHT',
          value: b.keyHighlight,
          subtitle: 'Synoptic metric',
          icon: Icons.schedule_rounded,
        ),
        DetailMetricItem(
          label: 'LOCATION NODE',
          value: weather.location.name,
          subtitle:
              '${weather.location.latitude.toStringAsFixed(2)}°, ${weather.location.longitude.toStringAsFixed(2)}°',
          icon: Icons.place_outlined,
        ),
        DetailMetricItem(
          label: 'DATE & TIME',
          value: DateFormatter.formatShortDate(weather.timestamp),
          subtitle: 'Synchronized hourly',
          icon: Icons.event_note_rounded,
        ),
      ],
      meteorologicalContext: b.narrative,
      practicalTakeaways: [
        '${b.greeting}. ${b.narrative}',
        'Soundscape mode "${b.soundscapeName}" is optimized for ambient relaxation.',
        'Review daily highlights: ${b.keyHighlight}.',
      ],
      shareableSummary: '${b.greeting}: ${b.narrative}',
    );
  }

  /// 5. Minute Precipitation Card
  static CardDetailContent createMinutePrecipitation(
      WeatherEntity weather, TemperatureUnit unit) {
    final p = weather.minutePrecipitation;
    final maxIntensity = p.minutePoints.isEmpty
        ? 0.0
        : p.minutePoints
            .map((pt) => pt.intensityMmHr)
            .reduce((a, b) => a > b ? a : b);

    return CardDetailContent(
      title: 'Next-Hour Precipitation Matrix',
      category: 'Nowcasting Radar',
      icon: Icons.water_drop_rounded,
      accentColor: AppColors.twilightCyan,
      heroValue:
          p.hasPrecipitation ? 'Precipitation Active' : 'Dry Next 60 Min',
      heroSubtitle: p.summaryText,
      metrics: [
        DetailMetricItem(
          label: 'ONSET TIMING',
          value:
              p.onsetMinute != null ? '+${p.onsetMinute} min' : 'None active',
          subtitle: 'Radar threshold',
          icon: Icons.timer_outlined,
        ),
        DetailMetricItem(
          label: 'CESSATION TIMING',
          value: p.clearanceMinute != null
              ? '+${p.clearanceMinute} min'
              : 'None active',
          subtitle: 'Tapering off',
          icon: Icons.timelapse_rounded,
        ),
        DetailMetricItem(
          label: 'MAX INTENSITY',
          value: '${maxIntensity.toStringAsFixed(1)} mm/hr',
          subtitle: 'Rate curve peak',
          icon: Icons.grain_rounded,
        ),
        DetailMetricItem(
          label: 'TOTAL 60M ESTIMATE',
          value: '${(maxIntensity * 0.4).toStringAsFixed(1)} mm',
          subtitle: 'Accumulation',
          icon: Icons.opacity_rounded,
        ),
      ],
      meteorologicalContext:
          'High-resolution nowcasting processes Doppler reflectivity radar sweeps every minute to compute ground precipitation probability and droplet intensity curves across a 60-minute sliding window.',
      practicalTakeaways: [
        p.summaryText,
        p.hasPrecipitation
            ? 'Carry an umbrella or water-resistant shell if heading out within the next hour.'
            : 'Clear window for cycling, running, or outdoor chores.',
      ],
      shareableSummary:
          'Horizon 60-Min Rain Radar: ${p.summaryText} (Peak: ${maxIntensity.toStringAsFixed(1)} mm/hr).',
    );
  }

  /// 6. Yesterday Comparison Chart
  static CardDetailContent createYesterdayComparison(
      WeatherEntity weather, TemperatureUnit unit) {
    final diff = (unit == TemperatureUnit.fahrenheit
            ? weather.tempDifferenceYesterday * 9 / 5
            : weather.tempDifferenceYesterday)
        .abs()
        .toStringAsFixed(1);
    final unitSym = unit == TemperatureUnit.celsius ? '°C' : '°F';
    final isWarmer = weather.tempDifferenceYesterday >= 0;
    final trendDescription =
        isWarmer ? 'Tracking warmer overall' : 'Tracking cooler overall';

    return CardDetailContent(
      title: 'Yesterday vs Today Comparison',
      category: 'Microclimate Delta',
      icon: Icons.history_rounded,
      accentColor: isWarmer ? AppColors.honeyGold : AppColors.twilightCyan,
      heroValue: '$diff$unitSym ${isWarmer ? "Warmer" : "Cooler"}',
      heroSubtitle:
          'Hourly delta comparison against yesterday at ${weather.location.name}',
      metrics: [
        DetailMetricItem(
          label: 'CURRENT DELTA',
          value:
              '${weather.tempDifferenceYesterday >= 0 ? "+" : ""}$diff$unitSym',
          subtitle: 'Exact hour variance',
          icon: Icons.compare_arrows_rounded,
        ),
        DetailMetricItem(
          label: 'TREND PROFILE',
          value: trendDescription,
          subtitle: '24-hour arc',
          icon: Icons.trending_up_rounded,
        ),
        DetailMetricItem(
          label: 'TODAY PEAK',
          value: UnitConverter.formatTemperatureString(
              weather.dailyForecast.firstOrNull?.maxTemp ?? weather.temperature,
              unit),
          subtitle: 'Expected high',
          icon: Icons.arrow_upward_rounded,
        ),
        DetailMetricItem(
          label: 'TODAY LOW',
          value: UnitConverter.formatTemperatureString(
              weather.dailyForecast.firstOrNull?.minTemp ?? weather.temperature,
              unit),
          subtitle: 'Overnight minimum',
          icon: Icons.arrow_downward_rounded,
        ),
      ],
      meteorologicalContext:
          'Comparing identical timestamp measurements eliminates circadian bias and provides true air mass displacement context. Today is tracking ${isWarmer ? "warmer" : "cooler"} than yesterday due to changes in solar radiation flux and atmospheric pressure front movement.',
      practicalTakeaways: [
        'Dress according to the $diff$unitSym shift compared to what you wore yesterday.',
        'Expect peak daily variance during late afternoon thermal accumulation.',
      ],
      shareableSummary:
          'Yesterday vs Today in ${weather.location.name}: $diff$unitSym ${isWarmer ? "warmer" : "cooler"} than yesterday at this time.',
    );
  }

  /// 7. Activity Window Selector
  static CardDetailContent createActivityWindow(WeatherEntity weather,
      ActivityWindowResult window, TemperatureUnit unit) {
    return CardDetailContent(
      title: 'Optimal Activity Window',
      category: 'Smart Activity Finder',
      icon: Icons.directions_run_rounded,
      accentColor: AppColors.warmSage,
      heroValue: window.timeRange,
      heroSubtitle:
          'Comfort Score: ${window.comfortScore}/100 for ${window.activity.label}',
      metrics: [
        DetailMetricItem(
          label: 'SELECTED ACTIVITY',
          value: window.activity.label,
          subtitle: 'Optimal comfort profile',
          icon: Icons.sports_score_rounded,
        ),
        DetailMetricItem(
          label: 'COMFORT INDEX',
          value: '${window.comfortScore} / 100',
          subtitle: 'Calculated metric score',
          icon: Icons.speed_rounded,
        ),
        DetailMetricItem(
          label: 'WINDOW TIMEFRAME',
          value: window.timeRange,
          subtitle: 'Peak microclimate corridor',
          icon: Icons.schedule_rounded,
        ),
        DetailMetricItem(
          label: 'AIR TEMPERATURE',
          value:
              UnitConverter.formatTemperatureString(weather.temperature, unit),
          subtitle: 'Current reading',
          icon: Icons.thermostat_rounded,
        ),
      ],
      meteorologicalContext: window.reasoning,
      practicalTakeaways: [
        'Plan your ${window.activity.label} session between ${window.timeRange}.',
        'Comfort rating of ${window.comfortScore}/100 accounts for UV exposure, wind cooling, and precipitation likelihood.',
      ],
      shareableSummary:
          'Optimal Window for ${window.activity.label}: ${window.timeRange} (Comfort Score: ${window.comfortScore}/100).',
    );
  }

  /// 8. Weather Radar & Wind Map Card
  static CardDetailContent createWeatherRadar(
      WeatherEntity weather, SpeedUnit speedUnit) {
    final ws = weather.windStream;
    final speedFormatted =
        UnitConverter.formatSpeedString(ws.speedKmh, speedUnit);

    return CardDetailContent(
      title: 'Live Radar & Wind Vector Stream',
      category: 'Atmospheric Dynamics',
      icon: Icons.radar_rounded,
      accentColor: AppColors.twilightCyan,
      heroValue: '$speedFormatted ${ws.cardinalBearing}',
      heroSubtitle:
          'Beaufort Force: ${ws.beaufortScale} (${ws.gustKmh.toStringAsFixed(1)} km/h gusts)',
      metrics: [
        DetailMetricItem(
          label: 'WIND SPEED',
          value: speedFormatted,
          subtitle: '${ws.speedKmh.toStringAsFixed(1)} km/h',
          icon: Icons.air_rounded,
        ),
        DetailMetricItem(
          label: 'PEAK GUSTS',
          value: UnitConverter.formatSpeedString(ws.gustKmh, speedUnit),
          subtitle: 'Instantaneous peak',
          icon: Icons.storm_rounded,
        ),
        DetailMetricItem(
          label: 'COMPASS BEARING',
          value:
              '${ws.directionDegrees.toStringAsFixed(0)}° (${ws.cardinalBearing})',
          subtitle: 'Azimuth vector',
          icon: Icons.explore_outlined,
        ),
        DetailMetricItem(
          label: 'BEAUFORT SCALE',
          value: ws.beaufortScale,
          subtitle: 'Surface impact rating',
          icon: Icons.flag_outlined,
        ),
      ],
      meteorologicalContext:
          'Atmospheric wind stream vectors are driven by horizontal pressure gradients. Wind traveling from ${ws.cardinalBearing} at $speedFormatted creates dynamic convective surface cooling and disperses localized air particulates.',
      practicalTakeaways: [
        'Surface wind is currently classified as "${ws.beaufortScale}".',
        'Wind gust margins up to ${ws.gustKmh.toStringAsFixed(0)} km/h may affect open-air cycling and canopy umbrellas.',
      ],
      shareableSummary:
          'Radar & Wind Stream: $speedFormatted from ${ws.cardinalBearing} (${ws.beaufortScale}). Gusts: ${ws.gustKmh.toStringAsFixed(0)} km/h.',
    );
  }

  /// 9. 7-Day Spectrum Outlook
  static CardDetailContent createSevenDayForecast(
      WeatherEntity weather, TemperatureUnit unit) {
    return CardDetailContent(
      title: '7-Day Synoptic Spectrum',
      category: 'Extended Outlook',
      icon: Icons.calendar_view_week_rounded,
      accentColor: AppColors.softAmber,
      heroValue: '7-Day Outlook',
      heroSubtitle:
          'Synoptic forecast models across the week for ${weather.location.name}',
      metrics: weather.dailyForecast.take(4).map((d) {
        final high = UnitConverter.formatTemperatureString(d.maxTemp, unit);
        final low = UnitConverter.formatTemperatureString(d.minTemp, unit);
        return DetailMetricItem(
          label: DateFormatter.formatDayOfWeek(d.date),
          value: '$high / $low',
          subtitle: d.condition.displayName,
          icon: Icons.wb_sunny_outlined,
        );
      }).toList(),
      meteorologicalContext:
          'Medium-range synoptic ensemble forecasting calculates 7-day temperature envelopes and precipitation bands by simulating continuous atmospheric isobaric shifts.',
      practicalTakeaways: [
        'Review the 7-day temperature gradient to plan weekend outdoor commitments.',
        'Track shifting cloud and precipitation probabilities across upcoming days.',
      ],
      shareableSummary:
          '7-Day Weather Outlook for ${weather.location.name}: Weekly highs range between ${UnitConverter.formatTemperatureString(weather.dailyForecast.map((e) => e.maxTemp).reduce((a, b) => a > b ? a : b), unit)} and ${UnitConverter.formatTemperatureString(weather.dailyForecast.map((e) => e.minTemp).reduce((a, b) => a < b ? a : b), unit)}.',
    );
  }

  /// 10. Celestial Sun & Moon Arc
  static CardDetailContent createCelestialPath(
      WeatherEntity weather, TemperatureUnit unit) {
    final a = weather.astronomy;
    final sunriseStr = DateFormatter.format24Hour(a.sunrise);
    final sunsetStr = DateFormatter.format24Hour(a.sunset);
    final dayLengthHours =
        (a.sunset.difference(a.sunrise).inMinutes / 60.0).toStringAsFixed(1);
    final solarNoon = DateFormatter.format24Hour(a.sunrise
        .add(Duration(minutes: a.sunset.difference(a.sunrise).inMinutes ~/ 2)));

    return CardDetailContent(
      title: 'Celestial Astronomical Path',
      category: 'Solar & Lunar Ephemeris',
      icon: Icons.wb_twilight_rounded,
      accentColor: AppColors.honeyGold,
      heroValue: a.isDaylight ? 'Daylight Phase' : 'Nocturnal Phase',
      heroSubtitle: 'Sunrise: $sunriseStr • Sunset: $sunsetStr',
      metrics: [
        DetailMetricItem(
          label: 'SUNRISE',
          value: sunriseStr,
          subtitle: 'Dawn horizon',
          icon: Icons.wb_sunny_outlined,
        ),
        DetailMetricItem(
          label: 'SUNSET',
          value: sunsetStr,
          subtitle: 'Dusk horizon',
          icon: Icons.nightlight_round_outlined,
        ),
        DetailMetricItem(
          label: 'DAYLIGHT LENGTH',
          value: '$dayLengthHours Hours',
          subtitle: 'Solar photoperiod',
          icon: Icons.hourglass_bottom_rounded,
        ),
        DetailMetricItem(
          label: 'SOLAR NOON',
          value: solarNoon,
          subtitle: 'Peak zenith angle',
          icon: Icons.wb_sunny_rounded,
        ),
      ],
      meteorologicalContext:
          'Solar altitude and astronomical azimuth determine natural photoperiod length ($dayLengthHours hours). Golden hour photography and circadian melatonin regulation sync directly with dawn and dusk horizons.',
      practicalTakeaways: [
        'Golden Hour occurs 45 minutes after sunrise and 45 minutes before sunset.',
        if (weather.nightSkyClarity != null) weather.nightSkyClarity!,
      ],
      shareableSummary:
          'Celestial Ephemeris: Sunrise $sunriseStr, Sunset $sunsetStr (${dayLengthHours}h daylight).',
    );
  }

  /// 11. Commute & Journey Simulator
  static CardDetailContent createJourneySimulator(
      WeatherEntity weather, TemperatureUnit unit, SpeedUnit speedUnit) {
    final j = weather.journey;
    return CardDetailContent(
      title: 'Commute & Travel Weather Simulator',
      category: 'Route Corridor',
      icon: Icons.route_rounded,
      accentColor: AppColors.twilightCyan,
      heroValue: '${j.originNode} ➔ ${j.destinationNode}',
      heroSubtitle:
          '${j.estimatedDuration.inMinutes} min travel • Safety: ${j.safetyScore}/100 (${j.safetyTier.name.toUpperCase()})',
      metrics: [
        DetailMetricItem(
          label: 'SAFETY SCORE',
          value: '${j.safetyScore}/100',
          subtitle: j.safetyTier.name.toUpperCase(),
          icon: Icons.verified_user_outlined,
        ),
        DetailMetricItem(
          label: 'TRAVEL TIME',
          value: '${j.estimatedDuration.inMinutes} min',
          subtitle: 'Estimated duration',
          icon: Icons.schedule_rounded,
        ),
        DetailMetricItem(
          label: 'SAFETY SUMMARY',
          value: j.safetyTier == TravelSafetyTier.optimal
              ? 'Optimal'
              : j.safetyTier == TravelSafetyTier.cautious
                  ? 'Caution'
                  : 'Severe',
          subtitle: j.safetySummary,
          icon: Icons.shield_outlined,
        ),
        DetailMetricItem(
          label: 'WAYPOINTS',
          value: '${j.waypoints.length} checkpoints',
          subtitle: 'Monitored corridor',
          icon: Icons.straighten_rounded,
        ),
      ],
      meteorologicalContext: j.safetySummary,
      practicalTakeaways: [
        j.recommendedAction,
        'Route weather corridor between ${j.originNode} and ${j.destinationNode} is monitored across ${j.waypoints.length} checkpoints.',
      ],
      shareableSummary:
          'Commute Weather: ${j.originNode} ➔ ${j.destinationNode} (${j.safetyScore}/100 score). ${j.safetySummary}',
    );
  }

  /// 12. Air Quality & UV Index
  static CardDetailContent createAirQuality(
      WeatherEntity weather, TemperatureUnit unit) {
    final aq = weather.airQuality;
    return CardDetailContent(
      title: 'Air Quality & Solar UV Index',
      category: 'Environmental Health',
      icon: Icons.air_rounded,
      accentColor: AppColors.warmSage,
      heroValue: 'AQI ${aq.aqi} (${aq.status})',
      heroSubtitle:
          'UV Index: ${weather.uvIndex.toStringAsFixed(1)} (${weather.uvIndex >= 6 ? "High" : weather.uvIndex >= 3 ? "Moderate" : "Low"})',
      metrics: [
        DetailMetricItem(
          label: 'PM 2.5 PARTICULATE',
          value: '${aq.pm2_5.toStringAsFixed(1)} µg/m³',
          subtitle: 'Fine inhalable matter',
          icon: Icons.grain_rounded,
        ),
        DetailMetricItem(
          label: 'PM 10 COARSE',
          value: '${aq.pm10.toStringAsFixed(1)} µg/m³',
          subtitle: 'Dust & aerosol',
          icon: Icons.blur_on_rounded,
        ),
        DetailMetricItem(
          label: 'OZONE (O₃)',
          value: aq.ozone != null
              ? '${aq.ozone!.toStringAsFixed(1)} µg/m³'
              : 'N/A',
          subtitle: 'Ground-level oxidant',
          icon: Icons.cloud_queue_rounded,
        ),
        DetailMetricItem(
          label: 'SOLAR UV INDEX',
          value: weather.uvIndex.toStringAsFixed(1),
          subtitle:
              weather.uvIndex >= 6 ? 'Sun protection required' : 'Low risk',
          icon: Icons.wb_sunny_rounded,
        ),
      ],
      meteorologicalContext:
          'Air Quality Index synthesizes PM2.5, PM10, and Ozone concentrations. Current levels (${aq.status}) provide ${aq.recommendation}. Solar UV radiation of ${weather.uvIndex.toStringAsFixed(1)} measures biological skin exposure risk.',
      practicalTakeaways: [
        aq.recommendation,
        if (weather.uvIndex >= 6)
          'Apply broad-spectrum sunscreen and wear UV-rated sunglasses outdoors.'
        else
          'UV levels are mild; minimal sun protection needed for short exposures.',
      ],
      shareableSummary:
          'Environmental Index in ${weather.location.name}: AQI ${aq.aqi} (${aq.status}), UV Index: ${weather.uvIndex.toStringAsFixed(1)}.',
    );
  }

  /// 13. Gear & Wardrobe Packing Checklist
  static CardDetailContent createGearChecklist(
      WeatherEntity weather, List<String> packedItems, TemperatureUnit unit) {
    return CardDetailContent(
      title: 'Minimalist Wardrobe & Gear',
      category: 'Preparation Checklist',
      icon: Icons.backpack_outlined,
      accentColor: AppColors.softLinen,
      heroValue:
          '${packedItems.length}/${weather.recommendedGear.length} Prepared',
      heroSubtitle:
          'Dynamically computed based on real-time temperature, rain probability & UV',
      metrics: weather.recommendedGear.map((item) {
        final isPacked = packedItems.contains(item);
        return DetailMetricItem(
          label: item.toUpperCase(),
          value: isPacked ? 'PACKED ✓' : 'RECOMMENDED',
          subtitle: isPacked ? 'Ready to go' : 'Tap to mark',
          icon: Icons.checkroom_rounded,
        );
      }).toList(),
      meteorologicalContext:
          'Gear recommendations dynamically adapt to ambient temperature (${UnitConverter.formatTemperatureString(weather.temperature, unit)}), current conditions (${weather.condition.displayName}), and solar UV load (${weather.uvIndex.toStringAsFixed(1)}).',
      practicalTakeaways: [
        'Recommended items: ${weather.recommendedGear.join(", ")}.',
        'Keep essential items packed for optimal outdoor comfort.',
      ],
      shareableSummary:
          'Horizon Gear Checklist for ${weather.location.name}: ${weather.recommendedGear.join(", ")}.',
    );
  }

  /// 14. Hourly 24-Hour Forecast
  static CardDetailContent createHourlyForecast(
      WeatherEntity weather, TemperatureUnit unit) {
    return CardDetailContent(
      title: '24-Hour Microclimate Strip',
      category: 'Hourly Forecast',
      icon: Icons.access_time_rounded,
      accentColor: AppColors.honeyGold,
      heroValue: '24-Hour Progression',
      heroSubtitle:
          'Scrubbable hourly precipitation, temperature & barometric trajectory',
      metrics: weather.hourlyForecast.take(6).map((h) {
        final tempStr =
            UnitConverter.formatTemperatureString(h.temperature, unit);
        return DetailMetricItem(
          label: DateFormatter.formatHour(h.time),
          value: tempStr,
          subtitle: '${h.precipitationProbability.toStringAsFixed(0)}% Rain',
          icon: Icons.schedule_rounded,
        );
      }).toList(),
      meteorologicalContext:
          'Continuous hourly forecasts calculate microclimate atmospheric changes across the entire diurnal cycle.',
      practicalTakeaways: [
        'Check the diurnal curve to identify optimal times for outdoor travel.',
        'Notice hourly precipitation probabilities before scheduling errands.',
      ],
      shareableSummary:
          '24-Hour Weather Forecast for ${weather.location.name}: Hourly progression tracking smoothly with current temp ${UnitConverter.formatTemperatureString(weather.temperature, unit)}.',
    );
  }
}
