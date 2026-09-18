import '../entities/air_quality_entity.dart';
import '../repositories/weather_repository.dart';

class GetAirQuality {
  final WeatherRepository _repository;

  const GetAirQuality(this._repository);

  Future<AirQualityEntity> call({
    required double latitude,
    required double longitude,
  }) {
    return _repository.getAirQuality(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
