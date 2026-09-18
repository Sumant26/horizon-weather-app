import 'package:flutter/material.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/usecases/calculate_optimal_window.dart';
import '../../domain/usecases/get_weather_forecast.dart';

sealed class WeatherState {
  const WeatherState();
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

class WeatherLoading extends WeatherState {
  final WeatherEntity? previousData;
  const WeatherLoading({this.previousData});
}

class WeatherLoaded extends WeatherState {
  final WeatherEntity data;
  final bool isFromCache;
  final OutdoorActivity selectedActivity;
  final ActivityWindowResult activityWindow;
  final Set<String> packedGear;

  const WeatherLoaded({
    required this.data,
    this.isFromCache = false,
    this.selectedActivity = OutdoorActivity.walking,
    required this.activityWindow,
    this.packedGear = const {},
  });

  WeatherLoaded copyWith({
    WeatherEntity? data,
    bool? isFromCache,
    OutdoorActivity? selectedActivity,
    ActivityWindowResult? activityWindow,
    Set<String>? packedGear,
  }) {
    return WeatherLoaded(
      data: data ?? this.data,
      isFromCache: isFromCache ?? this.isFromCache,
      selectedActivity: selectedActivity ?? this.selectedActivity,
      activityWindow: activityWindow ?? this.activityWindow,
      packedGear: packedGear ?? this.packedGear,
    );
  }
}

class WeatherErrorState extends WeatherState {
  final Failure failure;
  final WeatherEntity? cachedData;
  const WeatherErrorState(this.failure, {this.cachedData});
}

class WeatherNotifier extends ValueNotifier<WeatherState> {
  final GetWeatherForecast _getWeatherForecast;
  final CalculateOptimalWindow _calculateOptimalWindow;

  WeatherNotifier({
    required GetWeatherForecast getWeatherForecast,
    CalculateOptimalWindow calculateOptimalWindow =
        const CalculateOptimalWindow(),
  })  : _getWeatherForecast = getWeatherForecast,
        _calculateOptimalWindow = calculateOptimalWindow,
        super(const WeatherInitial());

  Future<void> fetchWeatherForLocation(
    LocationEntity location, {
    bool forceRefresh = false,
  }) async {
    final currentLoaded =
        value is WeatherLoaded ? (value as WeatherLoaded) : null;
    final prevData = currentLoaded?.data;

    value = WeatherLoading(previousData: prevData);

    try {
      final weather = await _getWeatherForecast(
        location: location,
        forceRefresh: forceRefresh,
      );

      final activity =
          currentLoaded?.selectedActivity ?? OutdoorActivity.walking;
      final window = _calculateOptimalWindow(
        activity: activity,
        hourlyForecast: weather.hourlyForecast,
        now: weather.timestamp,
      );

      value = WeatherLoaded(
        data: weather,
        isFromCache: weather.isFromCache,
        selectedActivity: activity,
        activityWindow: window,
        packedGear: currentLoaded?.packedGear ?? {},
      );
    } on Failure catch (failure) {
      value = WeatherErrorState(failure, cachedData: prevData);
    } catch (e) {
      value =
          WeatherErrorState(ServerFailure(e.toString()), cachedData: prevData);
    }
  }

  void selectActivity(OutdoorActivity activity) {
    if (value is WeatherLoaded) {
      final current = value as WeatherLoaded;
      final window = _calculateOptimalWindow(
        activity: activity,
        hourlyForecast: current.data.hourlyForecast,
        now: current.data.timestamp,
      );
      value = current.copyWith(
        selectedActivity: activity,
        activityWindow: window,
      );
    }
  }

  void toggleGearItem(String item) {
    if (value is WeatherLoaded) {
      final current = value as WeatherLoaded;
      final updated = Set<String>.from(current.packedGear);
      if (updated.contains(item)) {
        updated.remove(item);
      } else {
        updated.add(item);
      }
      value = current.copyWith(packedGear: updated);
    }
  }
}
