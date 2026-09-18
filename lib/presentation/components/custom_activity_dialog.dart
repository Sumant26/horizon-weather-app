import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_feedback_util.dart';
import '../../domain/entities/activity_profile.dart';

class CustomActivityDialog extends StatefulWidget {
  final Function(ActivityProfile profile) onSaved;

  const CustomActivityDialog({
    super.key,
    required this.onSaved,
  });

  static Future<void> show(
    BuildContext context, {
    required Function(ActivityProfile profile) onSaved,
  }) {
    HapticFeedbackHelper.medium();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CustomActivityDialog(onSaved: onSaved),
    );
  }

  @override
  State<CustomActivityDialog> createState() => _CustomActivityDialogState();
}

class _CustomActivityDialogState extends State<CustomActivityDialog> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Morning Jog');
  String _selectedEmoji = '🏃';
  RangeValues _tempRange = const RangeValues(12, 24);
  double _maxWind = 20.0;
  double _maxRain = 20.0;

  final List<String> _emojiOptions = [
    '🏃',
    '🚴',
    '🐕',
    '🎾',
    '🏄',
    '📸',
    '🔭',
    '🍷',
    '🛹',
    '🧘',
    '⛺',
    '⛵',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.85,
      padding: EdgeInsets.only(bottom: keyboardPadding),
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
                      color: AppColors.warmSage.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.warmSage.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: AppColors.warmSage,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CUSTOM ACTIVITY PROFILE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.8,
                            color: AppColors.warmSage.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Configure Comfort Thresholds',
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

            // Scrollable Content
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                children: [
                  // Activity Name Input
                  const Text(
                    'ACTIVITY NAME',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: Colors.white38,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E242E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                      decoration: const InputDecoration(
                        hintText: 'e.g., Trail Running, Night Photography',
                        hintStyle:
                            TextStyle(color: Colors.white38, fontSize: 13),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Emoji Icon Picker
                  const Text(
                    'SELECT ICON',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: Colors.white38,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _emojiOptions.map((emoji) {
                      final isSelected = _selectedEmoji == emoji;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedbackHelper.selection();
                          setState(() => _selectedEmoji = emoji);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.warmSage.withValues(alpha: 0.2)
                                : const Color(0xFF1E242E),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.warmSage
                                  : Colors.white.withValues(alpha: 0.08),
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Temperature Comfort Range Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'COMFORT TEMPERATURE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                          color: Colors.white38,
                        ),
                      ),
                      Text(
                        '${_tempRange.start.round()}°C – ${_tempRange.end.round()}°C',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.honeyGold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  RangeSlider(
                    values: _tempRange,
                    min: -5,
                    max: 40,
                    divisions: 45,
                    activeColor: AppColors.honeyGold,
                    inactiveColor: Colors.white12,
                    onChanged: (values) {
                      HapticFeedbackHelper.selection();
                      setState(() => _tempRange = values);
                    },
                  ),

                  const SizedBox(height: 16),

                  // Max Wind Speed Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'MAX WIND TOLERANCE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                          color: Colors.white38,
                        ),
                      ),
                      Text(
                        '${_maxWind.round()} km/h',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.twilightCyan,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Slider(
                    value: _maxWind,
                    min: 5,
                    max: 60,
                    divisions: 55,
                    activeColor: AppColors.twilightCyan,
                    inactiveColor: Colors.white12,
                    onChanged: (val) {
                      HapticFeedbackHelper.selection();
                      setState(() => _maxWind = val);
                    },
                  ),

                  const SizedBox(height: 16),

                  // Max Precipitation Probability
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'MAX RAIN PROBABILITY',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                          color: Colors.white38,
                        ),
                      ),
                      Text(
                        '${_maxRain.round()}%',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.warmSage,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Slider(
                    value: _maxRain,
                    min: 0,
                    max: 80,
                    divisions: 16,
                    activeColor: AppColors.warmSage,
                    inactiveColor: Colors.white12,
                    onChanged: (val) {
                      HapticFeedbackHelper.selection();
                      setState(() => _maxRain = val);
                    },
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Save Action Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ElevatedButton.icon(
                onPressed: () {
                  final name = _nameController.text.trim().isEmpty
                      ? 'Custom Activity'
                      : _nameController.text.trim();
                  final profile = ActivityProfile(
                    id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                    name: name,
                    icon: _selectedEmoji,
                    minTemp: _tempRange.start,
                    maxTemp: _tempRange.end,
                    maxWindSpeed: _maxWind,
                    maxPrecipitationProb: _maxRain.round(),
                    isCustom: true,
                  );
                  HapticFeedbackHelper.medium();
                  widget.onSaved(profile);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check_circle_outline_rounded,
                    color: Color(0xFF0F1115)),
                label: const Text(
                  'Save Activity Profile',
                  style: TextStyle(
                    color: Color(0xFF0F1115),
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.honeyGold,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
