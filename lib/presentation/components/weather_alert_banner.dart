import 'package:flutter/material.dart';
import '../../domain/entities/weather_alert_entity.dart';

class WeatherAlertBanner extends StatefulWidget {
  final WeatherAlertEntity alerts;

  const WeatherAlertBanner({super.key, required this.alerts});

  @override
  State<WeatherAlertBanner> createState() => _WeatherAlertBannerState();
}

class _WeatherAlertBannerState extends State<WeatherAlertBanner> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.alerts.hasAlerts) return const SizedBox.shrink();

    final firstAlert = widget.alerts.activeAlerts.first;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: firstAlert.badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: firstAlert.badgeColor.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          ListTile(
            dense: true,
            leading:
                Icon(firstAlert.icon, color: firstAlert.badgeColor, size: 20),
            title: Text(
              firstAlert.title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: firstAlert.badgeColor,
              ),
            ),
            subtitle: Text(
              widget.alerts.activeAlerts.length > 1
                  ? '${widget.alerts.activeAlerts.length} Active Meteorological Advisories'
                  : 'Atmospheric Event Notice',
              style: const TextStyle(fontSize: 11, color: Colors.white54),
            ),
            trailing: IconButton(
              icon: Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: firstAlert.badgeColor,
                size: 20,
              ),
              onPressed: () => setState(() => _isExpanded = !_isExpanded),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 14),
              child: Column(
                children: widget.alerts.activeAlerts.map((alert) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(alert.icon, size: 16, color: alert.badgeColor),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alert.title,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: alert.badgeColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                alert.description,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white70,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
