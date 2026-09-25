import 'package:flutter/material.dart';
import '../../core/audio/procedural_soundscape_player.dart' as core_audio;
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/haptic_feedback_util.dart';
import '../../domain/entities/daily_briefing_entity.dart';
import '../state/editorial_briefing_speaker.dart';

class DailyBriefingCard extends StatefulWidget {
  final DailyBriefingEntity briefing;
  final VoidCallback? onTap;

  const DailyBriefingCard({
    super.key,
    required this.briefing,
    this.onTap,
  });

  @override
  State<DailyBriefingCard> createState() => _DailyBriefingCardState();
}

class _DailyBriefingCardState extends State<DailyBriefingCard>
    with SingleTickerProviderStateMixin {
  bool _isPlayingSoundscape = false;
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _toggleSoundscape() {
    HapticFeedbackHelper.selection();
    final player = core_audio.ProceduralSoundscapePlayer.instance;
    setState(() {
      _isPlayingSoundscape = !_isPlayingSoundscape;
      if (_isPlayingSoundscape) {
        _waveController.repeat(reverse: true);
        final mapped = switch (widget.briefing.recommendedSoundscape) {
          SoundscapeType.gentleRain => core_audio.SoundscapeType.rainDrizzle,
          SoundscapeType.morningBirdsong =>
            core_audio.SoundscapeType.morningSongbirds,
          SoundscapeType.forestBreeze => core_audio.SoundscapeType.alpineBreeze,
          SoundscapeType.hearthEmbers =>
            core_audio.SoundscapeType.nightCampfire,
          SoundscapeType.starlitChimes =>
            core_audio.SoundscapeType.nightCampfire,
        };
        player.play(mapped);
      } else {
        _waveController.stop();
        player.pause();
      }
    });
  }

  IconData _getPeriodIcon(BriefingPeriod period) {
    switch (period) {
      case BriefingPeriod.morning:
        return Icons.wb_sunny_rounded;
      case BriefingPeriod.afternoon:
        return Icons.wb_cloudy_rounded;
      case BriefingPeriod.evening:
        return Icons.wb_twilight_rounded;
      case BriefingPeriod.night:
        return Icons.nightlight_round;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = HorizonTheme.of(context);
    final accent = AppColors.primaryAccent(themeMode);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: AppColors.cardDecoration(
          themeMode,
          accentBorder: accent.withValues(alpha: 0.18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Horizon Daily Briefing & Period Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        _getPeriodIcon(widget.briefing.period),
                        size: 15,
                        color: accent,
                      ),
                      const SizedBox(width: 8),
                      const Flexible(
                        child: Text(
                          'HORIZON DAILY BRIEFING',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white60,
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.briefing.period.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: accent,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    if (widget.onTap != null) ...[
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
            const SizedBox(height: 14),

            // Editorial Narrative Text
            Text(
              widget.briefing.narrative,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                height: 1.5,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 14),

            // Voice Broadcast & Soundscape Action Row
            Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: EditorialBriefingSpeaker.instance,
                    builder: (context, speakerState, _) {
                      final isSpeaking = speakerState.isSpeaking &&
                          !speakerState.isPaused &&
                          speakerState.currentText == widget.briefing.narrative;

                      return InkWell(
                        onTap: () {
                          HapticFeedbackHelper.selection();
                          EditorialBriefingSpeaker.instance.playBriefing(
                            widget.briefing.narrative,
                          );
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSpeaking
                                ? accent.withValues(alpha: 0.18)
                                : Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSpeaking
                                  ? accent.withValues(alpha: 0.4)
                                  : Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isSpeaking
                                    ? Icons.pause_rounded
                                    : Icons.record_voice_over_rounded,
                                size: 14,
                                color: isSpeaking ? accent : Colors.white70,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isSpeaking ? 'PAUSE VOICE' : 'LISTEN BROADCAST',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8,
                                  color: isSpeaking ? accent : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Interactive Ambient Soundscape Controller
            InkWell(
              onTap: _toggleSoundscape,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: _isPlayingSoundscape
                      ? accent.withValues(alpha: 0.12)
                      : Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isPlayingSoundscape
                        ? accent.withValues(alpha: 0.35)
                        : Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _isPlayingSoundscape
                            ? accent
                            : Colors.white.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isPlayingSoundscape
                            ? Icons.volume_up_rounded
                            : Icons.play_arrow_rounded,
                        size: 18,
                        color:
                            _isPlayingSoundscape ? Colors.black : Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.briefing.soundscapeName,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: _isPlayingSoundscape
                                      ? accent
                                      : Colors.white,
                                ),
                              ),
                              if (_isPlayingSoundscape) ...[
                                const SizedBox(width: 8),
                                _AnimatedSoundWave(
                                  controller: _waveController,
                                  color: accent,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.briefing.soundscapeDescription,
                            style: TextStyle(
                              fontSize: 11,
                              color: _isPlayingSoundscape
                                  ? Colors.white70
                                  : Colors.white38,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedSoundWave extends StatelessWidget {
  final AnimationController controller;
  final Color color;

  const _AnimatedSoundWave({
    required this.controller,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final val = controller.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _bar(6 + val * 8),
            const SizedBox(width: 2),
            _bar(12 - val * 7),
            const SizedBox(width: 2),
            _bar(8 + val * 6),
          ],
        );
      },
    );
  }

  Widget _bar(double height) {
    return Container(
      width: 2.5,
      height: height.clamp(4.0, 16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
