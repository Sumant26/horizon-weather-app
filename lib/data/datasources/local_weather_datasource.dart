import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/app_logger.dart';

abstract class LocalWeatherDatasource {
  Future<void> cacheForecast(
      {required String key, required Map<String, dynamic> data});
  Future<Map<String, dynamic>?> getCachedForecast(
      {required String key, Duration ttl = const Duration(minutes: 30)});
  Future<List<Map<String, dynamic>>?> getSavedLocations();
  Future<void> saveLocations(List<Map<String, dynamic>> locations);
  Future<int> getActiveLocationIndex();
  Future<void> saveActiveLocationIndex(int index);
  Future<Map<String, dynamic>?> getSettings();
  Future<void> saveSettings(Map<String, dynamic> settings);
}

class LocalWeatherDatasourceImpl implements LocalWeatherDatasource {
  final SharedPreferences? _prefs;

  LocalWeatherDatasourceImpl({SharedPreferences? prefs}) : _prefs = prefs;

  Future<SharedPreferences> get _instance async =>
      _prefs ?? await SharedPreferences.getInstance();

  static const String _keyLocations = 'horizon_saved_locations';
  static const String _keyActiveIndex = 'horizon_active_location_index';
  static const String _keySettings = 'horizon_user_settings';
  static const String _prefixForecast = 'horizon_forecast_cache_';

  @override
  Future<void> cacheForecast(
      {required String key, required Map<String, dynamic> data}) async {
    final prefs = await _instance;
    final payload = {
      'timestamp': DateTime.now().toIso8601String(),
      'data': data,
    };
    await prefs.setString('$_prefixForecast$key', json.encode(payload));
    AppLogger.debug('Cached forecast snapshot for key: $key');
  }

  @override
  Future<Map<String, dynamic>?> getCachedForecast({
    required String key,
    Duration ttl = const Duration(minutes: 30),
  }) async {
    final prefs = await _instance;
    final raw = prefs.getString('$_prefixForecast$key');
    if (raw == null) return null;

    try {
      final decoded = json.decode(raw) as Map<String, dynamic>;
      final timestampStr = decoded['timestamp'] as String?;
      if (timestampStr != null) {
        final cachedTime = DateTime.parse(timestampStr);
        final age = DateTime.now().difference(cachedTime);
        final isStale = age > ttl;
        final data = decoded['data'] as Map<String, dynamic>;
        data['cached_at'] = timestampStr;
        data['is_stale'] = isStale;
        return data;
      }
    } catch (e) {
      AppLogger.warning('Corrupt forecast cache for key $key: $e');
    }
    return null;
  }

  @override
  Future<List<Map<String, dynamic>>?> getSavedLocations() async {
    final prefs = await _instance;
    final raw = prefs.getString(_keyLocations);
    if (raw == null) return null;
    try {
      final list = json.decode(raw) as List<dynamic>;
      return list.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      AppLogger.warning('Corrupt saved locations cache: $e');
      return null;
    }
  }

  @override
  Future<void> saveLocations(List<Map<String, dynamic>> locations) async {
    final prefs = await _instance;
    await prefs.setString(_keyLocations, json.encode(locations));
  }

  @override
  Future<int> getActiveLocationIndex() async {
    final prefs = await _instance;
    return prefs.getInt(_keyActiveIndex) ?? 0;
  }

  @override
  Future<void> saveActiveLocationIndex(int index) async {
    final prefs = await _instance;
    await prefs.setInt(_keyActiveIndex, index);
  }

  @override
  Future<Map<String, dynamic>?> getSettings() async {
    final prefs = await _instance;
    final raw = prefs.getString(_keySettings);
    if (raw == null) return null;
    try {
      return json.decode(raw) as Map<String, dynamic>;
    } catch (e) {
      AppLogger.warning('Corrupt settings cache: $e');
      return null;
    }
  }

  @override
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await _instance;
    await prefs.setString(_keySettings, json.encode(settings));
  }
}
