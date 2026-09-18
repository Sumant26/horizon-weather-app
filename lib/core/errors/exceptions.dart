class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException(this.message, {this.statusCode});

  @override
  String toString() => 'ServerException: $message (code: $statusCode)';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(
      [this.message = 'Network request timed out or failed']);

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Local cache miss or corrupted']);

  @override
  String toString() => 'CacheException: $message';
}
