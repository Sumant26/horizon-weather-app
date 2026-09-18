import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/unit_converter.dart';
import '../../domain/entities/weather_entity.dart';
import 'share_story_modal.dart';

/// Data structure modeling the deep-dive content for a specific weather card.
class CardDetailContent {
  final String title;
  final String category;
  final IconData icon;
  final Color accentColor;
  final String heroValue;
  final String heroSubtitle;
  final List<DetailMetricItem> metrics;
  final String meteorologicalContext;
  final List<String> practicalTakeaways;
  final String shareableSummary;

  const CardDetailContent({
    required this.title,
    required this.category,
    required this.icon,
    required this.accentColor,
    required this.heroValue,
    required this.heroSubtitle,
    required this.metrics,
    required this.meteorologicalContext,
    required this.practicalTakeaways,
    required this.shareableSummary,
  });
}

class DetailMetricItem {
  final String label;
  final String value;
  final String? subtitle;
  final IconData icon;

  const DetailMetricItem({
    required this.label,
    required this.value,
    this.subtitle,
    required this.icon,
  });
}

/// A bottom sheet modal displaying deep-dive analysis and sharing tools for any weather card.
class CardDetailModal extends StatefulWidget {
  final CardDetailContent content;
  final WeatherEntity weather;
  final TemperatureUnit unit;

  const CardDetailModal({
    super.key,
    required this.content,
    required this.weather,
    required this.unit,
  });

  static Future<void> show({
    required BuildContext context,
    required CardDetailContent content,
    required WeatherEntity weather,
    required TemperatureUnit unit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CardDetailModal(
        content: content,
        weather: weather,
        unit: unit,
      ),
    );
  }

  @override
  State<CardDetailModal> createState() => _CardDetailModalState();
}

class _CardDetailModalState extends State<CardDetailModal> {
  bool _copied = false;
  Timer? _copyTimer;

  @override
  void dispose() {
    _copyTimer?.cancel();
    super.dispose();
  }

  void _copyToClipboard() {
    final buffer = StringBuffer();
    buffer.writeln('【 ${widget.content.title.toUpperCase()} 】');
    buffer.writeln('Location: ${widget.weather.location.name}');
    buffer.writeln(
        'Time: ${DateFormatter.formatShortDate(widget.weather.timestamp)}');
    buffer.writeln('Metric Summary: ${widget.content.heroValue}');
    buffer.writeln();
    buffer.writeln('Key Metrics:');
    for (final m in widget.content.metrics) {
      buffer.writeln(
          '  • ${m.label}: ${m.value}${m.subtitle != null ? " (${m.subtitle})" : ""}');
    }
    buffer.writeln();
    buffer.writeln('Atmospheric Breakdown:');
    buffer.writeln(widget.content.meteorologicalContext);
    buffer.writeln();
    buffer.writeln('Practical Takeaways:');
    for (final tip in widget.content.practicalTakeaways) {
      buffer.writeln('  ✓ $tip');
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    setState(() => _copied = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied ${widget.content.title} breakdown to clipboard!'),
        backgroundColor: const Color(0xFF232B3E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );

    _copyTimer?.cancel();
    _copyTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.content;
    final accent = content.accentColor;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Container(
      height: screenHeight * 0.88,
      decoration: const BoxDecoration(
        color: Color(0xFF14171F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: Colors.white12, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Modal Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: accent.withValues(alpha: 0.3)),
                      ),
                      child: Icon(content.icon, size: 18, color: accent),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            content.category.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              color: accent,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            content.title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: AppColors.softLinen,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded,
                    size: 20, color: Colors.white38),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white10, height: 1),

          // Scrollable Body Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                // Hero Highlight Box
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        accent.withValues(alpha: 0.14),
                        Colors.white.withValues(alpha: 0.02),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: accent.withValues(alpha: 0.25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.heroValue,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        content.heroSubtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          height: 1.4,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Key Metrics Grid
                if (content.metrics.isNotEmpty) ...[
                  const Text(
                    'PRECISION PARAMETERS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: Colors.white38,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.1,
                    ),
                    itemCount: content.metrics.length,
                    itemBuilder: (context, index) {
                      final metric = content.metrics[index];
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.06)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Icon(metric.icon,
                                    size: 13,
                                    color: accent.withValues(alpha: 0.8)),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    metric.label,
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white38,
                                      letterSpacing: 0.8,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              metric.value,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.softLinen,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (metric.subtitle != null) ...[
                              const SizedBox(height: 1),
                              Text(
                                metric.subtitle!,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontWeight: FontWeight.w300,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],

                // Meteorological Deep Dive Context
                const Text(
                  'ATMOSPHERIC ANALYSIS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    color: Colors.white38,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.02),
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Text(
                    content.meteorologicalContext,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      height: 1.5,
                      color: Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Practical Takeaways
                if (content.practicalTakeaways.isNotEmpty) ...[
                  const Text(
                    'PRACTICAL RECOMMENDATIONS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: Colors.white38,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...content.practicalTakeaways.map(
                    (tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Icon(Icons.check_circle_outline_rounded,
                                size: 14, color: AppColors.warmSage),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              tip,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                                height: 1.35,
                                color: AppColors.softLinen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Bottom Actions: Copy & Share
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _copyToClipboard,
                  icon: Icon(_copied ? Icons.check_rounded : Icons.copy_rounded,
                      size: 16),
                  label: Text(_copied ? 'Copied Details' : 'Copy Insight'),
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
                    ShareStoryModal.show(context, widget.weather, widget.unit);
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
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
