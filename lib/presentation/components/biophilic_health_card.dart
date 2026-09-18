import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/biophilic_health_entity.dart';

class BiophilicHealthCard extends StatelessWidget {
  final BiophilicHealthEntity biophilicHealth;
  final VoidCallback? onTap;

  const BiophilicHealthCard({
    super.key,
    required this.biophilicHealth,
    this.onTap,
  });

  Color _getPollenColor(PollenLevel level) {
    switch (level) {
      case PollenLevel.low:
        return AppColors.warmSage;
      case PollenLevel.moderate:
        return AppColors.softAmber;
      case PollenLevel.elevated:
      case PollenLevel.high:
        return AppColors.warmTerracotta;
    }
  }

  String _getPollenLabel(PollenLevel level) {
    switch (level) {
      case PollenLevel.low:
        return 'Low';
      case PollenLevel.moderate:
        return 'Moderate';
      case PollenLevel.elevated:
        return 'Elevated';
      case PollenLevel.high:
        return 'High';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDroppingFast =
        biophilicHealth.pressureTrend == PressureTrend.droppingFast;

    final themeMode = HorizonTheme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: AppColors.cardDecoration(
          themeMode,
          accentBorder: AppColors.warmSage.withValues(alpha: 0.15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.spa_rounded,
                          size: 14, color: AppColors.warmSage),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'BIOPHILIC HEALTH & CIRCADIAN WELLNESS',
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
                if (onTap != null)
                  Icon(
                    Icons.north_east_rounded,
                    size: 14,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // 1. Barometric Pressure & Migraine Barometer
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDroppingFast
                    ? AppColors.warmTerracotta.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDroppingFast
                      ? AppColors.warmTerracotta.withValues(alpha: 0.35)
                      : Colors.white.withValues(alpha: 0.06),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.speed_rounded,
                              size: 16,
                              color: isDroppingFast
                                  ? AppColors.warmTerracotta
                                  : AppColors.softAmber,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'BAROMETRIC PRESSURE: ${biophilicHealth.surfacePressureHpa.toStringAsFixed(0)} hPa',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                  color: Colors.white60,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        biophilicHealth.headacheRiskStatus,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDroppingFast
                              ? AppColors.warmTerracotta
                              : AppColors.warmSage,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    biophilicHealth.headacheAdvice,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      height: 1.35,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 2. Circadian Sunlight & Vitamin D
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.wb_sunny_outlined,
                          size: 16, color: AppColors.honeyGold),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'VITAMIN D EXPOSURE: ${biophilicHealth.vitaminDWindow}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: AppColors.softAmber,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    biophilicHealth.vitaminDAdvice,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      height: 1.35,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Pollen & Allergen Pills + Dew Point Breathability
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'POLLEN ALLERGENS',
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.white38,
                            letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _PollenPill(
                              label: 'Tree',
                              levelStr:
                                  _getPollenLabel(biophilicHealth.treePollen),
                              color:
                                  _getPollenColor(biophilicHealth.treePollen)),
                          _PollenPill(
                              label: 'Grass',
                              levelStr:
                                  _getPollenLabel(biophilicHealth.grassPollen),
                              color:
                                  _getPollenColor(biophilicHealth.grassPollen)),
                          _PollenPill(
                              label: 'Weed',
                              levelStr:
                                  _getPollenLabel(biophilicHealth.weedPollen),
                              color:
                                  _getPollenColor(biophilicHealth.weedPollen)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'BREATHABILITY',
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.white38,
                          letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      biophilicHealth.breathabilityScore,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.twilightCyan,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PollenPill extends StatelessWidget {
  final String label;
  final String levelStr;
  final Color color;

  const _PollenPill({
    required this.label,
    required this.levelStr,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        '$label: $levelStr',
        style:
            TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: color),
      ),
    );
  }
}
