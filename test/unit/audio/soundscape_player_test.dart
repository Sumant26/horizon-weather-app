import 'package:flutter_test/flutter_test.dart';
import 'package:horizon/core/audio/procedural_soundscape_player.dart';

void main() {
  group('ProceduralSoundscapePlayer Engine Tests', () {
    late ProceduralSoundscapePlayer player;

    setUp(() {
      player = ProceduralSoundscapePlayer.instance;
      player.pause();
    });

    test('initial state has default volume and autoSync enabled', () {
      expect(player.value.volume, 0.7);
      expect(player.value.autoSyncWithWeather, isTrue);
      expect(player.value.isPlaying, isFalse);
    });

    test('play and pause toggle playback state accurately', () {
      player.play(SoundscapeType.alpineBreeze);
      expect(player.value.isPlaying, isTrue);
      expect(player.value.currentType, SoundscapeType.alpineBreeze);

      player.pause();
      expect(player.value.isPlaying, isFalse);
    });

    test('setVolume clamps between 0.0 and 1.0', () {
      player.setVolume(1.5);
      expect(player.value.volume, 1.0);

      player.setVolume(-0.2);
      expect(player.value.volume, 0.0);

      player.setVolume(0.45);
      expect(player.value.volume, 0.45);
    });

    test('syncWithCondition auto-matches rain, breeze, and night soundscapes',
        () {
      player.syncWithCondition('Heavy Thunderstorm Rain', false);
      expect(player.value.currentType, SoundscapeType.rainDrizzle);

      player.syncWithCondition('Fresh Alpine Breeze', false);
      expect(player.value.currentType, SoundscapeType.alpineBreeze);

      player.syncWithCondition('Clear Sky', true);
      expect(player.value.currentType, SoundscapeType.nightCampfire);

      player.syncWithCondition('Sunny Daylight', false);
      expect(player.value.currentType, SoundscapeType.morningSongbirds);
    });
  });
}
