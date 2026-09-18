import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class AppLogger {
  AppLogger._();

  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.debug, message, error, stackTrace);
  }

  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.info, message, error, stackTrace);
  }

  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.warning, message, error, stackTrace);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, error, stackTrace);
  }

  static void _log(
      LogLevel level, String message, Object? error, StackTrace? stackTrace) {
    if (kReleaseMode && (level == LogLevel.debug || level == LogLevel.info)) {
      return;
    }

    final tag = switch (level) {
      LogLevel.debug => '🔍 [DEBUG]',
      LogLevel.info => 'ℹ️ [INFO]',
      LogLevel.warning => '⚠️ [WARN]',
      LogLevel.error => '🚨 [ERROR]',
    };

    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    debugPrint('$tag $timestamp - $message');
    if (error != null) {
      debugPrint('  Error: $error');
    }
    if (stackTrace != null && level == LogLevel.error) {
      debugPrint('  StackTrace: $stackTrace');
    }
  }
}
