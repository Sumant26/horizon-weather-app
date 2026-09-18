import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/unit_converter.dart';
import '../../domain/entities/weather_entity.dart';

class KineticTemperatureDisplay extends StatelessWidget {
  final WeatherEntity data;
  final TemperatureUnit unit;

  const KineticTemperatureDisplay({
    super.key,
    required this.data,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final tempVal =
        UnitConverter.formatTemperature(data.temperature, unit).round();
    final feelsVal =
        UnitConverter.formatTemperature(data.feelsLike, unit).round();
    final diff = data.tempDifferenceYesterday;
    final diffFormatted =
        (unit == TemperatureUnit.fahrenheit ? diff * 9 / 5 : diff)
            .abs()
            .toStringAsFixed(1);
    final unitSymbol = unit == TemperatureUnit.celsius ? '°C' : '°F';
    final isWarmer = diff >= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Kinetic Temperature Number
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$tempVal°',
                style: TextStyle(
                  fontSize: 108,
                  fontWeight: data.temperature > 28
                      ? FontWeight.w400
                      : (data.temperature < 15
                          ? FontWeight.w200
                          : FontWeight.w300),
                  height: 0.88,
                  letterSpacing: -5,
                  color: AppColors.softLinen,
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.condition.displayName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: AppColors.softAmber,
                        letterSpacing: 0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Feels like $feelsVal$unitSymbol',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Yesterday Comparison Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isWarmer
                ? AppColors.warmTerracotta.withValues(alpha: 0.15)
                : AppColors.twilightCyan.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isWarmer
                  ? AppColors.warmTerracotta.withValues(alpha: 0.3)
                  : AppColors.twilightCyan.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isWarmer
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 14,
                color: isWarmer
                    ? AppColors.warmTerracotta
                    : AppColors.twilightCyan,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  '$diffFormatted$unitSymbol ${isWarmer ? 'warmer' : 'cooler'} than yesterday',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color:
                        isWarmer ? AppColors.softAmber : AppColors.twilightCyan,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
