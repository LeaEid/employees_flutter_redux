import 'package:intl/intl.dart';

abstract class UtilsSingleton {
  String formatDate(DateTime date, String format) {
    return DateFormat(format).format(date);
  }
}

class Utils extends UtilsSingleton {
  static final Utils _instance = Utils._internal();

  factory Utils() {
    return _instance;
  }

  Utils._internal();
}
