import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/deep_meteorology_entity.dart';

class DeepMeteorologyCard extends StatelessWidget {
  final DeepMeteorologyEntity deepMeteorology;
  final VoidCallback? onTap;

  const DeepMeteorologyCard({
    super.key,
    required this.deepMeteorology,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                    Icon(Icons.grain_rounded,
                        size: 14, color: AppColors.softAmber),
                    SizedBox(width: 8),
                    Text(
                      'PRECISION METEOROLOGY MATRIX',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white38,
                        letterSpacing: 2,
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
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _MatrixTile(
                    title: 'VISIBILITY',
                    value:
                        '${deepMeteorology.visibilityKm.toStringAsFixed(1)} km',
                    subtitle: deepMeteorology.visibilityDescription,
                    icon: Icons.visibility_outlined,
                    accentColor: AppColors.twilightCyan,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MatrixTile(
                    title: 'CLOUD CEILING',
                    value:
                        '${deepMeteorology.cloudBaseMeters.toStringAsFixed(0)} m',
                    subtitle: deepMeteorology.cloudBaseDescription,
                    icon: Icons.cloud_outlined,
                    accentColor: AppColors.softAmber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MatrixTile(
                    title: 'SOLAR IRRADIANCE',
                    value:
                        '${deepMeteorology.directSolarRadiationWm2.toStringAsFixed(0)} W/m²',
                    subtitle: 'Direct solar flux',
                    icon: Icons.wb_sunny_outlined,
                    accentColor: AppColors.honeyGold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MatrixTile(
                    title: 'DEW DEPRESSION',
                    value:
                        '${deepMeteorology.dewPointDepressionC.toStringAsFixed(1)}°C',
                    subtitle: 'Condensation margin',
                    icon: Icons.opacity_outlined,
                    accentColor: AppColors.warmSage,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MatrixTile extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  const _MatrixTile({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: accentColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.white38,
                    letterSpacing: 0.9,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.softLinen),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.5),
                fontWeight: FontWeight.w300),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
