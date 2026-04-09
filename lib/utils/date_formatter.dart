import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class DateFormatter {
  // Format date to display format
  static String formatDate(DateTime date, {String? pattern}) {
    final formatter = DateFormat(pattern ?? AppConstants.displayDateFormat);
    return formatter.format(date);
  }

  // Format date time
  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat(AppConstants.displayDateTimeFormat);
    return formatter.format(dateTime);
  }

  // Parse string to DateTime
  static DateTime? parseDate(String dateString, {String? pattern}) {
    try {
      final formatter = DateFormat(pattern ?? AppConstants.dateFormat);
      return formatter.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Get time remaining string
  static String getTimeRemaining(DateTime targetDate) {
    final now = DateTime.now();
    final difference = targetDate.difference(now);

    if (difference.isNegative) {
      return 'Expired';
    }

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    if (days > 0) {
      return '$days days ${hours} hours';
    } else if (hours > 0) {
      return '$hours hours ${minutes} minutes';
    } else if (minutes > 0) {
      return '$minutes minutes';
    } else {
      return 'Less than a minute';
    }
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  // Get relative date string (Today, Tomorrow, or formatted date)
  static String getRelativeDate(DateTime date) {
    if (isToday(date)) {
      return 'Today';
    } else if (isTomorrow(date)) {
      return 'Tomorrow';
    } else {
      return formatDate(date);
    }
  }

  // Format time only
  static String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  // Get start of day
  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Get end of day
  static DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  // Format duration
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0) {
      return '$hours hr ${minutes > 0 ? '$minutes min' : ''}';
    } else {
      return '$minutes min';
    }
  }
}
