import 'package:intl/intl.dart';

class FormatUtils {
  static String formatDate(DateTime date) {
    try {
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }

  static String formatTime(String time) {
    try {
      return DateFormat('h:mm a').format(DateFormat('HH:mm').parse(time));
    } catch (e) {
      return time;
    }
  }
}
