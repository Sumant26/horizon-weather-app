import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/haptic_feedback_util.dart';
import '../../core/utils/unit_converter.dart';
import '../../domain/entities/weather_condition.dart';
import '../../domain/entities/wind_stream_entity.dart';

enum RadarDisplayMode { precipitation, windFlow }

class WeatherRadarCard extends StatefulWidget {
  final WeatherCondition condition;
  final WindStreamEntity windStream;
  final SpeedUnit speedUnit;
  final VoidCallback? onTap;

  const WeatherRadarCard({
    super.key,
    required this.condition,
    required this.windStream,
    required this.speedUnit,
    this.onTap,
  });

  @override
  State<WeatherRadarCard> createState() => _WeatherRadarCardState();
}

class _WeatherRadarCardState extends State<WeatherRadarCard>
    with SingleTickerProviderStateMixin {
  RadarDisplayMode _currentMode = RadarDisplayMode.precipitation;
  late final AnimationController _animController;
  bool _isPlaying = true;
  double _timeSliderVal = 0.5; // 0.0 = -60m, 0.5 = Now, 1.0 = +60m

  final List<_WindParticle> _windParticles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _initWindParticles();
  }

  void _initWindParticles() {
    _windParticles.clear();
    for (int i = 0; i < 50; i++) {
      _windParticles.add(
        _WindParticle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          length: _random.nextDouble() * 20 + 10,
          speed: _random.nextDouble() * 0.4 + 0.2,
          opacity: _random.nextDouble() * 0.5 + 0.2,
        ),
      );
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _getTimeOffsetLabel(double val) {
    if (val < 0.2) return '-60 min';
    if (val < 0.4) return '-30 min';
    if (val < 0.6) return 'Now (Live)';
    if (val < 0.8) return '+30 min (Forecast)';
    return '+60 min (Forecast)';
  }

  @override
  Widget build(BuildContext context) {
    final speedStr = UnitConverter.formatSpeedString(
        widget.windStream.speedKmh, widget.speedUnit);
    final gustStr = UnitConverter.formatSpeedString(
        widget.windStream.gustKmh, widget.speedUnit);

    final themeMode = HorizonTheme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: AppColors.cardDecoration(
        themeMode,
        accentBorder: AppColors.twilightCyan.withValues(alpha: 0.15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Mode Segmented Switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.onTap,
                  child: Row(
                    children: [
                      Icon(
                        _currentMode == RadarDisplayMode.precipitation
                            ? Icons.radar_rounded
                            : Icons.air_rounded,
                        size: 15,
                        color: AppColors.twilightCyan,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _currentMode == RadarDisplayMode.precipitation
                              ? 'PRECIPITATION RADAR'
                              : 'WIND VECTOR STREAMLINES',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white60,
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.onTap != null) ...[
                        const SizedBox(width: 6),
                        Icon(
                          Icons.north_east_rounded,
                          size: 12,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SegmentedButton<RadarDisplayMode>(
                segments: const [
                  ButtonSegment(
                    value: RadarDisplayMode.precipitation,
                    label: Text('Rain', style: TextStyle(fontSize: 11)),
                  ),
                  ButtonSegment(
                    value: RadarDisplayMode.windFlow,
                    label: Text('Wind', style: TextStyle(fontSize: 11)),
                  ),
                ],
                selected: {_currentMode},
                onSelectionChanged: (set) =>
                    setState(() => _currentMode = set.first),
                style: const ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Interactive Radar / Streamline Canvas
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 175,
              width: double.infinity,
              color: const Color(0xFF0D1117),
              child: Stack(
                children: [
                  // Animated Canvas wrapped in RepaintBoundary for 60/120 FPS
                  RepaintBoundary(
                    child: AnimatedBuilder(
                      animation: _animController,
                      builder: (context, _) {
                        return CustomPaint(
                          painter:
                              _currentMode == RadarDisplayMode.precipitation
                                  ? _PrecipitationRadarPainter(
                                      sweepProgress: _animController.value,
                                      timeOffset: _timeSliderVal,
                                      isRaining: widget.condition ==
                                              WeatherCondition.rainy ||
                                          widget.condition ==
                                              WeatherCondition.drizzle,
                                    )
                                  : _WindStreamlinesPainter(
                                      particles: _windParticles,
                                      progress: _animController.value,
                                      directionDegrees:
                                          widget.windStream.directionDegrees,
                                      speedMultiplier:
                                          widget.windStream.speedKmh / 15.0,
                                    ),
                          size: Size.infinite,
                        );
                      },
                    ),
                  ),
                  // Center Location Pin
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.honeyGold.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: AppColors.honeyGold, width: 1.5),
                      ),
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppColors.softLinen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  // Overlay Badge Details
                  Positioned(
                    top: 10,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _currentMode == RadarDisplayMode.precipitation
                            ? 'Range: 50 km radius'
                            : 'Bearing: ${widget.windStream.cardinalBearing} (${widget.windStream.directionDegrees.round()}°)',
                        style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Scrubber & Mode Specific Controls
          if (_currentMode == RadarDisplayMode.precipitation) ...[
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_filled_rounded,
                    color: AppColors.softAmber,
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPlaying = !_isPlaying;
                      if (_isPlaying) {
                        _animController.repeat();
                      } else {
                        _animController.stop();
                      }
                    });
                  },
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.honeyGold,
                      inactiveTrackColor: Colors.white12,
                      thumbColor: AppColors.softLinen,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 12),
                    ),
                    child: Slider(
                      value: _timeSliderVal,
                      onChanged: (val) {
                        HapticFeedbackHelper.selection();
                        setState(() => _timeSliderVal = val);
                      },
                    ),
                  ),
                ),
                Text(
                  _getTimeOffsetLabel(_timeSliderVal),
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.softAmber,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WindMetric(label: 'WIND SPEED', value: speedStr),
                _WindMetric(label: 'GUST VELOCITY', value: gustStr),
                _WindMetric(
                    label: 'BEAUFORT SCALE',
                    value: widget.windStream.beaufortScale),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _WindMetric extends StatelessWidget {
  final String label;
  final String value;
  const _WindMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 10, color: Colors.white38, letterSpacing: 1.2)),
        const SizedBox(height: 3),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.softLinen)),
      ],
    );
  }
}

