import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/unit_converter.dart';
import '../../domain/entities/yesterday_comparison_entity.dart';

class YesterdayComparisonChart extends StatefulWidget {
  final YesterdayComparisonEntity comparison;
  final TemperatureUnit unit;
  final VoidCallback? onTap;

  const YesterdayComparisonChart({
    super.key,
    required this.comparison,
    required this.unit,
    this.onTap,
  });

  @override
  State<YesterdayComparisonChart> createState() =>
      _YesterdayComparisonChartState();
}

class _YesterdayComparisonChartState extends State<YesterdayComparisonChart> {
  int _scrubbedHour = 14; // default 2 PM

  String _formatHour(int h) {
    if (h == 0) return '12 AM';
    if (h == 12) return '12 PM';
    if (h > 12) return '${h - 12} PM';
    return '$h AM';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.comparison.todayHourlyTemps.isEmpty) {
      return const SizedBox.shrink();
    }

    final todayTemp = widget.comparison.todayHourlyTemps[_scrubbedHour];
    final yesterdayTemp = widget.comparison.yesterdayHourlyTemps[_scrubbedHour];
    final delta = todayTemp - yesterdayTemp;
    final isWarmer = delta >= 0;

    final todayStr =
        UnitConverter.formatTemperatureString(todayTemp, widget.unit);
    final yesterdayStr =
        UnitConverter.formatTemperatureString(yesterdayTemp, widget.unit);
    final deltaFormatted =
        (widget.unit == TemperatureUnit.fahrenheit ? delta * 9 / 5 : delta)
            .abs()
            .toStringAsFixed(1);
    final unitSymbol = widget.unit == TemperatureUnit.celsius ? '°C' : '°F';

    final themeMode = HorizonTheme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: AppColors.cardDecoration(
        themeMode,
        accentBorder: AppColors.honeyGold.withValues(alpha: 0.15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.show_chart_rounded,
                          size: 15, color: AppColors.honeyGold),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '24-HOUR YESTERDAY OVERLAY',
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                            color: AppColors.honeyGold,
                            shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    const Text('Today',
                        style: TextStyle(fontSize: 10, color: Colors.white70)),
                    const SizedBox(width: 8),
                    Container(width: 8, height: 2, color: Colors.white38),
                    const SizedBox(width: 4),
                    const Text('Yesterday',
                        style: TextStyle(fontSize: 10, color: Colors.white38)),
                    if (widget.onTap != null) ...[
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
          ),
          const SizedBox(height: 12),
          // Scrubber Information Readout
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${_formatHour(_scrubbedHour)}: Today $todayStr  vs  Yesterday $yesterdayStr',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppColors.softLinen),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '$deltaFormatted$unitSymbol ${isWarmer ? 'warmer' : 'cooler'}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color:
                        isWarmer ? AppColors.softAmber : AppColors.twilightCyan,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Interactive Chart Canvas
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              final box = context.findRenderObject() as RenderBox?;
              if (box != null) {
                final localX =
                    details.localPosition.dx.clamp(0.0, box.size.width);
                final fraction = localX / box.size.width;
                final hour = (fraction * 23).round().clamp(0, 23);
                setState(() => _scrubbedHour = hour);
              }
            },
            child: SizedBox(
              height: 110,
              width: double.infinity,
              child: CustomPaint(
                painter: _YesterdayComparisonChartPainter(
                  todayTemps: widget.comparison.todayHourlyTemps,
                  yesterdayTemps: widget.comparison.yesterdayHourlyTemps,
                  scrubbedHour: _scrubbedHour,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('12 AM',
                  style: TextStyle(fontSize: 10, color: Colors.white38)),
              Text('6 AM',
                  style: TextStyle(fontSize: 10, color: Colors.white38)),
              Text('12 PM',
                  style: TextStyle(fontSize: 10, color: Colors.white38)),
              Text('6 PM',
                  style: TextStyle(fontSize: 10, color: Colors.white38)),
              Text('11 PM',
                  style: TextStyle(fontSize: 10, color: Colors.white38)),
            ],
          ),
        ],
      ),
    );
  }
}

class _YesterdayComparisonChartPainter extends CustomPainter {
  final List<double> todayTemps;
  final List<double> yesterdayTemps;
  final int scrubbedHour;

  _YesterdayComparisonChartPainter({
    required this.todayTemps,
    required this.yesterdayTemps,
    required this.scrubbedHour,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (todayTemps.isEmpty || yesterdayTemps.isEmpty) return;

    final allTemps = [...todayTemps, ...yesterdayTemps];
    final minT = allTemps.reduce(min) - 1.0;
    final maxT = allTemps.reduce(max) + 1.0;
    final range = (maxT - minT) > 0 ? (maxT - minT) : 1.0;

    final dx = size.width / (todayTemps.length - 1);

    // 1. Draw Yesterday's Dashed Curve
    final yesterdayPath = Path();
    for (int i = 0; i < yesterdayTemps.length; i++) {
      final x = i * dx;
      final y = size.height -
          ((yesterdayTemps[i] - minT) / range) * (size.height - 20) -
          10;
      if (i == 0) {
        yesterdayPath.moveTo(x, y);
      } else {
        final prevX = (i - 1) * dx;
        final prevY = size.height -
            ((yesterdayTemps[i - 1] - minT) / range) * (size.height - 20) -
            10;
        final cx = (prevX + x) / 2;
        yesterdayPath.cubicTo(cx, prevY, cx, y, x, y);
      }
    }

    final yesterdayPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(yesterdayPath, yesterdayPaint);

    // 2. Draw Today's Glowing Solid Curve
    final todayPath = Path();
    for (int i = 0; i < todayTemps.length; i++) {
      final x = i * dx;
      final y = size.height -
          ((todayTemps[i] - minT) / range) * (size.height - 20) -
          10;
      if (i == 0) {
        todayPath.moveTo(x, y);
      } else {
        final prevX = (i - 1) * dx;
        final prevY = size.height -
            ((todayTemps[i - 1] - minT) / range) * (size.height - 20) -
            10;
        final cx = (prevX + x) / 2;
        todayPath.cubicTo(cx, prevY, cx, y, x, y);
      }
    }

    // Glow under today's path
    final glowPaint = Paint()
      ..color = AppColors.honeyGold.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawPath(todayPath, glowPaint);

    final todayPaint = Paint()
      ..color = AppColors.honeyGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;
    canvas.drawPath(todayPath, todayPaint);

    // 3. Draw Scrubbed Vertical Cursor
    final cursorX = scrubbedHour * dx;
    final cursorPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 1.0;
    canvas.drawLine(
        Offset(cursorX, 0), Offset(cursorX, size.height), cursorPaint);

    // Highlight dot on Today
    final dotYToday = size.height -
        ((todayTemps[scrubbedHour] - minT) / range) * (size.height - 20) -
        10;
    canvas.drawCircle(
        Offset(cursorX, dotYToday), 5, Paint()..color = AppColors.honeyGold);
    canvas.drawCircle(
        Offset(cursorX, dotYToday), 2, Paint()..color = Colors.white);

    // Highlight dot on Yesterday
    final dotYYesterday = size.height -
        ((yesterdayTemps[scrubbedHour] - minT) / range) * (size.height - 20) -
        10;
    canvas.drawCircle(
        Offset(cursorX, dotYYesterday), 4, Paint()..color = Colors.white54);
  }

  @override
  bool shouldRepaint(covariant _YesterdayComparisonChartPainter oldDelegate) =>
      oldDelegate.scrubbedHour != scrubbedHour ||
      oldDelegate.todayTemps != todayTemps;
}
