class ApiEndpoints {
  ApiEndpoints._();

  static const String openMeteoBase = 'https://api.open-meteo.com/v1';
  static const String openMeteoArchive =
      'https://archive-api.open-meteo.com/v1';
  static const String openMeteoAirQuality =
      'https://air-quality-api.open-meteo.com/v1';
  static const String openMeteoGeocoding =
      'https://geocoding-api.open-meteo.com/v1';

  static Uri forecast({
    required double latitude,
    required double longitude,
    String timezone = 'auto',
  }) {
    return Uri.parse(
      '$openMeteoBase/forecast?'
      'latitude=$latitude&longitude=$longitude'
      '&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,cloud_cover,wind_speed_10m,wind_direction_10m,wind_gusts_10m,surface_pressure,visibility,direct_radiation,uv_index'
      '&hourly=temperature_2m,precipitation_probability,weather_code,surface_pressure,uv_index'
      '&daily=weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,uv_index_max'
      '&timezone=$timezone'
      '&forecast_days=7',
    );
  }

  static Uri historicalYesterday({
    required double latitude,
    required double longitude,
    required String dateString, // YYYY-MM-DD
    String timezone = 'auto',
  }) {
    return Uri.parse(
      '$openMeteoArchive/archive?'
      'latitude=$latitude&longitude=$longitude'
      '&start_date=$dateString&end_date=$dateString'
      '&hourly=temperature_2m'
      '&timezone=$timezone',
    );
  }

  static Uri airQuality({
    required double latitude,
    required double longitude,
    String timezone = 'auto',
  }) {
    return Uri.parse(
      '$openMeteoAirQuality/air-quality?'
      'latitude=$latitude&longitude=$longitude'
      '&current=pm10,pm2_5,european_aqi,us_aqi,ozone'
      '&timezone=$timezone',
    );
  }

  static Uri geocodingSearch(String query, {int count = 6}) {
    return Uri.parse(
      '$openMeteoGeocoding/search?'
      'name=${Uri.encodeComponent(query)}'
      '&count=$count'
      '&language=en&format=json',
    );
  }
}
