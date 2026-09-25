import '../../core/browser/browser_tab_bridge.dart';
import '../../core/notifications/web_notification_bridge.dart';
import '../../core/utils/unit_converter.dart';
import '../../domain/entities/weather_condition.dart';
import '../../domain/entities/weather_entity.dart';

class BrowserPwaCoordinator {
  static final BrowserPwaCoordinator instance = BrowserPwaCoordinator._();
  final Set<String> _notifiedAlertKeys = {};

  BrowserPwaCoordinator._();

  String _getConditionEmoji(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.clearDay:
        return '☀️';
      case WeatherCondition.clearNight:
        return '🌙';
      case WeatherCondition.partlyCloudyDay:
        return '⛅';
      case WeatherCondition.partlyCloudyNight:
        return '☁️';
      case WeatherCondition.overcast:
        return '☁️';
      case WeatherCondition.drizzle:
        return '🌦️';
      case WeatherCondition.rainy:
        return '🌧️';
      case WeatherCondition.thunderstorm:
        return '⛈️';
      case WeatherCondition.snowy:
        return '❄️';
      case WeatherCondition.foggy:
        return '🌫️';
      case WeatherCondition.extremeHeat:
        return '🔥';
    }
  }

  void syncWithWeather(WeatherEntity weather, TemperatureUnit tempUnit) {
    final tempStr =
        UnitConverter.formatTemperatureString(weather.temperature, tempUnit);
    final emoji = _getConditionEmoji(weather.condition);
    final pageTitle = '$tempStr $emoji Horizon — ${weather.location.name}';

    updateBrowserTab(
      title: pageTitle,
      emoji: emoji,
      tempStr: tempStr,
    );

    // Check proactive smart trigger alerts
    _checkAndDispatchWebAlerts(weather);
  }

  void _checkAndDispatchWebAlerts(WeatherEntity weather) {
    // 1. Rain onset alert
    if (weather.minutePrecipitation.hasPrecipitation) {
      final key = 'rain_${weather.location.name}_${DateTime.now().hour}';
      if (!_notifiedAlertKeys.contains(key)) {
        _notifiedAlertKeys.add(key);
        showWebNotification(
          title: '🌧️ Horizon Rain Alert: ${weather.location.name}',
          body: weather.minutePrecipitation.summaryText,
          tag: 'rain-alert',
        );
      }
    }

    // 2. High severity weather alerts
    for (final alert in weather.weatherAlerts.activeAlerts) {
      final key = 'alert_${alert.title}_${DateTime.now().day}';
      if (!_notifiedAlertKeys.contains(key)) {
        _notifiedAlertKeys.add(key);
        showWebNotification(
          title: '⚠️ ${alert.title}',
          body: alert.description,
          tag: 'severe-alert',
        );
      }
    }
  }

  void requestNotificationPermission(void Function(String status)? callback) {
    requestWebNotificationPermission(callback);
  }
}
