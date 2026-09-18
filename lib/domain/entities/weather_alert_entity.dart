import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'weather_condition.dart';

enum AlertSeverity { informational, advisory, severe }

class WeatherAlertItem {
  final String title;
  final String description;
  final AlertSeverity severity;
  final IconData icon;
  final Color badgeColor;

  const WeatherAlertItem({
    required this.title,
    required this.description,
    required this.severity,
    required this.icon,
    required this.badgeColor,
  });
}

class WeatherAlertEntity {
  final List<WeatherAlertItem> activeAlerts;

  const WeatherAlertEntity({required this.activeAlerts});

  bool get hasAlerts => activeAlerts.isNotEmpty;

  factory WeatherAlertEntity.evaluate({
    required double temperature,
    required double windSpeedKmh,
    required double? gustKmh,
    required double uvIndex,
    required WeatherCondition condition,
    required double tempDifferenceYesterday,
  }) {
    final List<WeatherAlertItem> alerts = [];

    // 1. High Wind & Gale
    if (windSpeedKmh > 45 || (gustKmh != null && gustKmh > 60)) {
      alerts.add(
        const WeatherAlertItem(
          title: 'High Wind & Gale Advisory',
          description:
              'Strong atmospheric gusts detected. Secure loose outdoor items and exercise caution when commuting.',
          severity: AlertSeverity.severe,
          icon: Icons.wind_power_rounded,
          badgeColor: AppColors.warmTerracotta,
        ),
      );
    }

    // 2. Extreme Solar UV Alert
    if (uvIndex >= 8.0) {
      alerts.add(
        const WeatherAlertItem(
          title: 'Extreme Solar Radiation Alert',
          description:
              'Peak solar UV intensity is very high. Limit direct midday exposure and wear sun protection.',
          severity: AlertSeverity.advisory,
          icon: Icons.wb_sunny_rounded,
          badgeColor: AppColors.softAmber,
        ),
      );
    }

    // 3. Thunderstorm Warning
    if (condition == WeatherCondition.thunderstorm) {
      alerts.add(
        const WeatherAlertItem(
          title: 'Thunderstorm Warning',
          description:
              'Lightning and heavy localized precipitation in your area. Stay comfortably indoors.',
          severity: AlertSeverity.severe,
          icon: Icons.thunderstorm_rounded,
          badgeColor: AppColors.twilightCyan,
        ),
      );
    }

    // 4. Sudden Temperature Drop / Front
    if (tempDifferenceYesterday < -4.0) {
      alerts.add(
        WeatherAlertItem(
          title: 'Sharp Cooling Trend',
          description:
              'Atmospheric front moving through: about ${tempDifferenceYesterday.abs().toStringAsFixed(1)}°C colder than yesterday.',
          severity: AlertSeverity.informational,
          icon: Icons.ac_unit_rounded,
          badgeColor: AppColors.twilightCyan,
        ),
      );
    }

    // 5. Excessive Heat
    if (temperature >= 35.0) {
      alerts.add(
        const WeatherAlertItem(
          title: 'Elevated Ambient Heat Advisory',
          description:
              'High temperatures recorded. Keep hydrated and enjoy shaded spaces.',
          severity: AlertSeverity.advisory,
          icon: Icons.local_fire_department_rounded,
          badgeColor: AppColors.warmTerracotta,
        ),
      );
    }

    return WeatherAlertEntity(activeAlerts: alerts);
  }
}
