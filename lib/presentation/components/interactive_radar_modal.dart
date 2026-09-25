import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/haptic_feedback_util.dart';
import '../../core/utils/unit_converter.dart';
import '../../domain/entities/weather_condition.dart';
import '../../domain/entities/wind_stream_entity.dart';

enum RadarLayer {
  precipitation('Precipitation', Icons.radar_rounded, AppColors.twilightCyan),
  windVectors('Wind Vectors', Icons.air_rounded, AppColors.honeyGold),
  satellite('Infrared Cloud', Icons.cloud_outlined, AppColors.softLinen),
  stormCells('Convection Cells', Icons.bolt_rounded, AppColors.warmTerracotta);

  final String label;
  final IconData icon;
  final Color accentColor;
  const RadarLayer(this.label, this.icon, this.accentColor);
}

class MicroclimateProbe {
  final Offset position;
  final double normalizedX;
  final double normalizedY;
  final double temperatureC;
  final double rainRateMmH;
  final double windSpeedKmh;
  final int elevationMeters;

  const MicroclimateProbe({
    required this.position,
    required this.normalizedX,
    required this.normalizedY,
    required this.temperatureC,
    required this.rainRateMmH,
    required this.windSpeedKmh,
    required this.elevationMeters,
  });
}

class InteractiveRadarModal extends StatefulWidget {
  final WeatherCondition condition;
  final WindStreamEntity windStream;
  final double baseTemperatureC;
  final String locationName;
  final SpeedUnit speedUnit;
  final TemperatureUnit tempUnit;

  const InteractiveRadarModal({
    super.key,
    required this.condition,
    required this.windStream,
    required this.baseTemperatureC,
    required this.locationName,
    required this.speedUnit,
    required this.tempUnit,
  });

  static void show(
    BuildContext context, {
    required WeatherCondition condition,
    required WindStreamEntity windStream,
    required double baseTemperatureC,
    required String locationName,
    required SpeedUnit speedUnit,
    required TemperatureUnit tempUnit,
  }) {
    HapticFeedbackHelper.selection();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => InteractiveRadarModal(
        condition: condition,
        windStream: windStream,
        baseTemperatureC: baseTemperatureC,
        locationName: locationName,
        speedUnit: speedUnit,
        tempUnit: tempUnit,
      ),
    );
  }

  @override
  State<InteractiveRadarModal> createState() => _InteractiveRadarModalState();
}

