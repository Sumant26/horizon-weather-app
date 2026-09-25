// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:js_interop';

@JS('window.horizonNotifications.requestPermission')
external void _jsRequestPermission(JSFunction? callback);

@JS('window.horizonNotifications.showNotification')
external JSBoolean _jsShowNotification(
  JSString title,
  JSString body,
  JSString? tag,
);

void requestWebNotificationPermission(void Function(String status)? callback) {
  try {
    final cb = callback != null
        ? ((JSString perm) => callback(perm.toDart)).toJS
        : null;
    _jsRequestPermission(cb);
  } catch (_) {
    callback?.call('denied');
  }
}

bool showWebNotification({
  required String title,
  required String body,
  String? tag,
}) {
  try {
    final res = _jsShowNotification(title.toJS, body.toJS, tag?.toJS);
    return res.toDart;
  } catch (_) {
    return false;
  }
}
