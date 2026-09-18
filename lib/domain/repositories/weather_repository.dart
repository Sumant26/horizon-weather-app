import '../entities/air_quality_entity.dart';
import '../entities/location_entity.dart';
import '../entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<WeatherEntity> getWeatherForecast({
    required LocationEntity location,
    bool forceRefresh = false,
  });

  Future<AirQualityEntity> getAirQuality({
    required double latitude,
    required double longitude,
  });

  Future<List<LocationEntity>> searchLocations(String query);

  Future<LocationEntity?> detectCurrentLocation();
}
