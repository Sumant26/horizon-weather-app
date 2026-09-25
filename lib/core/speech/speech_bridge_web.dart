// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:js_interop';

@JS('window.horizonSpeech.speak')
external void _jsSpeak(
  JSString text,
  JSFunction? onStart,
  JSFunction? onEnd,
  JSFunction? onError,
);

@JS('window.horizonSpeech.pause')
external void _jsPause();

@JS('window.horizonSpeech.resume')
external void _jsResume();

@JS('window.horizonSpeech.stop')
external void _jsStop();

void speakEditorialBriefing(
  String text, {
  void Function()? onStart,
  void Function()? onEnd,
  void Function(String error)? onError,
}) {
  try {
    final startCb = onStart != null ? (() => onStart()).toJS : null;
    final endCb = onEnd != null ? (() => onEnd()).toJS : null;
    final errCb =
        onError != null ? ((JSString err) => onError(err.toDart)).toJS : null;

    _jsSpeak(text.toJS, startCb, endCb, errCb);
  } catch (_) {
    onError?.call('Speech synthesis failed to execute');
  }
}

void pauseEditorialSpeech() {
  try {
    _jsPause();
  } catch (_) {}
}

void resumeEditorialSpeech() {
  try {
    _jsResume();
  } catch (_) {}
}

void stopEditorialSpeech() {
  try {
    _jsStop();
  } catch (_) {}
}
