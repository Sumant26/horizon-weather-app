import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/location_entity.dart';
import 'about_horizon_dialog.dart';

class WeatherHeader extends StatelessWidget {
  final LocationEntity location;
  final bool isFromCache;
  final DateTime timestamp;
  final int activeTriggerCount;
  final VoidCallback onOpenLocationSearch;
  final VoidCallback onOpenSavedLocations;
  final VoidCallback onOpenSoundscape;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenShareStory;
  final VoidCallback onOpenSmartTriggers;
  final VoidCallback onRefresh;

  const WeatherHeader({
    super.key,
    required this.location,
    required this.isFromCache,
    required this.timestamp,
    this.activeTriggerCount = 0,
    required this.onOpenLocationSearch,
    required this.onOpenSavedLocations,
    required this.onOpenSoundscape,
    required this.onOpenSettings,
    required this.onOpenShareStory,
    required this.onOpenSmartTriggers,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // App Logo Icon
        GestureDetector(
          onTap: () => AboutHorizonDialog.show(context),
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              boxShadow: [
                BoxShadow(
                  color: AppColors.honeyGold.withValues(alpha: 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.asset(
                'assets/images/app_logo.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF1E242E),
                  child: const Icon(Icons.wb_sunny_rounded,
                      color: AppColors.honeyGold, size: 20),
                ),
              ),
            ),
          ),
        ),
        // Location Selector Header
        Expanded(
          child: GestureDetector(
            onTap: onOpenSavedLocations,
            behavior: HitTestBehavior.opaque,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 2,
                  children: [
                    Text(
                      location.isCurrentLocation
                          ? 'CURRENT LIVE NODE'
                          : 'HORIZON NODE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: location.isCurrentLocation
                            ? AppColors.twilightCyan
                            : Colors.white38,
                        letterSpacing: 1.6,
                      ),
                    ),
                    if (location.isCurrentLocation)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: AppColors.twilightCyan.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'LIVE GPS',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.twilightCyan,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    if (isFromCache)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: AppColors.softAmber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Cached • ${DateFormatter.formatRelativeUpdated(timestamp)}',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: AppColors.softAmber,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        location.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: AppColors.softLinen,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        color: Colors.white38, size: 18),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Action Buttons
        Flexible(
          flex: 0,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(6),
                  constraints:
                      const BoxConstraints(minWidth: 34, minHeight: 34),
                  icon: const Icon(Icons.graphic_eq_rounded,
                      color: AppColors.honeyGold, size: 18),
                  tooltip: 'Atmospheric Soundscapes',
                  onPressed: onOpenSoundscape,
                ),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.all(6),
                      constraints:
                          const BoxConstraints(minWidth: 34, minHeight: 34),
                      icon: const Icon(Icons.notifications_outlined,
                          color: Colors.white60, size: 18),
                      tooltip: 'Proactive Intelligence',
                      onPressed: onOpenSmartTriggers,
                    ),
                    if (activeTriggerCount > 0)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppColors.softAmber,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(6),
                  constraints:
                      const BoxConstraints(minWidth: 34, minHeight: 34),
                  icon: const Icon(Icons.share_outlined,
                      color: Colors.white60, size: 17),
                  tooltip: 'Share Snapshot',
                  onPressed: onOpenShareStory,
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(6),
                  constraints:
                      const BoxConstraints(minWidth: 34, minHeight: 34),
                  icon: const Icon(Icons.tune_rounded,
                      color: Colors.white60, size: 18),
                  tooltip: 'Settings & Units',
                  onPressed: onOpenSettings,
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(6),
                  constraints:
                      const BoxConstraints(minWidth: 34, minHeight: 34),
                  icon: const Icon(Icons.refresh_rounded,
                      color: Colors.white60, size: 18),
                  tooltip: 'Refresh Forecast',
                  onPressed: onRefresh,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
