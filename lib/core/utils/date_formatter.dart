// lib/core/utils/date_formatter.dart
import 'package:intl/intl.dart';

class DateFormatter {
  static String format(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      
      // If the date is today, return time
      if (date.year == now.year && date.month == now.month && date.day == now.day) {
        return DateFormat('HH:mm').format(date);
      }
      
      // If the date is in the current year, return month and day
      if (date.year == now.year) {
        return DateFormat('MMM d').format(date);
      }
      
      // Otherwise return full date
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
  
  static String formatFull(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM d, yyyy • HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }
  
  static String timeAgo(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays > 365) {
        return '${(difference.inDays / 365).floor()} year(s) ago';
      } else if (difference.inDays > 30) {
        return '${(difference.inDays / 30).floor()} month(s) ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} day(s) ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour(s) ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute(s) ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return dateString;
    }
  }
}