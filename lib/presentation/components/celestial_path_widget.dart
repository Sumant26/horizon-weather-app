import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/astronomy_entity.dart';

class CelestialPathWidget extends StatelessWidget {
  final AstronomyEntity astronomy;
  final VoidCallback? onTap;

  const CelestialPathWidget({
    super.key,
    required this.astronomy,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sunriseStr = DateFormatter.format24Hour(astronomy.sunrise);
    final sunsetStr = DateFormatter.format24Hour(astronomy.sunset);
    final themeMode = HorizonTheme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: AppColors.cardDecoration(
          themeMode,
          accentBorder: AppColors.honeyGold.withValues(alpha: 0.15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.wb_twilight_rounded,
                        size: 14, color: AppColors.softAmber),
                    SizedBox(width: 8),
                    Text(
                      'CELESTIAL SUN & MOON PATH',
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
            const SizedBox(height: 20),
            // Celestial Arc Canvas
            SizedBox(
              height: 90,
              width: double.infinity,
              child: CustomPaint(
                painter: _CelestialArcPainter(
                  progress: astronomy.sunProgress,
                  isDaylight: astronomy.isDaylight,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SUNRISE',
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.white38,
                          letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      sunriseStr,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.softLinen),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      astronomy.isDaylight
                          ? 'GOLDEN HOUR DUSK'
                          : 'STARGAZING WINDOW',
                      style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.softAmber,
                          letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      astronomy.goldenHourEvening != null
                          ? DateFormatter.format24Hour(
                              astronomy.goldenHourEvening!)
                          : 'Active',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.honeyGold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'SUNSET',
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.white38,
                          letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      sunsetStr,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.softLinen),
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

class _CelestialArcPainter extends CustomPainter {
  final double progress;
  final bool isDaylight;

  _CelestialArcPainter({
    required this.progress,
    required this.isDaylight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final baselineY = size.height - 4;
    final radiusX = (size.width - 36) / 2;
    final radiusY = size.height - 18;

    final arcRect = Rect.fromCenter(
      center: Offset(centerX, baselineY),
      width: radiusX * 2,
      height: radiusY * 2,
    );

    // Background dashed/faint arc
    final baseArcPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawArc(arcRect, pi, pi, false, baseArcPaint);

    // Active illuminated arc
    final activePaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          AppColors.twilightCyan,
          AppColors.softAmber,
          AppColors.honeyGold
        ],
      ).createShader(arcRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final sweepAngle = (progress * pi).clamp(0.0, pi);
    canvas.drawArc(arcRect, pi, sweepAngle, false, activePaint);

    // Compute sun/moon position along arc
    final angle = pi + sweepAngle;
    final bodyX = centerX + radiusX * cos(angle);
    final bodyY = baselineY + radiusY * sin(angle);

    // Glowing halo
    final glowPaint = Paint()
      ..color = (isDaylight ? AppColors.honeyGold : AppColors.twilightCyan)
          .withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset(bodyX, bodyY), 9, glowPaint);

    // Sun / Moon center core
    final bodyPaint = Paint()
      ..color = isDaylight ? AppColors.softAmber : AppColors.softLinen
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(bodyX, bodyY), 5, bodyPaint);
  }

  @override
  bool shouldRepaint(covariant _CelestialArcPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.isDaylight != isDaylight;
}
