import 'package:intl/intl.dart';

const dateFormat = 'dd.MM.yyyy';

String formatDate(DateTime date) {
  return DateFormat(dateFormat).format(date);
}
