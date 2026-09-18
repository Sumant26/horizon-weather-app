import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/local_weather_datasource.dart';
import 'data/datasources/remote_weather_datasource.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'data/repositories/weather_repository_impl.dart';
import 'domain/usecases/calculate_optimal_window.dart';
import 'domain/usecases/detect_current_location.dart';
import 'domain/usecases/get_weather_forecast.dart';
import 'domain/usecases/search_locations.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/state/location_provider.dart';
import 'presentation/state/settings_provider.dart';
import 'presentation/state/weather_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set structural status bar overlay styling for a clean, borderless display
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Datasources & Repositories
  final remoteDatasource = RemoteWeatherDatasourceImpl();
  final localDatasource = LocalWeatherDatasourceImpl();

  final weatherRepository = WeatherRepositoryImpl(
    remoteDatasource: remoteDatasource,
    localDatasource: localDatasource,
  );
  final settingsRepository = SettingsRepositoryImpl(
    localDatasource: localDatasource,
  );

  // Initialize Use Cases
  final getWeatherForecast = GetWeatherForecast(weatherRepository);
  final searchLocations = SearchLocations(weatherRepository);
  final detectCurrentLocation = DetectCurrentLocation(weatherRepository);
  const calculateOptimalWindow = CalculateOptimalWindow();

  // Initialize Notifiers
  final settingsNotifier = SettingsNotifier(settingsRepository);
  final locationNotifier = LocationNotifier(
    settingsRepository: settingsRepository,
    searchLocations: searchLocations,
    detectCurrentLocation: detectCurrentLocation,
  );
  final weatherNotifier = WeatherNotifier(
    getWeatherForecast: getWeatherForecast,
    calculateOptimalWindow: calculateOptimalWindow,
  );

  runApp(
    HorizonWeatherApp(
      weatherNotifier: weatherNotifier,
      locationNotifier: locationNotifier,
      settingsNotifier: settingsNotifier,
    ),
  );
}

class HorizonWeatherApp extends StatelessWidget {
  final WeatherNotifier weatherNotifier;
  final LocationNotifier locationNotifier;
  final SettingsNotifier settingsNotifier;

  const HorizonWeatherApp({
    super.key,
    required this.weatherNotifier,
    required this.locationNotifier,
    required this.settingsNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horizon',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
        },
      ),
      home: WeatherHomeScreen(
        weatherNotifier: weatherNotifier,
        locationNotifier: locationNotifier,
        settingsNotifier: settingsNotifier,
      ),
    );
  }
}
