// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:js_interop';

@JS('window.horizonAudio.play')
external void _jsPlay(JSString type);

@JS('window.horizonAudio.stop')
external void _jsStop();

@JS('window.horizonAudio.setVolume')
external void _jsSetVolume(JSNumber vol);

void playProceduralSound(String type) {
  try {
    _jsPlay(type.toJS);
  } catch (_) {}
}

void stopProceduralSound() {
  try {
    _jsStop();
  } catch (_) {}
}

void setProceduralVolume(double volume) {
  try {
    _jsSetVolume(volume.toJS);
  } catch (_) {}
}
