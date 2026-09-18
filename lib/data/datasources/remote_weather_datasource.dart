import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_endpoints.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/app_logger.dart';

abstract class RemoteWeatherDatasource {
  Future<Map<String, dynamic>> getForecast(
      {required double latitude, required double longitude});
  Future<double?> getYesterdayTemperature(
      {required double latitude,
      required double longitude,
      required DateTime now});
  Future<Map<String, dynamic>> getAirQuality(
      {required double latitude, required double longitude});
  Future<List<Map<String, dynamic>>> searchLocations(String query);
  Future<Map<String, dynamic>?> detectCurrentLocation();
}

class RemoteWeatherDatasourceImpl implements RemoteWeatherDatasource {
  final http.Client _client;

  RemoteWeatherDatasourceImpl({http.Client? client})
      : _client = client ?? http.Client();

  static const Duration _timeout = Duration(seconds: 10);

  @override
  Future<Map<String, dynamic>> getForecast(
      {required double latitude, required double longitude}) async {
    final uri = ApiEndpoints.forecast(latitude: latitude, longitude: longitude);
    AppLogger.debug('Fetching forecast from $uri');
    try {
      final response = await _client.get(uri).timeout(_timeout);
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw ServerException('Forecast API failed',
            statusCode: response.statusCode);
      }
    } on TimeoutException {
      throw const NetworkException('Forecast request timed out');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException(e.toString());
    }
  }

  @override
  Future<double?> getYesterdayTemperature({
    required double latitude,
    required double longitude,
    required DateTime now,
  }) async {
    final yesterday = now.subtract(const Duration(days: 1));
    final dateString =
        "${yesterday.year.toString().padLeft(4, '0')}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";
    final uri = ApiEndpoints.historicalYesterday(
        latitude: latitude, longitude: longitude, dateString: dateString);
    AppLogger.debug('Fetching historical comparison from $uri');

    try {
      final response = await _client.get(uri).timeout(_timeout);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final hourly = data['hourly'] as Map<String, dynamic>?;
        if (hourly != null) {
          final temps =
              (hourly['temperature_2m'] as List<dynamic>?)?.cast<num>();
          final currentHour = now.hour;
          if (temps != null && temps.length > currentHour) {
            return temps[currentHour].toDouble();
          }
        }
      }
    } catch (e) {
      AppLogger.warning(
          'Could not retrieve exact historical yesterday temp: $e');
    }
    return null; // Graceful fallback
  }

  @override
  Future<Map<String, dynamic>> getAirQuality(
      {required double latitude, required double longitude}) async {
    final uri =
        ApiEndpoints.airQuality(latitude: latitude, longitude: longitude);
    AppLogger.debug('Fetching air quality from $uri');
    try {
      final response = await _client.get(uri).timeout(_timeout);
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw ServerException('Air Quality API failed',
            statusCode: response.statusCode);
      }
    } on TimeoutException {
      throw const NetworkException('Air quality request timed out');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> searchLocations(String query) async {
    final uri = ApiEndpoints.geocodingSearch(query);
    AppLogger.debug('Searching locations at $uri');
    try {
      final response = await _client.get(uri).timeout(_timeout);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>?;
        if (results != null) {
          return results.map((e) => e as Map<String, dynamic>).toList();
        }
        return [];
      } else {
        throw ServerException('Geocoding search failed',
            statusCode: response.statusCode);
      }
    } on TimeoutException {
      throw const NetworkException('Geocoding search timed out');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>?> detectCurrentLocation() async {
    // 1. Try Primary IP Geolocation endpoint
    try {
      final uri = ApiEndpoints.ipLocationPrimary();
      AppLogger.debug('Detecting current location from $uri');
      final response =
          await _client.get(uri).timeout(const Duration(seconds: 6));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final city = data['city'] as String?;
        final lat = data['latitude'] as num?;
        final lon = data['longitude'] as num?;
        if (city != null && lat != null && lon != null) {
          return {
            'name': city,
            'admin1': data['region'] as String?,
            'country': data['country_name'] as String?,
            'latitude': lat.toDouble(),
            'longitude': lon.toDouble(),
            'is_current': true,
          };
        }
      }
    } catch (e) {
      AppLogger.warning('Primary IP geolocation failed: $e. Trying fallback.');
    }

    // 2. Try Fallback IP Geolocation endpoint
    try {
      final uri = ApiEndpoints.ipLocationSecondary();
      AppLogger.debug('Detecting current location fallback from $uri');
      final response =
          await _client.get(uri).timeout(const Duration(seconds: 6));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final city = data['cityName'] as String?;
        final lat = data['latitude'] as num?;
        final lon = data['longitude'] as num?;
        if (city != null && lat != null && lon != null) {
          return {
            'name': city,
            'admin1': data['regionName'] as String?,
            'country': data['countryName'] as String?,
            'latitude': lat.toDouble(),
            'longitude': lon.toDouble(),
            'is_current': true,
          };
        }
      }
    } catch (e) {
      AppLogger.warning('Fallback IP geolocation failed: $e');
    }

    return null;
  }
}
