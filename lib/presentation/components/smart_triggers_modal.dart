import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/smart_trigger_entity.dart';

class SmartTriggersModal extends StatefulWidget {
  final SmartTriggerEntity smartTriggers;

  const SmartTriggersModal({
    super.key,
    required this.smartTriggers,
  });

  static Future<void> show(
      BuildContext context, SmartTriggerEntity smartTriggers) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SmartTriggersModal(smartTriggers: smartTriggers),
    );
  }

  @override
  State<SmartTriggersModal> createState() => _SmartTriggersModalState();
}

class _SmartTriggersModalState extends State<SmartTriggersModal> {
  late List<SmartTriggerItem> _triggers;

  @override
  void initState() {
    super.initState();
    _triggers = List.from(widget.smartTriggers.triggers);
  }

  void _toggleTrigger(int index) {
    setState(() {
      _triggers[index] =
          _triggers[index].copyWith(isEnabled: !_triggers[index].isEnabled);
    });
  }

  IconData _getCategoryIcon(TriggerCategory category) {
    switch (category) {
      case TriggerCategory.rainOnset:
        return Icons.water_drop_rounded;
      case TriggerCategory.barometricDrop:
        return Icons.speed_rounded;
      case TriggerCategory.goldenHour:
        return Icons.camera_alt_rounded;
      case TriggerCategory.solarUv:
        return Icons.wb_sunny_rounded;
    }
  }

  Color _getCategoryColor(TriggerCategory category) {
    switch (category) {
      case TriggerCategory.rainOnset:
        return AppColors.twilightCyan;
      case TriggerCategory.barometricDrop:
        return AppColors.warmTerracotta;
      case TriggerCategory.goldenHour:
        return AppColors.honeyGold;
      case TriggerCategory.solarUv:
        return AppColors.softAmber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = HorizonTheme.of(context);
    final accent = AppColors.primaryAccent(themeMode);

    final sheetBg = switch (themeMode) {
      VisualThemeMode.oledMinimalist => const Color(0xFF0A0A0A),
      VisualThemeMode.slateAtmosphere => const Color(0xFF0F172A),
      VisualThemeMode.nordicPine => const Color(0xFF0B1412),
      VisualThemeMode.cozyWarm => const Color(0xFF1C1713),
    };

    final borderColor = switch (themeMode) {
      VisualThemeMode.oledMinimalist => const Color(0xFF262626),
      VisualThemeMode.slateAtmosphere => const Color(0xFF334155),
      VisualThemeMode.nordicPine => AppColors.warmSage.withValues(alpha: 0.2),
      VisualThemeMode.cozyWarm => AppColors.honeyGold.withValues(alpha: 0.18),
    };

    return Container(
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: borderColor, width: 1.0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
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
          const SizedBox(height: 20),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'PROACTIVE MICROCLIMATE TRIGGERS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.8,
                    color: Colors.white60,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_triggers.where((t) => t.isTriggered && t.isEnabled).length} ACTIVE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Triggers List
          ..._triggers.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final catColor = _getCategoryColor(item.category);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: item.isTriggered && item.isEnabled
                    ? catColor.withValues(alpha: 0.08)
                    : Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: item.isTriggered && item.isEnabled
                      ? catColor.withValues(alpha: 0.28)
                      : Colors.white.withValues(alpha: 0.06),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getCategoryIcon(item.category),
                      size: 18,
                      color: catColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: item.isTriggered
                                    ? catColor.withValues(alpha: 0.2)
                                    : Colors.white10,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.timestampSummary,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  color: item.isTriggered
                                      ? catColor
                                      : Colors.white54,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.message,
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
                  const SizedBox(width: 8),
                  Switch.adaptive(
                    value: item.isEnabled,
                    activeTrackColor: catColor.withValues(alpha: 0.45),
                    activeThumbColor: catColor,
                    onChanged: (_) => _toggleTrigger(idx),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
