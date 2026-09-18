import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_feedback_util.dart';

class GearChecklistWrap extends StatelessWidget {
  final List<String> recommendedGear;
  final Set<String> packedGear;
  final ValueChanged<String> onToggleItem;
  final VoidCallback? onTapHeader;

  const GearChecklistWrap({
    super.key,
    required this.recommendedGear,
    required this.packedGear,
    required this.onToggleItem,
    this.onTapHeader,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTapHeader,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'COMFORT & WARDROBE CHECKLIST',
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
                children: [
                  const Text(
                    'Tap to pack',
                    style: TextStyle(fontSize: 11, color: Colors.white30),
                  ),
                  if (onTapHeader != null) ...[
                    const SizedBox(width: 6),
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
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: recommendedGear.map((item) {
            final isPacked = packedGear.contains(item);
            return GestureDetector(
              onTap: () {
                HapticFeedbackHelper.selection();
                onToggleItem(item);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                decoration: BoxDecoration(
                  color: isPacked
                      ? AppColors.warmSage.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isPacked
                        ? AppColors.warmSage.withValues(alpha: 0.4)
                        : Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPacked
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 15,
                      color: isPacked ? AppColors.warmSage : Colors.white38,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isPacked ? FontWeight.w500 : FontWeight.w400,
                        color: isPacked ? AppColors.warmSage : Colors.white70,
                        decoration: isPacked
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: AppColors.warmSage,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
