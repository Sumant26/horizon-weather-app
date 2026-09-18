import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/air_quality_entity.dart';

class AirQualityCard extends StatelessWidget {
  final AirQualityEntity airQuality;
  final double uvIndex;
  final VoidCallback? onTap;

  const AirQualityCard({
    super.key,
    required this.airQuality,
    required this.uvIndex,
    this.onTap,
  });

  Color _getAqiColor(int aqi) {
    if (aqi <= 30) return AppColors.warmSage;
    if (aqi <= 60) return AppColors.twilightCyan;
    if (aqi <= 100) return AppColors.softAmber;
    return AppColors.warmTerracotta;
  }

  String _getUvDescription(double uv) {
    if (uv <= 2) return 'Low';
    if (uv <= 5) return 'Moderate';
    if (uv <= 7) return 'High';
    return 'Very High';
  }

  @override
  Widget build(BuildContext context) {
    final aqiColor = _getAqiColor(airQuality.aqi);
    final themeMode = HorizonTheme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: AppColors.cardDecoration(
          themeMode,
          accentBorder: aqiColor.withValues(alpha: 0.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.air_rounded,
                          size: 14, color: AppColors.twilightCyan),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'AIR QUALITY & UV',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white60,
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: aqiColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: aqiColor.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        'AQI ${airQuality.aqi} • ${airQuality.status}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: aqiColor,
                        ),
                      ),
                    ),
                    if (onTap != null) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.north_east_rounded,
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              airQuality.recommendation,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                height: 1.4,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white10, height: 1),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MetricItem(
                    label: 'PM2.5',
                    value: '${airQuality.pm2_5.toStringAsFixed(1)} µg/m³'),
                _MetricItem(
                    label: 'PM10',
                    value: '${airQuality.pm10.toStringAsFixed(1)} µg/m³'),
                _MetricItem(
                    label: 'UV INDEX',
                    value:
                        '${uvIndex.toStringAsFixed(1)} (${_getUvDescription(uvIndex)})'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;

  const _MetricItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 10, color: Colors.white38, letterSpacing: 1.2),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.softLinen),
        ),
      ],
    );
  }
}
