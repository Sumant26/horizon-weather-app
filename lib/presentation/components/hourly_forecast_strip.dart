import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/haptic_feedback_util.dart';
import '../../core/utils/unit_converter.dart';
import '../../domain/entities/hourly_forecast_entity.dart';
import '../../domain/entities/weather_condition.dart';

class HourlyForecastStrip extends StatelessWidget {
  final List<HourlyForecastEntity> hourly;
  final TemperatureUnit unit;
  final VoidCallback? onTap;

  const HourlyForecastStrip({
    super.key,
    required this.hourly,
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
    if (hourly.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '24-HOUR MICROCLIMATE TIMELINE',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white60,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
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
          SizedBox(
            height: 115,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: hourly.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final item = hourly[index];
                final isCurrent = index == 0;
                final tempStr = UnitConverter.formatTemperatureString(
                    item.temperature, unit);

                return GestureDetector(
                  onTap: () => HapticFeedbackHelper.selection(),
                  child: Container(
                    width: 68,
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppColors.honeyGold.withValues(alpha: 0.12)
                          : Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isCurrent
                            ? AppColors.honeyGold.withValues(alpha: 0.35)
                            : Colors.white.withValues(alpha: 0.07),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isCurrent
                              ? 'Now'
                              : DateFormatter.formatHour(item.time),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                isCurrent ? FontWeight.w600 : FontWeight.w400,
                            color: isCurrent
                                ? AppColors.honeyGold
                                : Colors.white60,
                          ),
                        ),
                        Icon(
                          _getWeatherIcon(item.condition),
                          size: 20,
                          color:
                              isCurrent ? AppColors.softAmber : Colors.white70,
                        ),
                        Text(
                          tempStr,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.softLinen,
                          ),
                        ),
                        if (item.precipitationProbability > 10)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.water_drop_rounded,
                                  size: 9, color: AppColors.twilightCyan),
                              const SizedBox(width: 2),
                              Text(
                                '${item.precipitationProbability}%',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.twilightCyan,
                                ),
                              ),
                            ],
                          )
                        else
                          const SizedBox(height: 12),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
