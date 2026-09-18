import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/entities/air_quality_entity.dart';
import '../../domain/entities/astronomy_entity.dart';
import '../../domain/entities/biophilic_health_entity.dart';
import '../../domain/entities/daily_forecast_entity.dart';
import '../../domain/entities/deep_meteorology_entity.dart';
import '../../domain/entities/hourly_forecast_entity.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/entities/minute_precipitation_entity.dart';
import '../../domain/entities/weather_alert_entity.dart';
import '../../domain/entities/weather_condition.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/entities/wind_stream_entity.dart';
import '../../domain/entities/yesterday_comparison_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/local_weather_datasource.dart';
import '../datasources/remote_weather_datasource.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final RemoteWeatherDatasource _remoteDatasource;
  final LocalWeatherDatasource _localDatasource;

  WeatherRepositoryImpl({
    RemoteWeatherDatasource? remoteDatasource,
    LocalWeatherDatasource? localDatasource,
  })  : _remoteDatasource = remoteDatasource ?? RemoteWeatherDatasourceImpl(),
        _localDatasource = localDatasource ?? LocalWeatherDatasourceImpl();

  @override
  Future<WeatherEntity> getWeatherForecast({
    required LocationEntity location,
    bool forceRefresh = false,
  }) async {
    final cacheKey =
        '${location.latitude.toStringAsFixed(2)}_${location.longitude.toStringAsFixed(2)}';

    // 1. Check local cache first if not forced refresh
    if (!forceRefresh) {
      final cachedJson =
          await _localDatasource.getCachedForecast(key: cacheKey);
      if (cachedJson != null) {
        final isStale = cachedJson['is_stale'] == true;
        if (!isStale) {
          try {
            AppLogger.info(
                'Serving fresh cached forecast for ${location.name}');
            return _parseWeatherEntityFromJson(cachedJson, location,
                isFromCache: true);
          } catch (e) {
            AppLogger.warning('Failed to parse cached forecast: $e');
          }
        }
      }
    }

    // 2. Fetch fresh network data from Open-Meteo
    try {
      final forecastJson = await _remoteDatasource.getForecast(
        latitude: location.latitude,
        longitude: location.longitude,
      );

      // Async fetch historical yesterday comparison & air quality in parallel
      final now = DateTime.now();
      final yesterdayFuture = _remoteDatasource.getYesterdayTemperature(
        latitude: location.latitude,
        longitude: location.longitude,
        now: now,
      );
      final aqiFuture = _remoteDatasource.getAirQuality(
        latitude: location.latitude,
        longitude: location.longitude,
      );

      final yesterdayTemp = await yesterdayFuture;
      Map<String, dynamic>? aqiJson;
      try {
        aqiJson = await aqiFuture;
      } catch (e) {
        AppLogger.warning('AQI fetch failed, using fallback: $e');
      }

      final combined = Map<String, dynamic>.from(forecastJson);
      if (yesterdayTemp != null) combined['yesterday_temp'] = yesterdayTemp;
      if (aqiJson != null) combined['air_quality'] = aqiJson;

      // Save to local cache
      await _localDatasource.cacheForecast(key: cacheKey, data: combined);

      return _parseWeatherEntityFromJson(combined, location,
          isFromCache: false);
    } on NetworkException catch (e) {
      AppLogger.warning('Network error, attempting stale cache fallback: $e');
      final fallbackCache = await _localDatasource.getCachedForecast(
        key: cacheKey,
        ttl: const Duration(days: 7), // Allow older cache when offline
      );
      if (fallbackCache != null) {
        return _parseWeatherEntityFromJson(fallbackCache, location,
            isFromCache: true);
      }
      throw const NetworkFailure();
    } on ServerException catch (e) {
      AppLogger.error('Server error: ${e.message}');
      throw ServerFailure(e.message);
    } catch (e, st) {
      AppLogger.error('Unexpected weather fetch error: $e', e, st);
      throw const ServerFailure();
    }
  }

  @override
  Future<AirQualityEntity> getAirQuality({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final json = await _remoteDatasource.getAirQuality(
          latitude: latitude, longitude: longitude);
      final current = json['current'] as Map<String, dynamic>? ?? {};
      final pm2_5 = (current['pm2_5'] as num?)?.toDouble() ?? 12.0;
      final pm10 = (current['pm10'] as num?)?.toDouble() ?? 24.0;
      final aqi = (current['european_aqi'] as num?)?.toInt() ?? 28;
      final ozone = (current['ozone'] as num?)?.toDouble();

      return AirQualityEntity.fromValues(
        pm2_5: pm2_5,
        pm10: pm10,
        aqi: aqi,
        ozone: ozone,
      );
    } catch (e) {
      return AirQualityEntity.fromValues(
        pm2_5: 14.0,
        pm10: 25.0,
        aqi: 32,
      );
    }
  }

  @override
  Future<List<LocationEntity>> searchLocations(String query) async {
    try {
      final results = await _remoteDatasource.searchLocations(query);
      return results.map((item) {
        return LocationEntity(
          name: item['name'] as String? ?? 'Unknown',
          country: item['country'] as String?,
          admin1: item['admin1'] as String?,
          latitude: (item['latitude'] as num?)?.toDouble() ?? 0.0,
          longitude: (item['longitude'] as num?)?.toDouble() ?? 0.0,
        );
      }).toList();
    } catch (e) {
      AppLogger.warning('Location search failure: $e');
      throw const LocationFailure();
    }
  }

  @override
  Future<LocationEntity?> detectCurrentLocation() async {
    try {
      final data = await _remoteDatasource.detectCurrentLocation();
      if (data != null) {
        return LocationEntity(
          name: data['name'] as String? ?? 'Current Location',
          admin1: data['admin1'] as String?,
          country: data['country'] as String?,
          latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
          longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
          isCurrentLocation: true,
        );
      }
    } catch (e) {
      AppLogger.warning('Failed to detect current location in repository: $e');
    }
    return null;
  }

  WeatherEntity _parseWeatherEntityFromJson(
    Map<String, dynamic> json,
    LocationEntity location, {
    required bool isFromCache,
  }) {
    final current = json['current'] as Map<String, dynamic>? ?? {};
    final hourly = json['hourly'] as Map<String, dynamic>? ?? {};
    final daily = json['daily'] as Map<String, dynamic>? ?? {};
    final now = DateTime.now();

    final temp = (current['temperature_2m'] as num?)?.toDouble() ?? 22.0;
    final feelsLike =
        (current['apparent_temperature'] as num?)?.toDouble() ?? temp;
    final humidity =
        (current['relative_humidity_2m'] as num?)?.toDouble() ?? 50.0;
    final uvIndex = (current['uv_index'] as num?)?.toDouble() ?? 4.0;
    final cloudCover =
        ((current['cloud_cover'] as num?)?.toDouble() ?? 20.0) / 100.0;
    final windSpeed = (current['wind_speed_10m'] as num?)?.toDouble() ?? 8.5;
    final windDirection =
        (current['wind_direction_10m'] as num?)?.toDouble() ?? 180.0;
    final windGusts = (current['wind_gusts_10m'] as num?)?.toDouble();
    final surfacePressure =
        (current['surface_pressure'] as num?)?.toDouble() ?? 1013.2;
    final weatherCode = (current['weather_code'] as num?)?.toInt() ?? 0;

    // Construct WindStreamEntity
    final windStream = WindStreamEntity.fromValues(
      speedKmh: windSpeed,
      gustKmh: windGusts,
      directionDegrees: windDirection,
    );

    // Construct BiophilicHealthEntity
    final biophilicHealth = BiophilicHealthEntity.evaluate(
      surfacePressureHpa: surfacePressure,
      pressureDelta12h: -1.2, // normal baseline
      uvIndex: uvIndex,
      humidity: humidity,
      temperature: temp,
    );

    // Determine day or night
    final isNight = now.hour < 6 || now.hour >= 19;
    final condition =
        WeatherCondition.fromWmoCode(weatherCode, isNight: isNight);

    // Calculate temp Difference from Yesterday
    double tempDifference = -1.5; // reasonable fallback
    if (json.containsKey('yesterday_temp')) {
      final yTemp = (json['yesterday_temp'] as num?)?.toDouble();
      if (yTemp != null) {
        tempDifference = temp - yTemp;
      }
    }

    // Parse Astronomy
    DateTime sunrise = DateTime(now.year, now.month, now.day, 6, 15);
    DateTime sunset = DateTime(now.year, now.month, now.day, 18, 30);
    final sunrises = daily['sunrise'] as List<dynamic>?;
    final sunsets = daily['sunset'] as List<dynamic>?;
    if (sunrises != null &&
        sunrises.isNotEmpty &&
        sunsets != null &&
        sunsets.isNotEmpty) {
      try {
        sunrise = DateTime.parse(sunrises.first.toString());
        sunset = DateTime.parse(sunsets.first.toString());
      } catch (_) {}
    }
    final astronomy =
        AstronomyEntity.fromTimes(sunrise: sunrise, sunset: sunset, now: now);

    // Parse Air Quality
    AirQualityEntity aqiEntity;
    final aqiCurrent = (json['air_quality']
        as Map<String, dynamic>?)?['current'] as Map<String, dynamic>?;
    if (aqiCurrent != null) {
      aqiEntity = AirQualityEntity.fromValues(
        pm2_5: (aqiCurrent['pm2_5'] as num?)?.toDouble() ?? 15.0,
        pm10: (aqiCurrent['pm10'] as num?)?.toDouble() ?? 28.0,
        aqi: (aqiCurrent['european_aqi'] as num?)?.toInt() ?? 32,
        ozone: (aqiCurrent['ozone'] as num?)?.toDouble(),
      );
    } else {
      aqiEntity = AirQualityEntity.fromValues(pm2_5: 14.0, pm10: 25.0, aqi: 30);
    }

    // Parse 24-hour Hourly Forecast
    final List<HourlyForecastEntity> hourlyList = [];
    final times = hourly['time'] as List<dynamic>?;
    final temps = hourly['temperature_2m'] as List<dynamic>?;
    final precipProbs = hourly['precipitation_probability'] as List<dynamic>?;
    final codes = hourly['weather_code'] as List<dynamic>?;
    final uvs = hourly['uv_index'] as List<dynamic>?;

    if (times != null && temps != null) {
      for (int i = 0; i < times.length && i < 24; i++) {
        try {
          final t = DateTime.parse(times[i].toString());
          final hIsNight = t.hour < 6 || t.hour >= 19;
          final code = (codes != null && i < codes.length)
              ? (codes[i] as num).toInt()
              : 0;
          hourlyList.add(HourlyForecastEntity(
            time: t,
            temperature: (temps[i] as num).toDouble(),
            precipitationProbability:
                (precipProbs != null && i < precipProbs.length)
                    ? (precipProbs[i] as num).toInt()
                    : 0,
            condition: WeatherCondition.fromWmoCode(code, isNight: hIsNight),
            uvIndex: (uvs != null && i < uvs.length)
                ? (uvs[i] as num).toDouble()
                : 0.0,
          ));
        } catch (_) {}
      }
    }

    // Parse 7-day Daily Forecast
    final List<DailyForecastEntity> dailyList = [];
    final dDates = daily['time'] as List<dynamic>?;
    final dMaxs = daily['temperature_2m_max'] as List<dynamic>?;
    final dMins = daily['temperature_2m_min'] as List<dynamic>?;
    final dCodes = daily['weather_code'] as List<dynamic>?;
    final dSunrises = daily['sunrise'] as List<dynamic>?;
    final dSunsets = daily['sunset'] as List<dynamic>?;
    final dUvs = daily['uv_index_max'] as List<dynamic>?;

    if (dDates != null && dMaxs != null && dMins != null) {
      for (int i = 0; i < dDates.length && i < 7; i++) {
        try {
          final d = DateTime.parse(dDates[i].toString());
          final code = (dCodes != null && i < dCodes.length)
              ? (dCodes[i] as num).toInt()
              : 0;
          final sRise = (dSunrises != null && i < dSunrises.length)
              ? DateTime.parse(dSunrises[i].toString())
              : sunrise;
          final sSet = (dSunsets != null && i < dSunsets.length)
              ? DateTime.parse(dSunsets[i].toString())
              : sunset;
          dailyList.add(DailyForecastEntity(
            date: d,
            maxTemp: (dMaxs[i] as num).toDouble(),
            minTemp: (dMins[i] as num).toDouble(),
            condition: WeatherCondition.fromWmoCode(code, isNight: false),
            sunrise: sRise,
            sunset: sSet,
            maxUvIndex: (dUvs != null && i < dUvs.length)
                ? (dUvs[i] as num).toDouble()
                : 5.0,
          ));
        } catch (_) {}
      }
    }

    // Parse Minute-by-Minute Rain Matrix
    final hourlyPrecipitation =
        (current['precipitation'] as num?)?.toDouble() ?? 0.0;
    final isRaining = condition == WeatherCondition.rainy ||
        condition == WeatherCondition.drizzle;
    final minutePrecip = MinutePrecipitationEntity.generate(
      isCurrentlyRaining: isRaining,
      precipitationProbability:
          hourlyList.isNotEmpty ? hourlyList.first.precipitationProbability : 0,
      hourlyPrecipitationMm: hourlyPrecipitation,
      now: now,
    );

    // Parse Yesterday vs Today 24-Hour Comparison
    final todayTemps = hourlyList.map((h) => h.temperature).toList();
    final yesterdayComp = YesterdayComparisonEntity.fromHourlyData(
      todayTemps: todayTemps,
      baseDifference: tempDifference,
    );

    // Parse Weather Alerts
    final alerts = WeatherAlertEntity.evaluate(
      temperature: temp,
      windSpeedKmh: windSpeed,
      gustKmh: windGusts,
      uvIndex: uvIndex,
      condition: condition,
      tempDifferenceYesterday: tempDifference,
    );

    // Parse Deep Meteorology
    final rawVisibility =
        (current['visibility'] as num?)?.toDouble() ?? 10000.0;
    final solarRadiation =
        (current['direct_radiation'] as num?)?.toDouble() ?? (uvIndex * 85.0);
    final cloudCeiling =
        (cloudCover > 0.7) ? 800.0 : ((cloudCover > 0.3) ? 1800.0 : 3500.0);
    final dewDepression = (temp - (temp - ((100 - humidity) / 5))).abs();

    final deepMeteorology = DeepMeteorologyEntity(
      visibilityKm: rawVisibility / 1000.0,
      cloudBaseMeters: cloudCeiling,
      directSolarRadiationWm2: solarRadiation,
      dewPointDepressionC: dewDepression,
    );

    return WeatherEntity(
      temperature: temp,
      feelsLike: feelsLike,
      tempDifferenceYesterday: tempDifference,
      humidity: humidity,
      uvIndex: uvIndex,
      cloudCover: cloudCover,
      windSpeed: windSpeed,
      condition: condition,
      timestamp: now,
      location: location,
      astronomy: astronomy,
      airQuality: aqiEntity,
      windStream: windStream,
      biophilicHealth: biophilicHealth,
      minutePrecipitation: minutePrecip,
      yesterdayComparison: yesterdayComp,
      weatherAlerts: alerts,
      deepMeteorology: deepMeteorology,
      hourlyForecast: hourlyList,
      dailyForecast: dailyList,
      isFromCache: isFromCache,
    );
  }
}
