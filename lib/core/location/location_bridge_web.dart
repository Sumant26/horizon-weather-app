// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

@JS('window.horizonLocation.getCurrentCoords')
external void _jsGetCoords(JSFunction success, JSFunction error);

Future<Map<String, double>?> getBrowserCoordinates() {
  final completer = Completer<Map<String, double>?>();

  final success = ((JSString jsonStr) {
    try {
      final decoded = json.decode(jsonStr.toDart) as Map<String, dynamic>;
      final lat = (decoded['latitude'] as num?)?.toDouble();
      final lon = (decoded['longitude'] as num?)?.toDouble();
      if (lat != null && lon != null && !completer.isCompleted) {
        completer.complete({'latitude': lat, 'longitude': lon});
      }
    } catch (_) {
      if (!completer.isCompleted) completer.complete(null);
    }
  }).toJS;

  final error = ((JSAny? err) {
    if (!completer.isCompleted) completer.complete(null);
  }).toJS;

  try {
    _jsGetCoords(success, error);
  } catch (_) {
    if (!completer.isCompleted) completer.complete(null);
  }

  return completer.future.timeout(
    const Duration(seconds: 8),
    onTimeout: () => null,
  );
}
