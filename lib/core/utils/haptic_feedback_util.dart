import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Centralized utility for tactile haptic micro-interactions across Horizon.
/// Safely guards against web/unsupported platform errors.
class HapticFeedbackHelper {
  HapticFeedbackHelper._();

  /// Subtle click for scrubbing timeline, sliding radar time, or toggling switches.
  static Future<void> selection() async {
    if (kIsWeb) return;
    try {
      await HapticFeedback.selectionClick();
    } catch (_) {}
  }

  /// Light tactile tap for card taps, bookmark actions, and tab switches.
  static Future<void> light() async {
    if (kIsWeb) return;
    try {
      await HapticFeedback.lightImpact();
    } catch (_) {}
  }

  /// Medium impact for modal open/close, story export, or alerts.
  static Future<void> medium() async {
    if (kIsWeb) return;
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {}
  }

  /// Heavy impact for critical triggers.
  static Future<void> heavy() async {
    if (kIsWeb) return;
    try {
      await HapticFeedback.heavyImpact();
    } catch (_) {}
  }
}
