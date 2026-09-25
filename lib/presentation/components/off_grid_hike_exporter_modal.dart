import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/export/exporter_bridge.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/haptic_feedback_util.dart';
import '../../core/utils/unit_converter.dart';
import '../../domain/entities/hike_dossier_entity.dart';
import '../../domain/entities/weather_entity.dart';

class OffGridHikeExporterModal extends StatelessWidget {
  final WeatherEntity weather;
  final TemperatureUnit tempUnit;

  const OffGridHikeExporterModal({
    super.key,
    required this.weather,
    required this.tempUnit,
  });

  static void show(
    BuildContext context, {
    required WeatherEntity weather,
    required TemperatureUnit tempUnit,
  }) {
    HapticFeedbackHelper.selection();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => OffGridHikeExporterModal(
        weather: weather,
        tempUnit: tempUnit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = HorizonTheme.of(context);
    final accent = AppColors.primaryAccent(themeMode);
    final dossier = HikeDossierEntity.fromWeather(weather, tempUnit: tempUnit);

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
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
            // Drag Handle & Title
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
                          const Text('🎒', style: TextStyle(fontSize: 15)),
                          const SizedBox(width: 8),
                          Text(
                            'OFF-GRID EXPEDITION DOSSIER',
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
                        'Printable 7-Day Matrix for Zero-Reception Hikes',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.close_rounded, color: Colors.white60),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Scrollable Dossier Preview Card
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dossier.locationName.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.honeyGold.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'OFF-GRID READY',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.honeyGold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Current Condition & Safety Corridor
                      Text(
                        dossier.conditionSummary,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          height: 1.5,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 14),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SAFETY CORRIDOR & PRESSURE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: accent,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dossier.safetyAdvisory,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Barometric status: ${dossier.barometricTrend}',
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.white60),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 7-Day Spectrum Preview
                      const Text(
                        '7-DAY TRAIL FORECAST MATRIX',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white38,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),

                      ...dossier.forecast7Day.map((day) {
                        final minStr = UnitConverter.formatTemperatureString(
                            day.minTemp, tempUnit);
                        final maxStr = UnitConverter.formatTemperatureString(
                            day.maxTemp, tempUnit);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormatter.formatDayOfWeek(day.date),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                day.condition.displayName,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: Colors.white60,
                                ),
                              ),
                              Text(
                                '$minStr / $maxStr • UV ${day.maxUvIndex.round()}',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: accent,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 16),

                      // Solar Corridor
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.honeyGold.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.honeyGold.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text('🌅 FIRST SUNRISE',
                                    style: TextStyle(
                                        fontSize: 9.5, color: Colors.white60)),
                                const SizedBox(height: 2),
                                Text(
                                  dossier.sunriseTime,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text('🌇 LAST SUNSET',
                                    style: TextStyle(
                                        fontSize: 9.5, color: Colors.white60)),
                                const SizedBox(height: 2),
                                Text(
                                  dossier.sunsetTime,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Gear Checklist Preview
                      const Text(
                        'EXPEDITION PACKLIST',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white38,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),

                      ...dossier.recommendedGear.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Icon(Icons.check_box_outline_blank,
                                  size: 14,
                                  color: accent.withValues(alpha: 0.7)),
                              const SizedBox(width: 8),
                              Text(
                                item,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Action Buttons Strip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Print / Save PDF
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        HapticFeedbackHelper.selection();
                        final html = dossier.toHtmlDocument(tempUnit);
                        printOrSaveDossierReport(
                          'Horizon Dossier - ${dossier.locationName}',
                          html,
                        );
                      },
                      icon: const Icon(Icons.print_rounded, size: 16),
                      label: const Text('PRINT / PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Download Markdown
                  Expanded(
                    flex: 3,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        HapticFeedbackHelper.selection();
                        final md = dossier.toMarkdownDocument(tempUnit);
                        final filename =
                            'horizon-dossier-${dossier.locationName.toLowerCase().replaceAll(' ', '-')}.md';
                        downloadMarkdownDossier(filename, md);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Saved markdown dossier: $filename'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.download_rounded, size: 16),
                      label: const Text('MARKDOWN'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Copy to Clipboard
                  IconButton.filledTonal(
                    onPressed: () {
                      HapticFeedbackHelper.selection();
                      final md = dossier.toMarkdownDocument(tempUnit);
                      Clipboard.setData(ClipboardData(text: md));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied offline dossier to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    tooltip: 'Copy Dossier',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(14),
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
