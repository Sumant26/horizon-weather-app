import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/unit_converter.dart';
import '../../domain/entities/thermal_comfort_entity.dart';

class ThermalComfortCard extends StatelessWidget {
  final ThermalComfortEntity thermalComfort;
  final TemperatureUnit unit;
  final VoidCallback? onTap;

  const ThermalComfortCard({
    super.key,
    required this.thermalComfort,
    required this.unit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeMode = HorizonTheme.of(context);
    final accent = AppColors.primaryAccent(themeMode);

    final ambientStr =
        UnitConverter.formatTemperatureString(thermalComfort.ambientTemp, unit);
    final feelsLikeStr = UnitConverter.formatTemperatureString(
        thermalComfort.feelsLikeTemp, unit);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: AppColors.cardDecoration(
          themeMode,
          accentBorder: accent.withValues(alpha: 0.16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.thermostat_auto_rounded,
                          size: 15, color: AppColors.softAmber),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'BIOCLIMATIC THERMAL COMFORT',
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.softAmber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${thermalComfort.clothingInsulationClo} CLO',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.softAmber,
                          letterSpacing: 0.8,
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

            // Primary Readout: Ambient vs Feels Like
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  feelsLikeStr,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'apparent (vs $ambientStr actual)',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white54,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 3 Physical Factor Breakdown Badges
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FactorPill(
                  icon: Icons.wb_sunny_rounded,
                  label: 'Solar Radiation',
                  deltaText:
                      '+${thermalComfort.solarRadiationDelta.toStringAsFixed(1)}°C',
                  color: AppColors.honeyGold,
                ),
                _FactorPill(
                  icon: Icons.water_drop_rounded,
                  label: 'Humidity Vapor',
                  deltaText:
                      '+${thermalComfort.humidityDelta.toStringAsFixed(1)}°C',
                  color: AppColors.twilightCyan,
                ),
                _FactorPill(
                  icon: Icons.air_rounded,
                  label: 'Wind Convection',
                  deltaText:
                      '${thermalComfort.windChillDelta.toStringAsFixed(1)}°C',
                  color: AppColors.warmSage,
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Clothing Recommendation Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.checkroom_rounded,
                      size: 16, color: AppColors.softLinen),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'RECOMMENDED WARDROBE LAYERS',
                          style: TextStyle(
                              fontSize: 9,
                              color: Colors.white38,
                              letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          thermalComfort.clothingRecommendation,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.softLinen),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FactorPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String deltaText;
  final Color color;

  const _FactorPill({
    required this.icon,
    required this.label,
    required this.deltaText,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 11, color: Colors.white70),
          ),
          Text(
            deltaText,
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}
