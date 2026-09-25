// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:js_interop';

@JS('window.horizonTab.updateTab')
external void _jsUpdateTab(
  JSString title,
  JSString emoji,
  JSString tempStr,
);

void updateBrowserTab({
  required String title,
  required String emoji,
  required String tempStr,
}) {
  try {
    _jsUpdateTab(title.toJS, emoji.toJS, tempStr.toJS);
  } catch (_) {}
}
