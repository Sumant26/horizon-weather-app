void requestWebNotificationPermission(void Function(String status)? callback) {
  callback?.call('granted');
}

bool showWebNotification({
  required String title,
  required String body,
  String? tag,
}) {
  return false;
}
