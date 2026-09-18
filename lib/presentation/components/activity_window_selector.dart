import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/haptic_feedback_util.dart';
import '../../domain/entities/activity_entity.dart';
import 'custom_activity_dialog.dart';

class ActivityWindowSelector extends StatelessWidget {
  final OutdoorActivity selectedActivity;
  final ActivityWindowResult windowResult;
  final ValueChanged<OutdoorActivity> onActivitySelected;
  final VoidCallback? onTap;

  const ActivityWindowSelector({
    super.key,
    required this.selectedActivity,
    required this.windowResult,
    required this.onActivitySelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'OPTIMIZED ACTIVITY WINDOW',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white60,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.warmSage.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.warmSage.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      '${windowResult.comfortScore}% Equilibrium',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.warmSage,
                      ),
                    ),
                  ),
                  if (onTap != null) ...[
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
        const SizedBox(height: 12),
        // Activity Selector Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              ...OutdoorActivity.values.map((activity) {
                final isSelected = activity == selectedActivity;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedbackHelper.selection();
                      onActivitySelected(activity);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.honeyGold.withValues(alpha: 0.18)
                            : Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.honeyGold.withValues(alpha: 0.5)
                              : Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(activity.emoji,
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(
                            activity.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                              color: isSelected
                                  ? AppColors.softAmber
                                  : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedbackHelper.medium();
                    CustomActivityDialog.show(
                      context,
                      onSaved: (profile) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Custom profile "${profile.name}" created! Optimal window computed.'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.warmSage.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.warmSage.withValues(alpha: 0.35),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add_rounded,
                            size: 14, color: AppColors.warmSage),
                        SizedBox(width: 4),
                        Text(
                          'Custom',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.warmSage,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        // Computed Window Display Card
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: AppColors.cardDecoration(
              HorizonTheme.of(context),
              accentBorder: AppColors.softAmber.withValues(alpha: 0.15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.schedule_rounded,
                            size: 16, color: AppColors.softAmber),
                        const SizedBox(width: 8),
                        Text(
                          windowResult.timeRange,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.softLinen,
                          ),
                        ),
                      ],
                    ),
                    if (onTap != null)
                      Icon(
                        Icons.north_east_rounded,
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  windowResult.reasoning,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    height: 1.35,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
