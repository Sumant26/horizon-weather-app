import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class LocationPageIndicator extends StatelessWidget {
  final int count;
  final int activeIndex;
  final ValueChanged<int> onPageSelected;

  const LocationPageIndicator({
    super.key,
    required this.count,
    required this.activeIndex,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return GestureDetector(
          onTap: () => onPageSelected(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 4,
            width: isActive ? 18 : 6,
            decoration: BoxDecoration(
              color: isActive ? AppColors.honeyGold : Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
