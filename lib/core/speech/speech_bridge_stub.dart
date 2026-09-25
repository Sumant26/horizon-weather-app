void speakEditorialBriefing(
  String text, {
  void Function()? onStart,
  void Function()? onEnd,
  void Function(String error)? onError,
}) {
  onStart?.call();
  onEnd?.call();
}

void pauseEditorialSpeech() {}
void resumeEditorialSpeech() {}
void stopEditorialSpeech() {}
