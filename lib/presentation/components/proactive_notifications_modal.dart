import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_feedback_util.dart';
import '../../domain/entities/weather_entity.dart';

class ProactiveNotificationsModal extends StatefulWidget {
  final WeatherEntity weather;

  const ProactiveNotificationsModal({
    super.key,
    required this.weather,
  });

  static Future<void> show(BuildContext context, WeatherEntity weather) {
    HapticFeedbackHelper.medium();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ProactiveNotificationsModal(weather: weather),
    );
  }

  @override
  State<ProactiveNotificationsModal> createState() =>
      _ProactiveNotificationsModalState();
}

class _ProactiveNotificationsModalState
    extends State<ProactiveNotificationsModal> {
  bool _morningBriefingEnabled = true;
  bool _rainAlertEnabled = true;
  bool _pressureAlertEnabled = true;
  bool _activityAlertEnabled = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isWarmer = widget.weather.tempDifferenceYesterday >= 0;
    final diff =
        widget.weather.tempDifferenceYesterday.abs().toStringAsFixed(1);
    final temp = widget.weather.temperature.round();

    return Container(
      height: screenHeight * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF13171F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 30,
            offset: Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Pull handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.honeyGold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.honeyGold.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.notifications_active_rounded,
                      color: AppColors.honeyGold,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PROACTIVE INTELLIGENCE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.8,
                            color: AppColors.honeyGold.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Smart Briefings & Early Warnings',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon:
                        const Icon(Icons.close_rounded, color: Colors.white60),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ],
              ),
            ),

            // Notification Feed & Toggles
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  const Text(
                    'LIVE GLANCEABLE PREVIEWS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: Colors.white38,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Notification 1: Morning Briefing
                  _buildNotificationCard(
                    title: '☀️ 7:00 AM Morning Briefing',
                    subtitle:
                        'Today is $diff°C ${isWarmer ? 'warmer' : 'cooler'} than yesterday at $temp°C. "${widget.weather.humanSummary}"',
                    timeAgo: 'Simulated 7:00 AM',
                    accentColor: AppColors.honeyGold,
                    onTestTrigger: () => _simulateNotification(
                      '☀️ Morning Briefing',
                      'Today is $diff°C ${isWarmer ? 'warmer' : 'cooler'} than yesterday. "${widget.weather.humanSummary}"',
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Notification 2: Rain Radar Alert
                  _buildNotificationCard(
                    title: '🌧️ Rain Onset Corridor',
                    subtitle:
                        'Atmospheric moisture rising. Light drizzle expected within 20 minutes in ${widget.weather.location.name}.',
                    timeAgo: 'Live Precipitation Sensor',
                    accentColor: AppColors.twilightCyan,
                    onTestTrigger: () => _simulateNotification(
                      '🌧️ Rain Onset Alert',
                      'Showers approaching ${widget.weather.location.name}. Carry an umbrella.',
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Notification 3: Pressure & Health Alert
                  _buildNotificationCard(
                    title: '🧠 Biophilic Pressure Shift',
                    subtitle:
                        'Barometric pressure stable at 1014 hPa. Breathability index is optimal for outdoor endurance.',
                    timeAgo: 'Sensory Health Monitor',
                    accentColor: AppColors.warmSage,
                    onTestTrigger: () => _simulateNotification(
                      '🧠 Atmospheric Equilibrium',
                      'Stable air mass detected. Ideal window for outdoor exercise.',
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'ALERT CHANNELS & PREFERENCES',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: Colors.white38,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildSwitchTile(
                    title: 'Daily Morning Briefing',
                    subtitle: 'Glanceable temperature delta summary at 7:00 AM',
                    value: _morningBriefingEnabled,
                    onChanged: (val) {
                      HapticFeedbackHelper.selection();
                      setState(() => _morningBriefingEnabled = val);
                    },
                  ),
                  _buildSwitchTile(
                    title: 'Rain & Storm Onset Warnings',
                    subtitle: '15-minute advance radar precipitation alerts',
                    value: _rainAlertEnabled,
                    onChanged: (val) {
                      HapticFeedbackHelper.selection();
                      setState(() => _rainAlertEnabled = val);
                    },
                  ),
                  _buildSwitchTile(
                    title: 'Rapid Barometric Pressure Shifts',
                    subtitle:
                        'Migraine and joint discomfort sensitivity warnings',
                    value: _pressureAlertEnabled,
                    onChanged: (val) {
                      HapticFeedbackHelper.selection();
                      setState(() => _pressureAlertEnabled = val);
                    },
                  ),
                  _buildSwitchTile(
                    title: 'Optimal Activity Green Windows',
                    subtitle:
                        'Remind when outdoor conditions reach equilibrium',
                    value: _activityAlertEnabled,
                    onChanged: (val) {
                      HapticFeedbackHelper.selection();
                      setState(() => _activityAlertEnabled = val);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String subtitle,
    required String timeAgo,
    required Color accentColor,
    required VoidCallback onTestTrigger,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E242E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                timeAgo,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.4,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                HapticFeedbackHelper.light();
                onTestTrigger();
              },
              icon: Icon(Icons.send_rounded, size: 14, color: accentColor),
              label: Text(
                'Test Notification',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: accentColor.withValues(alpha: 0.1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B202B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.honeyGold,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _simulateNotification(String title, String body) {
    HapticFeedbackHelper.medium();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1E242E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.honeyGold, width: 1),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.honeyGold,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              body,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