class _WindParticle {
  double x;
  double y;
  final double length;
  final double speed;
  final double opacity;

  _WindParticle({
    required this.x,
    required this.y,
    required this.length,
    required this.speed,
    required this.opacity,
  });
}

class _WindStreamlinesPainter extends CustomPainter {
  final List<_WindParticle> particles;
  final double progress;
  final double directionDegrees;
  final double speedMultiplier;

  _WindStreamlinesPainter({
    required this.particles,
    required this.progress,
    required this.directionDegrees,
    required this.speedMultiplier,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rad = (directionDegrees - 90) * pi / 180.0;
    final dx = cos(rad);
    final dy = sin(rad);

    for (final p in particles) {
      final travel = (progress * p.speed * speedMultiplier) % 1.0;
      final curX = ((p.x + dx * travel) % 1.0) * size.width;
      final curY = ((p.y + dy * travel) % 1.0) * size.height;

      final start = Offset(curX, curY);
      final end = Offset(curX + dx * p.length, curY + dy * p.length);

      final paint = Paint()
        ..color = AppColors.twilightCyan.withValues(alpha: p.opacity * 0.6)
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WindStreamlinesPainter oldDelegate) => true;
}

class _PrecipitationRadarPainter extends CustomPainter {
  final double sweepProgress;
  final double timeOffset;
  final bool isRaining;

  _PrecipitationRadarPainter({
    required this.sweepProgress,
    required this.timeOffset,
    required this.isRaining,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) / 2 - 8;

    // Range rings
    final ringPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, maxRadius * 0.33, ringPaint);
    canvas.drawCircle(center, maxRadius * 0.66, ringPaint);
    canvas.drawCircle(center, maxRadius, ringPaint);

    // Crosshairs
    canvas.drawLine(Offset(center.dx - maxRadius, center.dy),
        Offset(center.dx + maxRadius, center.dy), ringPaint);
    canvas.drawLine(Offset(center.dx, center.dy - maxRadius),
        Offset(center.dx, center.dy + maxRadius), ringPaint);

    // Simulated Radar Precipitation Echo Cells
    final echoPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    if (isRaining || timeOffset > 0.4) {
      // Cell 1: Mild shower band
      final c1 =
          Offset(center.dx - 28 + sin(timeOffset * pi) * 15, center.dy - 20);
      echoPaint.color = AppColors.twilightCyan.withValues(alpha: 0.45);
      canvas.drawCircle(c1, 32, echoPaint);

      // Cell 2: Core shower cell
      final c2 =
          Offset(center.dx + 35, center.dy + 15 - cos(timeOffset * pi) * 20);
      echoPaint.color = AppColors.honeyGold.withValues(alpha: 0.35);
      canvas.drawCircle(c2, 24, echoPaint);
    }

    // Rotating Radar Beam Sweep Line
    final angle = sweepProgress * 2 * pi;
    final beamEnd = Offset(
        center.dx + maxRadius * cos(angle), center.dy + maxRadius * sin(angle));

    final beamPaint = Paint()
      ..shader = SweepGradient(
        startAngle: angle - 0.5,
        endAngle: angle,
        colors: [
          Colors.transparent,
          AppColors.twilightCyan.withValues(alpha: 0.3)
        ],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius))
      ..style = PaintingStyle.fill;

    canvas.drawArc(Rect.fromCircle(center: center, radius: maxRadius),
        angle - 0.5, 0.5, true, beamPaint);

    final linePaint = Paint()
      ..color = AppColors.twilightCyan.withValues(alpha: 0.6)
      ..strokeWidth = 1.2;
    canvas.drawLine(center, beamEnd, linePaint);
  }

  @override
  bool shouldRepaint(covariant _PrecipitationRadarPainter oldDelegate) => true;
}
