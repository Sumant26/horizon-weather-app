import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/minute_precipitation_entity.dart';

class MinutePrecipitationCard extends StatelessWidget {
  final MinutePrecipitationEntity minutePrecipitation;
  final VoidCallback? onTap;

  const MinutePrecipitationCard({
    super.key,
    required this.minutePrecipitation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!minutePrecipitation.hasPrecipitation) return const SizedBox.shrink();

    final themeMode = HorizonTheme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: AppColors.cardDecoration(
          themeMode,
          accentBorder: AppColors.twilightCyan.withValues(alpha: 0.18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.water_drop_rounded,
                    size: 14, color: AppColors.twilightCyan),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'NEXT-HOUR PRECIPITATION',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white60,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.twilightCyan.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.twilightCyan.withValues(alpha: 0.3)),
                  ),
                  child: const Text(
                    '60 Min',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.twilightCyan),
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
            const SizedBox(height: 12),
            Text(
              minutePrecipitation.summaryText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                height: 1.35,
                color: AppColors.softLinen,
              ),
            ),
            const SizedBox(height: 18),

            // 60-Minute Bar Graph
            SizedBox(
              height: 48,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: minutePrecipitation.minutePoints.map((pt) {
                  final heightFraction =
                      (pt.intensityMmHr / 6.0).clamp(0.08, 1.0);
                  final hasRain = pt.intensityMmHr > 0.1;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.6),
                      child: Container(
                        height: 48 * heightFraction,
                        decoration: BoxDecoration(
                          color: hasRain
                              ? (pt.intensityMmHr > 3.0
                                  ? AppColors.honeyGold
                                  : AppColors.twilightCyan)
                              : Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Now',
                    style: TextStyle(fontSize: 10, color: Colors.white38)),
                Text('15 min',
                    style: TextStyle(fontSize: 10, color: Colors.white38)),
                Text('30 min',
                    style: TextStyle(fontSize: 10, color: Colors.white38)),
                Text('45 min',
                    style: TextStyle(fontSize: 10, color: Colors.white38)),
                Text('60 min',
                    style: TextStyle(fontSize: 10, color: Colors.white38)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
