import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/weather_condition.dart';

class AtmosphericCanvasBackground extends StatefulWidget {
  final WeatherCondition? condition;
  final VisualThemeMode themeMode;
  final Widget child;

  const AtmosphericCanvasBackground({
    super.key,
    required this.condition,
    this.themeMode = VisualThemeMode.cozyWarm,
    required this.child,
  });

  @override
  State<AtmosphericCanvasBackground> createState() =>
      _AtmosphericCanvasBackgroundState();
}

class _AtmosphericCanvasBackgroundState
    extends State<AtmosphericCanvasBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _initParticles();
  }

  void _initParticles() {
    _particles.clear();
    for (int i = 0; i < 40; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 2.5 + 1.0,
          speed: _random.nextDouble() * 0.3 + 0.1,
          opacity: _random.nextDouble() * 0.4 + 0.1,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Color> _computeDynamicGradient(
    WeatherCondition? condition,
    VisualThemeMode themeMode,
  ) {
    if (themeMode == VisualThemeMode.oledMinimalist) {
      return AppColors.oledGradient;
    }

    if (themeMode == VisualThemeMode.slateAtmosphere) {
      switch (condition) {
        case WeatherCondition.clearNight:
        case WeatherCondition.partlyCloudyNight:
          return AppColors.slateNightGradient;
        case WeatherCondition.rainy:
        case WeatherCondition.drizzle:
        case WeatherCondition.thunderstorm:
          return AppColors.slateRainGradient;
        case WeatherCondition.overcast:
        case WeatherCondition.foggy:
        case WeatherCondition.snowy:
          return AppColors.slateOvercastGradient;
        case WeatherCondition.extremeHeat:
        case WeatherCondition.clearDay:
        case WeatherCondition.partlyCloudyDay:
        default:
          return AppColors.slateClearDayGradient;
      }
    }

    switch (condition) {
      case WeatherCondition.clearNight:
      case WeatherCondition.partlyCloudyNight:
        return AppColors.clearNightGradient;
      case WeatherCondition.rainy:
      case WeatherCondition.drizzle:
      case WeatherCondition.thunderstorm:
        return AppColors.rainyGradient;
      case WeatherCondition.extremeHeat:
        return AppColors.warmHeatGradient;
      case WeatherCondition.overcast:
      case WeatherCondition.foggy:
      case WeatherCondition.snowy:
        return AppColors.overcastGradient;
      case WeatherCondition.clearDay:
      case WeatherCondition.partlyCloudyDay:
      default:
        return AppColors.clearDayGradient;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradient =
        _computeDynamicGradient(widget.condition, widget.themeMode);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradient,
        ),
      ),
      child: Stack(
        children: [
          // Ambient Particle Canvas wrapped in RepaintBoundary for 60/120 FPS target
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _AtmosphericPainter(
                    particles: _particles,
                    progress: _controller.value,
                    condition: widget.condition,
                    themeMode: widget.themeMode,
                  ),
                  size: Size.infinite,
                );
              },
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class _AtmosphericPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final WeatherCondition? condition;
  final VisualThemeMode themeMode;

  _AtmosphericPainter({
    required this.particles,
    required this.progress,
    required this.condition,
    required this.themeMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final isRain = condition == WeatherCondition.rainy ||
        condition == WeatherCondition.drizzle;
    final isNight = condition == WeatherCondition.clearNight ||
        condition == WeatherCondition.partlyCloudyNight;

    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      double currentY;
      double currentX = p.x * size.width;

      if (isRain) {
        currentY = ((p.y + progress * p.speed * 4) % 1.0) * size.height;
        paint.color = Colors.white.withValues(alpha: p.opacity * 0.35);
        canvas.drawLine(
          Offset(currentX, currentY),
          Offset(currentX - 1.5, currentY + 12),
          Paint()
            ..color = paint.color
            ..strokeWidth = 1.0,
        );
      } else if (isNight || themeMode == VisualThemeMode.oledMinimalist) {
        currentY = p.y * size.height;
        final twinkle = (sin(progress * 2 * pi + p.x * 10) + 1) / 2;
        paint.color = const Color(0xFFF7FAFC)
            .withValues(alpha: p.opacity * twinkle * 0.65);
        canvas.drawCircle(Offset(currentX, currentY), p.size * 0.7, paint);
      } else if (themeMode == VisualThemeMode.slateAtmosphere) {
        currentY = ((p.y - progress * p.speed * 0.5) % 1.0) * size.height;
        final sway = sin(progress * 2 * pi + p.y * 5) * 5;
        paint.color = AppColors.icyCyan.withValues(alpha: p.opacity * 0.18);
        canvas.drawCircle(Offset(currentX + sway, currentY), p.size, paint);
      } else {
        currentY = ((p.y - progress * p.speed * 0.5) % 1.0) * size.height;
        final sway = sin(progress * 2 * pi + p.y * 5) * 6;
        paint.color = AppColors.softAmber.withValues(alpha: p.opacity * 0.2);
        canvas.drawCircle(Offset(currentX + sway, currentY), p.size, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _AtmosphericPainter oldDelegate) => true;
}
