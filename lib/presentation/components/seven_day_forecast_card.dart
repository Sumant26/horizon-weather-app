import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/unit_converter.dart';
import '../../domain/entities/daily_forecast_entity.dart';
import '../../domain/entities/weather_condition.dart';

class SevenDayForecastCard extends StatelessWidget {
  final List<DailyForecastEntity> dailyForecast;
  final TemperatureUnit unit;
  final VoidCallback? onTap;

  const SevenDayForecastCard({
    super.key,
    required this.dailyForecast,
    required this.unit,
    this.onTap,
  });

  IconData _getWeatherIcon(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.clearDay:
        return Icons.wb_sunny_rounded;
      case WeatherCondition.clearNight:
        return Icons.nightlight_round;
      case WeatherCondition.partlyCloudyDay:
        return Icons.wb_cloudy_rounded;
      case WeatherCondition.partlyCloudyNight:
        return Icons.cloud_outlined;
      case WeatherCondition.overcast:
      case WeatherCondition.foggy:
        return Icons.cloud;
      case WeatherCondition.drizzle:
      case WeatherCondition.rainy:
        return Icons.grain_rounded;
      case WeatherCondition.thunderstorm:
        return Icons.thunderstorm_rounded;
      case WeatherCondition.snowy:
        return Icons.ac_unit_rounded;
      case WeatherCondition.extremeHeat:
        return Icons.local_fire_department_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dailyForecast.isEmpty) return const SizedBox.shrink();

    // Calculate global min & max for normalized temperature spectrum bars
    double globalMin =
        dailyForecast.map((d) => d.minTemp).reduce((a, b) => a < b ? a : b);
    double globalMax =
        dailyForecast.map((d) => d.maxTemp).reduce((a, b) => a > b ? a : b);
    if (globalMax == globalMin) globalMax += 1.0;

    final themeMode = HorizonTheme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: AppColors.cardDecoration(
          themeMode,
          accentBorder: AppColors.softAmber.withValues(alpha: 0.15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 14, color: AppColors.softAmber),
                    SizedBox(width: 8),
                    Text(
                      '7-DAY OUTLOOK SPECTRUM',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white60,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (onTap != null)
                  Icon(
                    Icons.north_east_rounded,
                    size: 14,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            ...dailyForecast.asMap().entries.map((entry) {
              final idx = entry.key;
              final day = entry.value;
              final isToday = idx == 0;
              final dayName =
                  isToday ? 'Today' : DateFormatter.formatDayOfWeek(day.date);
              final minStr = UnitConverter.formatTemperatureString(
                  day.minTemp, unit,
                  includeSymbol: false);
              final maxStr = UnitConverter.formatTemperatureString(
                  day.maxTemp, unit,
                  includeSymbol: false);

              final minFraction =
                  ((day.minTemp - globalMin) / (globalMax - globalMin))
                      .clamp(0.0, 1.0);
              final maxFraction =
                  ((day.maxTemp - globalMin) / (globalMax - globalMin))
                      .clamp(0.0, 1.0);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 7.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 55,
                      child: Text(
                        dayName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isToday ? FontWeight.w600 : FontWeight.w300,
                          color: isToday ? AppColors.honeyGold : Colors.white70,
                        ),
                      ),
                    ),
                    Icon(
                      _getWeatherIcon(day.condition),
                      size: 18,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 30,
                      child: Text(
                        minStr,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Normalized Responsive Range Spectrum Bar
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final totalWidth = constraints.maxWidth;
                          final leftOffset = (minFraction * totalWidth)
                              .clamp(0.0, totalWidth - 8.0);
                          final rightOffset = ((1.0 - maxFraction) * totalWidth)
                              .clamp(0.0, totalWidth);
                          final barWidth =
                              (totalWidth - leftOffset - rightOffset)
                                  .clamp(8.0, totalWidth);

                          return Container(
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: leftOffset,
                                  width: barWidth,
                                  top: 0,
                                  bottom: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppColors.twilightCyan,
                                          AppColors.softAmber,
                                          AppColors.warmTerracotta
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 30,
                      child: Text(
                        maxStr,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.softLinen,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
