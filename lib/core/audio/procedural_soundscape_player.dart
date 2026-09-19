import 'dart:async';
import 'package:flutter/foundation.dart';
import 'procedural_audio_bridge.dart';

enum SoundscapeType {
  rainDrizzle(
    name: 'Gentle Rain Drizzle',
    description: 'Soft pattering raindrops with gentle overcast rumble',
    icon: '🌧️',
  ),
  alpineBreeze(
    name: 'Alpine Mountain Breeze',
    description: 'Crisp mountain wind sweeping through pine needles',
    icon: '🍃',
  ),
  morningSongbirds(
    name: 'Morning Forest Birds',
    description: 'Crisp dawn chirps and rustling leaves',
    icon: '🐦',
  ),
  nightCampfire(
    name: 'Starry Night & Hearth',
    description: 'Gentle crackling hearth and soft night crickets',
    icon: '✨',
  );

  final String name;
  final String description;
  final String icon;

  const SoundscapeType({
    required this.name,
    required this.description,
    required this.icon,
  });
}

class SoundscapeState {
  final bool isPlaying;
  final SoundscapeType currentType;
  final double volume;
  final bool autoSyncWithWeather;

  const SoundscapeState({
    this.isPlaying = false,
    this.currentType = SoundscapeType.rainDrizzle,
    this.volume = 0.7,
    this.autoSyncWithWeather = true,
  });

  SoundscapeState copyWith({
    bool? isPlaying,
    SoundscapeType? currentType,
    double? volume,
    bool? autoSyncWithWeather,
  }) {
    return SoundscapeState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentType: currentType ?? this.currentType,
      volume: volume ?? this.volume,
      autoSyncWithWeather: autoSyncWithWeather ?? this.autoSyncWithWeather,
    );
  }
}

/// Atmospheric procedural audio generator controller.
class ProceduralSoundscapePlayer extends ValueNotifier<SoundscapeState> {
  static final ProceduralSoundscapePlayer instance =
      ProceduralSoundscapePlayer._();

  Timer? _ticker;

  ProceduralSoundscapePlayer._() : super(const SoundscapeState());

  void togglePlay() {
    if (value.isPlaying) {
      pause();
    } else {
      play(value.currentType);
    }
  }

  void play(SoundscapeType type) {
    _ticker?.cancel();
    value = value.copyWith(isPlaying: true, currentType: type);
    playProceduralSound(type.name);
    setProceduralVolume(value.volume);
  }

  void pause() {
    _ticker?.cancel();
    value = value.copyWith(isPlaying: false);
    stopProceduralSound();
  }

  void setVolume(double newVolume) {
    final clamped = newVolume.clamp(0.0, 1.0);
    value = value.copyWith(volume: clamped);
    setProceduralVolume(clamped);
  }

  void toggleAutoSync() {
    value = value.copyWith(autoSyncWithWeather: !value.autoSyncWithWeather);
  }

  void syncWithCondition(String condition, bool isNight) {
    if (!value.autoSyncWithWeather) return;

    final condLower = condition.toLowerCase();
    SoundscapeType matched;
    if (condLower.contains('rain') ||
        condLower.contains('drizzle') ||
        condLower.contains('thunder')) {
      matched = SoundscapeType.rainDrizzle;
    } else if (condLower.contains('wind') || condLower.contains('breeze')) {
      matched = SoundscapeType.alpineBreeze;
    } else if (isNight) {
      matched = SoundscapeType.nightCampfire;
    } else {
      matched = SoundscapeType.morningSongbirds;
    }

    if (matched != value.currentType) {
      value = value.copyWith(currentType: matched);
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
