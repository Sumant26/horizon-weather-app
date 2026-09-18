import 'package:flutter/material.dart';
import '../../core/audio/procedural_soundscape_player.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_feedback_util.dart';

class SoundscapePlayerModal extends StatelessWidget {
  const SoundscapePlayerModal({super.key});

  static Future<void> show(BuildContext context) {
    HapticFeedbackHelper.medium();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const SoundscapePlayerModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = ProceduralSoundscapePlayer.instance;
    final screenHeight = MediaQuery.of(context).size.height;

    return ValueListenableBuilder<SoundscapeState>(
      valueListenable: player,
      builder: (context, state, child) {
        return Container(
          height: screenHeight * 0.72,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                          Icons.graphic_eq_rounded,
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
                              'ATMOSPHERIC SOUNDSCAPES',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.8,
                                color:
                                    AppColors.honeyGold.withValues(alpha: 0.9),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              state.isPlaying
                                  ? 'Playing • Ambient Audio'
                                  : 'Paused',
                              style: TextStyle(
                                fontSize: 14,
                                color: state.isPlaying
                                    ? AppColors.warmSage
                                    : Colors.white60,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded,
                            color: Colors.white60),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ],
                  ),
                ),

                // Soundscape Soundwaves Animation
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.honeyGold.withValues(alpha: 0.1),
                        AppColors.warmSage.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(12, (index) {
                      final heights = [
                        14.0,
                        28.0,
                        40.0,
                        22.0,
                        36.0,
                        48.0,
                        32.0,
                        18.0,
                        42.0,
                        26.0,
                        34.0,
                        16.0
                      ];
                      final height = state.isPlaying ? heights[index] : 8.0;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: 4,
                        height: height,
                        decoration: BoxDecoration(
                          color: state.isPlaying
                              ? (index.isEven
                                  ? AppColors.honeyGold
                                  : AppColors.warmSage)
                              : Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ),

                // Soundscapes Selector
                Expanded(
                  child: ListView.separated(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: SoundscapeType.values.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final sound = SoundscapeType.values[index];
                      final isSelected = state.currentType == sound;

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            HapticFeedbackHelper.selection();
                            player.play(sound);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.honeyGold.withValues(alpha: 0.12)
                                  : const Color(0xFF1B202B),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.honeyGold.withValues(alpha: 0.5)
                                    : Colors.white.withValues(alpha: 0.06),
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  sound.icon,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sound.name,
                                        style: TextStyle(
                                          color: isSelected
                                              ? AppColors.honeyGold
                                              : Colors.white,
                                          fontSize: 15,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        sound.description,
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected && state.isPlaying)
                                  const Icon(
                                    Icons.equalizer_rounded,
                                    color: AppColors.honeyGold,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Player Controls (Play/Pause & Volume)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF161B23),
                    border: Border(
                      top: BorderSide(color: Colors.white10),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.volume_down_rounded,
                              color: Colors.white38, size: 20),
                          Expanded(
                            child: Slider(
                              value: state.volume,
                              activeColor: AppColors.honeyGold,
                              inactiveColor: Colors.white12,
                              onChanged: (val) {
                                HapticFeedbackHelper.selection();
                                player.setVolume(val);
                              },
                            ),
                          ),
                          const Icon(Icons.volume_up_rounded,
                              color: Colors.white70, size: 20),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                HapticFeedbackHelper.selection();
                                player.toggleAutoSync();
                              },
                              icon: Icon(
                                state.autoSyncWithWeather
                                    ? Icons.sync_rounded
                                    : Icons.sync_disabled_rounded,
                                size: 16,
                                color: state.autoSyncWithWeather
                                    ? AppColors.warmSage
                                    : Colors.white38,
                              ),
                              label: Text(
                                state.autoSyncWithWeather
                                    ? 'Auto-Tune On'
                                    : 'Auto-Tune Off',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: state.autoSyncWithWeather
                                      ? AppColors.warmSage
                                      : Colors.white54,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: state.autoSyncWithWeather
                                      ? AppColors.warmSage
                                          .withValues(alpha: 0.3)
                                      : Colors.white12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                HapticFeedbackHelper.medium();
                                player.togglePlay();
                              },
                              icon: Icon(
                                state.isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: const Color(0xFF0F1115),
                              ),
                              label: Text(
                                state.isPlaying ? 'Pause' : 'Play Sound',
                                style: const TextStyle(
                                  color: Color(0xFF0F1115),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.honeyGold,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
