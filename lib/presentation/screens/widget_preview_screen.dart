import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/haptic_feedback_util.dart';
import '../../core/utils/unit_converter.dart';
import '../../domain/entities/weather_entity.dart';

class WidgetPreviewScreen extends StatefulWidget {
  final WeatherEntity weather;
  final TemperatureUnit unit;
  final VisualThemeMode initialTheme;

  const WidgetPreviewScreen({
    super.key,
    required this.weather,
    required this.unit,
    this.initialTheme = VisualThemeMode.cozyWarm,
  });

  static Future<void> show(
    BuildContext context, {
    required WeatherEntity weather,
    required TemperatureUnit unit,
    VisualThemeMode initialTheme = VisualThemeMode.cozyWarm,
  }) {
    HapticFeedbackHelper.medium();
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => WidgetPreviewScreen(
          weather: weather,
          unit: unit,
          initialTheme: initialTheme,
        ),
      ),
    );
  }

  @override
  State<WidgetPreviewScreen> createState() => _WidgetPreviewScreenState();
}

class _WidgetPreviewScreenState extends State<WidgetPreviewScreen> {
  late VisualThemeMode _selectedTheme;

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.initialTheme;
  }

  @override
  Widget build(BuildContext context) {
    final tempVal =
        UnitConverter.formatTemperature(widget.weather.temperature, widget.unit)
            .round();
    final isWarmer = widget.weather.tempDifferenceYesterday >= 0;
    final diffFormatted = (widget.unit == TemperatureUnit.fahrenheit
            ? widget.weather.tempDifferenceYesterday * 9 / 5
            : widget.weather.tempDifferenceYesterday)
        .abs()
        .toStringAsFixed(1);
    final unitSymbol = widget.unit == TemperatureUnit.celsius ? '°C' : '°F';
    final accent = AppColors.primaryAccent(_selectedTheme);

    return Scaffold(
      backgroundColor: const Color(0xFF0C0E14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WIDGET GALLERY & DESIGNER',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.8,
                color: AppColors.honeyGold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Glanceable System Templates',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Theme Selector Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'WIDGET THEME',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: Colors.white38,
                ),
              ),
              DropdownButton<VisualThemeMode>(
                value: _selectedTheme,
                dropdownColor: const Color(0xFF161B24),
                underline: const SizedBox.shrink(),
                icon: Icon(Icons.arrow_drop_down, color: accent),
                items: const [
                  DropdownMenuItem(
                    value: VisualThemeMode.cozyWarm,
                    child: Text('Cozy Warm',
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                  DropdownMenuItem(
                    value: VisualThemeMode.oledMinimalist,
                    child: Text('OLED Black',
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                  DropdownMenuItem(
                    value: VisualThemeMode.slateAtmosphere,
                    child: Text('Slate',
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                  DropdownMenuItem(
                    value: VisualThemeMode.nordicPine,
                    child: Text('Nordic Pine',
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                ],
                onChanged: (mode) {
                  if (mode != null) {
                    HapticFeedbackHelper.selection();
                    setState(() => _selectedTheme = mode);
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Widget 1: Compact 2x2 Square Widget
          _buildWidgetHeader('COMPACT 2x2 GLANCE', 'Android & iOS Quick Look'),
          Center(
            child: Container(
              width: 175,
              height: 175,
              padding: const EdgeInsets.all(14),
              decoration: _buildWidgetDecoration(_selectedTheme),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.weather.location.name,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.wb_sunny_rounded, size: 16, color: accent),
                    ],
                  ),
                  Text(
                    '$tempVal°',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w200,
                      letterSpacing: -2,
                      color: Colors.white,
                      height: 0.95,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$diffFormatted$unitSymbol ${isWarmer ? '▲ warmer' : '▼ cooler'}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Widget 2: Wide 4x2 Horizontal Widget
          _buildWidgetHeader(
              'WIDE 4x2 DASHBOARD', 'Expanded Hourly Strip & Gear'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: _buildWidgetDecoration(_selectedTheme),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.weather.location.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.softLinen,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$tempVal° • ${widget.weather.condition.displayName}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$diffFormatted$unitSymbol ${isWarmer ? '▲' : '▼'} yesterday',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: accent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(color: Colors.white10, height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    widget.weather.hourlyForecast.take(4).length,
                    (i) {
                      final h = widget.weather.hourlyForecast[i];
                      final t = UnitConverter.formatTemperature(
                              h.temperature, widget.unit)
                          .round();
                      return Column(
                        children: [
                          Text(
                            '${h.time.hour}:00',
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white38),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$t°',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Widget 3: iOS Lock Screen Capsule
          _buildWidgetHeader(
              'LOCK SCREEN CAPSULE', 'Always-On Minimalist Strip'),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white24, width: 1.2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wb_sunny_rounded,
                      size: 16, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    '$tempVal°  ${widget.weather.location.name}  •  $diffFormatted$unitSymbol ${isWarmer ? 'warmer' : 'cooler'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Widget 4: Dynamic Island Live Activity
          _buildWidgetHeader(
              'DYNAMIC ISLAND LIVE ACTIVITY', 'Atmospheric Status Pill'),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 340),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.honeyGold.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.wb_sunny_rounded,
                              size: 14, color: AppColors.honeyGold),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.weather.location.name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Text(
                                'Optimal: 10:00 AM – 12:00 PM',
                                style: TextStyle(
                                    color: AppColors.warmSage, fontSize: 10),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$tempVal°',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildWidgetHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: Colors.white38,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildWidgetDecoration(VisualThemeMode mode) {
    switch (mode) {
      case VisualThemeMode.oledMinimalist:
        return BoxDecoration(
          color: const Color(0xFF000000),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF2E2E2E), width: 1.2),
        );
      case VisualThemeMode.nordicPine:
        return BoxDecoration(
          color: const Color(0xFF0E1A17),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: AppColors.warmSage.withValues(alpha: 0.3), width: 1.2),
        );
      case VisualThemeMode.slateAtmosphere:
        return BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: AppColors.icyCyan.withValues(alpha: 0.3), width: 1.2),
        );
      case VisualThemeMode.cozyWarm:
        return BoxDecoration(
          color: const Color(0xFF201B17),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: AppColors.honeyGold.withValues(alpha: 0.3), width: 1.2),
        );
    }
  }
}
