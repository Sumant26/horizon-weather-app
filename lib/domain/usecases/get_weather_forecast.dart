import '../entities/location_entity.dart';
import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';

class GetWeatherForecast {
  final WeatherRepository _repository;

  const GetWeatherForecast(this._repository);

  Future<WeatherEntity> call({
    required LocationEntity location,
    bool forceRefresh = false,
  }) {
    return _repository.getWeatherForecast(
      location: location,
      forceRefresh: forceRefresh,
    );
  }
}
