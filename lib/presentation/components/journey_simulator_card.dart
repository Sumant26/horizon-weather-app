import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/unit_converter.dart';
import '../../domain/entities/journey_entity.dart';
import '../../domain/entities/weather_condition.dart';

class JourneySimulatorCard extends StatefulWidget {
  final JourneyEntity journey;
  final TemperatureUnit tempUnit;
  final SpeedUnit speedUnit;
  final VoidCallback? onTap;

  const JourneySimulatorCard({
    super.key,
    required this.journey,
    required this.tempUnit,
    required this.speedUnit,
    this.onTap,
  });

  @override
  State<JourneySimulatorCard> createState() => _JourneySimulatorCardState();
}

class _JourneySimulatorCardState extends State<JourneySimulatorCard> {
  late String _selectedOrigin;
  late String _selectedDestination;

  final List<String> _sampleNodes = const [
    'Shivajinagar Node',
    'Baner Hills',
    'Hinjawadi Tech Park',
    'Koregaon Park',
  ];

  @override
  void initState() {
    super.initState();
    _selectedOrigin = widget.journey.originNode;
    _selectedDestination = _sampleNodes.firstWhere(
      (n) => n != _selectedOrigin,
      orElse: () => 'Baner Hills',
    );
  }

  Color _getSafetyColor(TravelSafetyTier tier) {
    switch (tier) {
      case TravelSafetyTier.optimal:
        return AppColors.warmSage;
      case TravelSafetyTier.cautious:
        return AppColors.softAmber;
      case TravelSafetyTier.severe:
        return AppColors.warmTerracotta;
    }
  }

  IconData _getWeatherIcon(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.rainy:
      case WeatherCondition.drizzle:
        return Icons.water_drop_rounded;
      case WeatherCondition.thunderstorm:
        return Icons.thunderstorm_rounded;
      case WeatherCondition.clearDay:
        return Icons.wb_sunny_rounded;
      case WeatherCondition.clearNight:
        return Icons.nightlight_round;
      case WeatherCondition.extremeHeat:
        return Icons.local_fire_department_rounded;
      default:
        return Icons.cloud_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = HorizonTheme.of(context);
    final safetyColor = _getSafetyColor(widget.journey.safetyTier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: AppColors.cardDecoration(
        themeMode,
        accentBorder: safetyColor.withValues(alpha: 0.16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Horizon Journey Commute Planner
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.directions_car_rounded,
                          size: 15, color: AppColors.softAmber),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'HORIZON JOURNEY',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white60,
                            letterSpacing: 1.2,
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
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: safetyColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'SAFETY ${widget.journey.safetyScore}/100',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: safetyColor,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
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
          const SizedBox(height: 14),

          // Route Node Selector Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ORIGIN',
                        style: TextStyle(
                            fontSize: 9,
                            color: Colors.white38,
                            letterSpacing: 1.0),
                      ),
                      Text(
                        _selectedOrigin,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(Icons.arrow_forward_rounded,
                      size: 16, color: AppColors.softAmber),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'DESTINATION',
                        style: TextStyle(
                            fontSize: 9,
                            color: Colors.white38,
                            letterSpacing: 1.0),
                      ),
                      DropdownButton<String>(
                        value: _selectedDestination,
                        isDense: true,
                        isExpanded: true,
                        underline: const SizedBox.shrink(),
                        alignment: Alignment.centerRight,
                        dropdownColor: const Color(0xFF1B1917),
                        icon: const Icon(Icons.arrow_drop_down,
                            size: 16, color: Colors.white60),
                        items: _sampleNodes.map((node) {
                          return DropdownMenuItem(
                            value: node,
                            alignment: Alignment.centerRight,
                            child: Text(
                              node,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedDestination = val);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Waypoints Step Timeline
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.journey.waypoints.map((wp) {
              final tempStr = UnitConverter.formatTemperatureString(
                  wp.temperature, widget.tempUnit);
              final isRainy = wp.rainProbability > 40;

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        wp.timeOffset,
                        style: const TextStyle(
                            fontSize: 10, color: Colors.white54),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        _getWeatherIcon(wp.condition),
                        size: 16,
                        color: isRainy
                            ? AppColors.twilightCyan
                            : AppColors.softAmber,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tempStr,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${wp.rainProbability.toInt()}% rain',
                        style: TextStyle(
                          fontSize: 9,
                          color:
                              isRainy ? AppColors.twilightCyan : Colors.white38,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Actionable Commute Safety Advisory Text
          Text(
            widget.journey.safetySummary,
            style: const TextStyle(
                fontSize: 12, color: Colors.white70, height: 1.35),
          ),
        ],
      ),
    );
  }
}
