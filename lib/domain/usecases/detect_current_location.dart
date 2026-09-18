import '../entities/location_entity.dart';
import '../repositories/weather_repository.dart';

class DetectCurrentLocation {
  final WeatherRepository _repository;

  const DetectCurrentLocation(this._repository);

  Future<LocationEntity?> call() {
    return _repository.detectCurrentLocation();
  }
}
