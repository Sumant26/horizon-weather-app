import 'package:flutter/foundation.dart';
import '../../core/speech/speech_bridge.dart';

class EditorialSpeakerState {
  final bool isSpeaking;
  final bool isPaused;
  final String? currentText;
  final String? locationName;
  final String? error;

  const EditorialSpeakerState({
    this.isSpeaking = false,
    this.isPaused = false,
    this.currentText,
    this.locationName,
    this.error,
  });

  EditorialSpeakerState copyWith({
    bool? isSpeaking,
    bool? isPaused,
    String? currentText,
    String? locationName,
    String? error,
  }) {
    return EditorialSpeakerState(
      isSpeaking: isSpeaking ?? this.isSpeaking,
      isPaused: isPaused ?? this.isPaused,
      currentText: currentText ?? this.currentText,
      locationName: locationName ?? this.locationName,
      error: error,
    );
  }
}

class EditorialBriefingSpeaker extends ValueNotifier<EditorialSpeakerState> {
  static final EditorialBriefingSpeaker instance = EditorialBriefingSpeaker._();

  EditorialBriefingSpeaker._() : super(const EditorialSpeakerState());

  void playBriefing(String text, {String? locationName}) {
    if (value.isSpeaking && !value.isPaused && value.currentText == text) {
      pause();
      return;
    }
    if (value.isPaused && value.currentText == text) {
      resume();
      return;
    }

    stopEditorialSpeech();
    value = value.copyWith(
      isSpeaking: true,
      isPaused: false,
      currentText: text,
      locationName: locationName,
      error: null,
    );

    speakEditorialBriefing(
      text,
      onStart: () {
        value = value.copyWith(isSpeaking: true, isPaused: false);
      },
      onEnd: () {
        value = value.copyWith(
          isSpeaking: false,
          isPaused: false,
          currentText: null,
        );
      },
      onError: (err) {
        value = value.copyWith(
          isSpeaking: false,
          isPaused: false,
          error: err,
        );
      },
    );
  }

  void pause() {
    if (!value.isSpeaking || value.isPaused) return;
    pauseEditorialSpeech();
    value = value.copyWith(isPaused: true);
  }

  void resume() {
    if (!value.isSpeaking || !value.isPaused) return;
    resumeEditorialSpeech();
    value = value.copyWith(isPaused: false);
  }

  void stop() {
    stopEditorialSpeech();
    value = value.copyWith(
      isSpeaking: false,
      isPaused: false,
      currentText: null,
    );
  }
}
