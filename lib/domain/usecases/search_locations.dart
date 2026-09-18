import '../entities/location_entity.dart';
import '../repositories/weather_repository.dart';

class SearchLocations {
  final WeatherRepository _repository;

  const SearchLocations(this._repository);

  Future<List<LocationEntity>> call(String query) {
    if (query.trim().isEmpty) {
      return Future.value([]);
    }
    return _repository.searchLocations(query.trim());
  }
}
