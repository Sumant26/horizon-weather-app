import 'package:flutter/material.dart';
import '../../core/audio/procedural_soundscape_player.dart' as core_audio;
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/haptic_feedback_util.dart';
import '../../domain/entities/daily_briefing_entity.dart';
import '../state/editorial_briefing_speaker.dart';

class AudioBriefingModal extends StatefulWidget {
  final DailyBriefingEntity briefing;
  final String locationName;

  const AudioBriefingModal({
    super.key,
    required this.briefing,
    required this.locationName,
  });

  static void show(
    BuildContext context, {
    required DailyBriefingEntity briefing,
    required String locationName,
  }) {
    HapticFeedbackHelper.selection();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AudioBriefingModal(
        briefing: briefing,
        locationName: locationName,
      ),
    );
  }

  @override
  State<AudioBriefingModal> createState() => _AudioBriefingModalState();
}

class _AudioBriefingModalState extends State<AudioBriefingModal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  final EditorialBriefingSpeaker _speaker = EditorialBriefingSpeaker.instance;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    // If not already speaking, automatically start briefing
    if (!_speaker.value.isSpeaking) {
      _speaker.playBriefing(
        widget.briefing.narrative,
        locationName: widget.locationName,
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = HorizonTheme.of(context);
    final accent = AppColors.primaryAccent(themeMode);

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      decoration: BoxDecoration(
        color: AppColors.getComplementaryCardColor(mode: themeMode),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: SafeArea(
        child: ValueListenableBuilder<EditorialSpeakerState>(
          valueListenable: _speaker,
          builder: (context, speakerState, _) {
            final isSpeaking = speakerState.isSpeaking && !speakerState.isPaused;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top drag handle
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              '🎙️',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'EDITORIAL VOICE BROADCAST',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: accent,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.locationName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: Colors.white60),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Audio Visualizer Wave / Orb
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSpeaking
                          ? accent.withValues(alpha: 0.3)
                          : Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, _) {
                        final val = isSpeaking ? _pulseController.value : 0.1;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(12, (index) {
                            final barHeight = 12.0 +
                                (val * 48.0 * ((index % 3 + 1) / 3.0)) *
                                    (0.4 + 0.6 * (1.0 - (index - 6).abs() / 6.0));

                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: 4,
                              height: isSpeaking ? barHeight : 8,
                              decoration: BoxDecoration(
                                color: isSpeaking
                                    ? accent.withValues(
                                        alpha: 0.6 + 0.4 * val)
                                    : Colors.white24,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Transcript Narrative
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    widget.briefing.narrative,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      height: 1.6,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),

                // Ambient Ducking Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.graphic_eq_rounded,
                      size: 13,
                      color: accent.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isSpeaking
                          ? 'Soundscape ducked to 18% during voiceover'
                          : 'Procedural soundscape restored to standard volume',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Playback Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Stop Button
                    IconButton.filledTonal(
                      icon: const Icon(Icons.stop_rounded),
                      onPressed: () {
                        HapticFeedbackHelper.selection();
                        _speaker.stop();
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(14),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Play / Pause Main Action
                    GestureDetector(
                      onTap: () {
                        HapticFeedbackHelper.selection();
                        if (isSpeaking) {
                          _speaker.pause();
                        } else {
                          _speaker.playBriefing(
                            widget.briefing.narrative,
                            locationName: widget.locationName,
                          );
                        }
                      },
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: accent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: accent.withValues(alpha: 0.35),
                              blurRadius: 18,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          isSpeaking
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          size: 32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Soundscape Toggle
                    IconButton.filledTonal(
                      icon: const Icon(Icons.music_note_rounded),
                      onPressed: () {
                        HapticFeedbackHelper.selection();
                        core_audio.ProceduralSoundscapePlayer.instance
                            .togglePlay();
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(14),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