class _InteractiveRadarModalState extends State<InteractiveRadarModal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  RadarLayer _activeLayer = RadarLayer.precipitation;
  bool _isPlaying = true;
  double _timeOffset = 0.5; // 0.0 = -2h, 0.5 = Live, 1.0 = +2h

  MicroclimateProbe? _selectedProbe;
  final TransformationController _transformController =
      TransformationController();

  final List<_Particle> _particles = [];
  final Random _rng = Random(42);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    for (int i = 0; i < 70; i++) {
      _particles.add(_Particle(
        x: _rng.nextDouble(),
        y: _rng.nextDouble(),
        length: _rng.nextDouble() * 24 + 10,
        speed: _rng.nextDouble() * 0.4 + 0.2,
        opacity: _rng.nextDouble() * 0.6 + 0.2,
      ));
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  void _onTapCanvas(TapUpDetails details, Size canvasSize) {
    HapticFeedbackHelper.selection();
    final localPos = details.localPosition;
    final nx = (localPos.dx / canvasSize.width).clamp(0.0, 1.0);
    final ny = (localPos.dy / canvasSize.height).clamp(0.0, 1.0);

    // Compute simulated microclimate based on coordinates
    final distFromCenter = sqrt(pow(nx - 0.5, 2) + pow(ny - 0.5, 2));
    final elev = (45 + (1.0 - ny) * 380 + sin(nx * pi * 4) * 60).round();
    final lapseRate = (elev / 1000.0) * 6.5; // ~6.5C drop per 1000m
    final simulatedTemp = widget.baseTemperatureC - lapseRate + (0.5 - nx) * 1.5;

    final isRaining = widget.condition == WeatherCondition.rainy ||
        widget.condition == WeatherCondition.drizzle;
    final rainRate = isRaining
        ? (max(0.0, (1.0 - distFromCenter * 2.2)) * 6.8 * (_timeOffset + 0.4))
        : (max(0.0, (0.6 - distFromCenter)) * 2.2 * (_timeOffset > 0.6 ? 1 : 0));

    final windSpd = widget.windStream.speedKmh *
        (1.0 + (elev / 500.0) * 0.4 + (ny - 0.5) * 0.2);

    setState(() {
      _selectedProbe = MicroclimateProbe(
        position: localPos,
        normalizedX: nx,
        normalizedY: ny,
        temperatureC: simulatedTemp,
        rainRateMmH: rainRate,
        windSpeedKmh: windSpd,
        elevationMeters: elev,
      );
    });
  }

  String _getTimeOffsetLabel(double val) {
    if (val < 0.15) return '-120 min';
    if (val < 0.35) return '-60 min';
    if (val < 0.45) return '-15 min';
    if (val < 0.55) return 'Live (Now)';
    if (val < 0.75) return '+30 min (Predictive)';
    if (val < 0.90) return '+60 min (Predictive)';
    return '+120 min (Predictive)';
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = HorizonTheme.of(context);
    final accent = AppColors.primaryAccent(themeMode);

    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: BoxDecoration(
        color: AppColors.getComplementaryCardColor(mode: themeMode),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Top Drag Handle & Title Bar
            Padding(
              padding: const EdgeInsets.only(top: 14, left: 20, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.radar_rounded, size: 16, color: accent),
                          const SizedBox(width: 8),
                          Text(
                            'INTERACTIVE MICROCLIMATE RADAR',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: accent,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.locationName} • 100 km Radius Corridor',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white60),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Layer Selector Strip
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: RadarLayer.values.map((layer) {
                  final isSelected = _activeLayer == layer;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      selected: isSelected,
                      showCheckmark: false,
                      avatar: Icon(
                        layer.icon,
                        size: 14,
                        color: isSelected ? Colors.black : layer.accentColor,
                      ),
                      label: Text(layer.label),
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.black : Colors.white70,
                      ),
                      selectedColor: layer.accentColor,
                      backgroundColor: Colors.white.withValues(alpha: 0.05),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected
                              ? layer.accentColor
                              : Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      onSelected: (_) {
                        HapticFeedbackHelper.selection();
                        setState(() => _activeLayer = layer);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // Main Interactive Map Canvas
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF07090E),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final size = Size(constraints.maxWidth, constraints.maxHeight);

                      return Stack(
                        children: [
                          // 2D Pan & Zoom Layer
                          GestureDetector(
                            onTapUp: (details) => _onTapCanvas(details, size),
                            child: InteractiveViewer(
                              transformationController: _transformController,
                              minScale: 0.8,
                              maxScale: 4.0,
                              child: SizedBox(
                                width: size.width,
                                height: size.height,
                                child: RepaintBoundary(
                                  child: AnimatedBuilder(
                                    animation: _animController,
                                    builder: (context, _) {
                                      return CustomPaint(
                                        painter: _InteractiveRadarMapPainter(
                                          layer: _activeLayer,
                                          progress: _animController.value,
                                          timeOffset: _timeOffset,
                                          windDirection: widget
                                              .windStream.directionDegrees,
                                          windSpeed:
                                              widget.windStream.speedKmh,
                                          isRaining: widget.condition ==
                                                  WeatherCondition.rainy ||
                                              widget.condition ==
                                                  WeatherCondition.drizzle,
                                          particles: _particles,
                                          probe: _selectedProbe,
                                        ),
                                        size: size,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Top-Left Legend & Range Badge
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: _activeLayer.accentColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${_activeLayer.label} • 100km Pan/Zoom',
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Microclimate Tap Probe Inspector Overlay
                          if (_selectedProbe != null)
                            Positioned(
                              bottom: 12,
                              left: 12,
                              right: 12,
                              child: _ProbeInspectorCard(
                                probe: _selectedProbe!,
                                speedUnit: widget.speedUnit,
                                tempUnit: widget.tempUnit,
                                onClose: () =>
                                    setState(() => _selectedProbe = null),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Time Slider & Animation Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_filled_rounded,
                      color: accent,
                      size: 28,
                    ),
                    onPressed: () {
                      HapticFeedbackHelper.selection();
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: accent,
                            inactiveTrackColor: Colors.white12,
                            thumbColor: Colors.white,
                            trackHeight: 3,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6),
                          ),
                          child: Slider(
                            value: _timeOffset,
                            onChanged: (val) {
                              HapticFeedbackHelper.selection();
                              setState(() => _timeOffset = val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getTimeOffsetLabel(_timeOffset),
                      style: TextStyle(
                        fontSize: 11,
                        color: accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ProbeInspectorCard extends StatelessWidget {
  final MicroclimateProbe probe;
  final SpeedUnit speedUnit;
  final TemperatureUnit tempUnit;
  final VoidCallback onClose;

  const _ProbeInspectorCard({
    required this.probe,
    required this.speedUnit,
    required this.tempUnit,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final tempStr = UnitConverter.formatTemperatureString(
        probe.temperatureC, tempUnit);
    final spdStr =
        UnitConverter.formatSpeedString(probe.windSpeedKmh, speedUnit);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF131722).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.twilightCyan.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.my_location_rounded,
                  size: 16, color: AppColors.twilightCyan),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'MICROCLIMATE PROBE',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.white38,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    '$tempStr • ${probe.rainRateMmH.toStringAsFixed(1)} mm/h • $spdStr',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Elevation: ${probe.elevationMeters}m MSL',
                    style: const TextStyle(fontSize: 10, color: Colors.white60),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 14, color: Colors.white54),
            onPressed: onClose,
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class _Particle {
  double x;
  double y;
  final double length;
  final double speed;
  final double opacity;

  _Particle({
    required this.x,
    required this.y,
    required this.length,
    required this.speed,
    required this.opacity,
  });
}

class _InteractiveRadarMapPainter extends CustomPainter {
  final RadarLayer layer;
  final double progress;
  final double timeOffset;
  final double windDirection;
  final double windSpeed;
  final bool isRaining;
  final List<_Particle> particles;
  final MicroclimateProbe? probe;

  _InteractiveRadarMapPainter({
    required this.layer,
    required this.progress,
    required this.timeOffset,
    required this.windDirection,
    required this.windSpeed,
    required this.isRaining,
    required this.particles,
    this.probe,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) * 0.45;

    // Draw Topographic Grid & Concentric 25/50/75/100 km Rings
    final ringPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, maxRadius * (i / 4.0), ringPaint);
    }

    // Grid cross lines
    canvas.drawLine(
        Offset(0, center.dy), Offset(size.width, center.dy), ringPaint);
    canvas.drawLine(
        Offset(center.dx, 0), Offset(center.dx, size.height), ringPaint);

    // Layer-specific renderings
    switch (layer) {
      case RadarLayer.precipitation:
        _paintPrecipitation(canvas, center, maxRadius);
        break;
      case RadarLayer.windVectors:
        _paintWindVectors(canvas, size);
        break;
      case RadarLayer.satellite:
        _paintSatelliteCover(canvas, center, maxRadius);
        break;
      case RadarLayer.stormCells:
        _paintStormCells(canvas, center, maxRadius);
        break;
    }

    // Sweep Line for Radar / Satellite
    if (layer == RadarLayer.precipitation || layer == RadarLayer.stormCells) {
      final angle = progress * 2 * pi;
      final beamEnd = Offset(center.dx + maxRadius * cos(angle),
          center.dy + maxRadius * sin(angle));

      final beamPaint = Paint()
        ..shader = SweepGradient(
          startAngle: angle - 0.4,
          endAngle: angle,
          colors: [
            Colors.transparent,
            layer.accentColor.withValues(alpha: 0.25)
          ],
        ).createShader(Rect.fromCircle(center: center, radius: maxRadius))
        ..style = PaintingStyle.fill;

      canvas.drawArc(Rect.fromCircle(center: center, radius: maxRadius),
          angle - 0.4, 0.4, true, beamPaint);

      final linePaint = Paint()
        ..color = layer.accentColor.withValues(alpha: 0.7)
        ..strokeWidth = 1.2;
      canvas.drawLine(center, beamEnd, linePaint);
    }

    // Center Location Pin
    final pinBg = Paint()..color = AppColors.honeyGold.withValues(alpha: 0.2);
    canvas.drawCircle(center, 9, pinBg);
    final pinFg = Paint()..color = AppColors.honeyGold;
    canvas.drawCircle(center, 3.5, pinFg);

    // Tap Probe Marker
    if (probe != null) {
      final probePaint = Paint()
        ..color = AppColors.twilightCyan
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8;
      canvas.drawCircle(probe!.position, 10, probePaint);
      canvas.drawLine(
        Offset(probe!.position.dx - 14, probe!.position.dy),
        Offset(probe!.position.dx + 14, probe!.position.dy),
        probePaint,
      );
      canvas.drawLine(
        Offset(probe!.position.dx, probe!.position.dy - 14),
        Offset(probe!.position.dx, probe!.position.dy + 14),
        probePaint,
      );
    }
  }

  void _paintPrecipitation(Canvas canvas, Offset center, double maxRadius) {
    final echoPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);

    final shiftX = sin(timeOffset * pi) * 35;
    final shiftY = -cos(timeOffset * pi) * 25;

    // Shower Band 1
    echoPaint.color = AppColors.twilightCyan.withValues(alpha: 0.45);
    canvas.drawCircle(
        Offset(center.dx - 45 + shiftX, center.dy - 30 + shiftY), 55, echoPaint);

    // Core Shower Cell 2 (Intense)
    echoPaint.color = AppColors.honeyGold.withValues(alpha: 0.40);
    canvas.drawCircle(
        Offset(center.dx + 40 + shiftX * 0.8, center.dy + 20 + shiftY * 0.8),
        36,
        echoPaint);

    // Rain Torrent Core
    echoPaint.color = AppColors.warmTerracotta.withValues(alpha: 0.35);
    canvas.drawCircle(
        Offset(center.dx + 35 + shiftX * 0.8, center.dy + 15 + shiftY * 0.8),
        18,
        echoPaint);
  }

  void _paintWindVectors(Canvas canvas, Size size) {
    final rad = (windDirection - 90) * pi / 180.0;
    final dx = cos(rad);
    final dy = sin(rad);
    final spdMult = (windSpeed / 12.0).clamp(0.5, 3.0);

    for (final p in particles) {
      final travel = (progress * p.speed * spdMult) % 1.0;
      final curX = ((p.x + dx * travel) % 1.0) * size.width;
      final curY = ((p.y + dy * travel) % 1.0) * size.height;

      final start = Offset(curX, curY);
      final end = Offset(curX + dx * p.length, curY + dy * p.length);

      final paint = Paint()
        ..color = AppColors.honeyGold.withValues(alpha: p.opacity * 0.7)
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(start, end, paint);
    }
  }

  void _paintSatelliteCover(Canvas canvas, Offset center, double maxRadius) {
    final satPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24)
      ..color = Colors.white.withValues(alpha: 0.22);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + sin(timeOffset * 2) * 30, center.dy),
        width: maxRadius * 1.8,
        height: maxRadius * 1.1,
      ),
      satPaint,
    );
  }

  void _paintStormCells(Canvas canvas, Offset center, double maxRadius) {
    final stormPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
      ..color = AppColors.warmTerracotta.withValues(alpha: 0.55);

    final cellPos = Offset(center.dx + 50, center.dy - 40);
    canvas.drawCircle(cellPos, 30, stormPaint);

    // Lightning Flash Transients
    if (progress > 0.8) {
      final flashPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.8)
        ..strokeWidth = 2.0;
      canvas.drawLine(
        cellPos,
        Offset(cellPos.dx + 6, cellPos.dy + 14),
        flashPaint,
      );
      canvas.drawLine(
        Offset(cellPos.dx + 6, cellPos.dy + 14),
        Offset(cellPos.dx - 4, cellPos.dy + 26),
        flashPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _InteractiveRadarMapPainter oldDelegate) => true;
}
