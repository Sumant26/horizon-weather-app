import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/haptic_feedback_util.dart';
import '../../core/utils/unit_converter.dart';
import '../../domain/entities/weather_entity.dart';

enum StoryCardTheme { cozyHearth, starryNight, goldenHour, oledBlack }

class ShareStoryModal extends StatefulWidget {
  final WeatherEntity weather;
  final TemperatureUnit unit;

  const ShareStoryModal({
    super.key,
    required this.weather,
    required this.unit,
  });

  static Future<void> show(
      BuildContext context, WeatherEntity weather, TemperatureUnit unit) {
    HapticFeedbackHelper.medium();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF161A22),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => ShareStoryModal(weather: weather, unit: unit),
    );
  }

  @override
  State<ShareStoryModal> createState() => _ShareStoryModalState();
}

class _ShareStoryModalState extends State<ShareStoryModal> {
  StoryCardTheme _selectedTheme = StoryCardTheme.cozyHearth;
  bool _copied = false;

  List<Color> _getThemeGradient(StoryCardTheme theme) {
    switch (theme) {
      case StoryCardTheme.cozyHearth:
        return const [Color(0xFF2C221C), Color(0xFF141210)];
      case StoryCardTheme.starryNight:
        return const [Color(0xFF0F172A), Color(0xFF080C14)];
      case StoryCardTheme.goldenHour:
        return const [Color(0xFF381F17), Color(0xFF1D0E0A)];
      case StoryCardTheme.oledBlack:
        return const [Color(0xFF000000), Color(0xFF0A0C10)];
    }
  }

  Color _getThemeAccent(StoryCardTheme theme) {
    switch (theme) {
      case StoryCardTheme.cozyHearth:
        return AppColors.honeyGold;
      case StoryCardTheme.starryNight:
        return AppColors.twilightCyan;
      case StoryCardTheme.goldenHour:
        return AppColors.warmTerracotta;
      case StoryCardTheme.oledBlack:
        return AppColors.warmSage;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tempVal =
        UnitConverter.formatTemperature(widget.weather.temperature, widget.unit)
            .round();
    final accent = _getThemeAccent(_selectedTheme);
    final isWarmer = widget.weather.tempDifferenceYesterday >= 0;
    final diffFormatted = (widget.unit == TemperatureUnit.fahrenheit
            ? widget.weather.tempDifferenceYesterday * 9 / 5
            : widget.weather.tempDifferenceYesterday)
        .abs()
        .toStringAsFixed(1);
    final unitSymbol = widget.unit == TemperatureUnit.celsius ? '°C' : '°F';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SHARE HORIZON SNAPSHOT',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.0,
                  color: Colors.white38,
                ),
              ),
              Text(
                'Story Format (9:16)',
                style: TextStyle(fontSize: 11, color: Colors.white30),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 9:16 Story Card Preview Frame
          Center(
            child: Container(
              width: 240,
              height: 380,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _getThemeGradient(_selectedTheme),
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                    color: accent.withValues(alpha: 0.35), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Card Header
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'HORIZON NODE',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.8,
                              color: accent.withValues(alpha: 0.8),
                            ),
                          ),
                          Text(
                            DateFormatter.formatShortDate(
                                widget.weather.timestamp),
                            style: const TextStyle(
                                fontSize: 9, color: Colors.white38),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.weather.location.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: AppColors.softLinen,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  // Giant Kinetic Number & Delta
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$tempVal°',
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w200,
                          height: 0.9,
                          letterSpacing: -3,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${widget.weather.condition.displayName} • $diffFormatted$unitSymbol ${isWarmer ? 'warmer' : 'cooler'}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: accent,
                        ),
                      ),
                    ],
                  ),

                  // Cozy Human Phrase
                  Text(
                    '"${widget.weather.humanSummary}"',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      height: 1.35,
                      fontStyle: FontStyle.italic,
                      color: Colors.white70,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Watermark Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              'assets/images/app_logo.jpg',
                              width: 14,
                              height: 14,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'horizon.weather',
                            style: TextStyle(
                                fontSize: 8,
                                color: Colors.white.withValues(alpha: 0.4),
                                letterSpacing: 1.2),
                          ),
                        ],
                      ),
                      Icon(Icons.wb_twilight_rounded,
                          size: 12, color: accent.withValues(alpha: 0.5)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Theme Style Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ThemeChip(
                  label: 'Cozy Hearth',
                  isSelected: _selectedTheme == StoryCardTheme.cozyHearth,
                  color: AppColors.honeyGold,
                  onTap: () {
                    HapticFeedbackHelper.selection();
                    setState(() => _selectedTheme = StoryCardTheme.cozyHearth);
                  },
                ),
                const SizedBox(width: 8),
                _ThemeChip(
                  label: 'Starry Night',
                  isSelected: _selectedTheme == StoryCardTheme.starryNight,
                  color: AppColors.twilightCyan,
                  onTap: () {
                    HapticFeedbackHelper.selection();
                    setState(() => _selectedTheme = StoryCardTheme.starryNight);
                  },
                ),
                const SizedBox(width: 8),
                _ThemeChip(
                  label: 'Golden Hour',
                  isSelected: _selectedTheme == StoryCardTheme.goldenHour,
                  color: AppColors.warmTerracotta,
                  onTap: () {
                    HapticFeedbackHelper.selection();
                    setState(() => _selectedTheme = StoryCardTheme.goldenHour);
                  },
                ),
                const SizedBox(width: 8),
                _ThemeChip(
                  label: 'Deep OLED',
                  isSelected: _selectedTheme == StoryCardTheme.oledBlack,
                  color: AppColors.warmSage,
                  onTap: () {
                    HapticFeedbackHelper.selection();
                    setState(() => _selectedTheme = StoryCardTheme.oledBlack);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Copy / Share Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    HapticFeedbackHelper.light();
                    Clipboard.setData(
                      ClipboardData(
                        text:
                            'Horizon Weather in ${widget.weather.location.name}: $tempVal° ($diffFormatted$unitSymbol ${isWarmer ? 'warmer' : 'cooler'} than yesterday). "${widget.weather.humanSummary}"',
                      ),
                    );
                    setState(() => _copied = true);
                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) setState(() => _copied = false);
                    });
                  },
                  icon: Icon(_copied ? Icons.check_rounded : Icons.copy_rounded,
                      size: 16),
                  label: Text(_copied ? 'Copied Summary!' : 'Copy Summary'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        _copied ? AppColors.warmSage : AppColors.softAmber,
                    side: BorderSide(
                        color: _copied ? AppColors.warmSage : Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Story card snapshot generated and ready to share!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.share_rounded, size: 16),
                  label: const Text('Share Story'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.honeyGold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _ThemeChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? color : Colors.white12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? color : Colors.white60,
          ),
        ),
      ),
    );
  }
}
