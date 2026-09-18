import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String formatHour(DateTime dt) {
    return DateFormat('h a').format(dt); // e.g. 3 PM
  }

  static String format24Hour(DateTime dt) {
    return DateFormat('HH:mm').format(dt); // e.g. 15:00
  }

  static String formatDayOfWeek(DateTime dt) {
    return DateFormat('EEE').format(dt); // e.g. Mon, Tue
  }

  static String formatShortDate(DateTime dt) {
    return DateFormat('MMM d').format(dt); // e.g. Oct 14
  }

  static String formatRelativeUpdated(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }
}
