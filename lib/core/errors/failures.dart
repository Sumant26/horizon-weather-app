sealed class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure(
      [super.message =
          'No active internet connection. Displaying cached forecast.']);
}

class ServerFailure extends Failure {
  const ServerFailure(
      [super.message =
          'Meteorological node temporarily unreachable. Please try again.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'No cached forecast data available.']);
}

class LocationFailure extends Failure {
  const LocationFailure(
      [super.message = 'Unable to resolve coordinates for this location.']);
}
