import 'package:intl/intl.dart';

class DateFormatters {
  static const isoInstant = 'yyyy-MM-ddTHH:mm:ss';
  static const date = 'dd/MM/yyyy';
  static const time = 'HH:mm';
  static const dateTime = 'HH:mm - dd/MM/yyyy';

  static String toTime(DateTime inputDate) {
    final DateFormat dateTimeFormatter = DateFormat(time);
    return dateTimeFormatter.format(inputDate.toLocal());
  }

  static String toDateString(String inputIsoInstant) {
    final DateFormat isoInstantFormatter = DateFormat(isoInstant);
    final DateFormat dateFormatter = DateFormat(date);
    final DateTime parsedDate = isoInstantFormatter.parse(inputIsoInstant, true);
    return dateFormatter.format(parsedDate.toLocal());
  }

  static String toDateTimeString(String inputIsoInstant) {
    final DateFormat isoInstantFormatter = DateFormat(isoInstant);
    final DateFormat dateFormatter = DateFormat(dateTime);
    final DateTime parsedDate = isoInstantFormatter.parse(inputIsoInstant, true);
    return dateFormatter.format(parsedDate.toLocal());
  }

  static String toTimeString(String inputIsoInstant) {
    final DateFormat isoInstantFormatter = DateFormat(isoInstant);
    final DateFormat timeFormatter = DateFormat(time);
    final DateTime parsedDate = isoInstantFormatter.parse(inputIsoInstant, true);
    return timeFormatter.format(parsedDate.toLocal());
  }

  static String toIsoInstant(String inputDate) {
    final DateFormat dateFormatter = DateFormat(date);
    final DateFormat isoInstantFormatter = DateFormat(isoInstant);
    final DateTime parsedDate = dateFormatter.parse(inputDate, true);
    return isoInstantFormatter.format(parsedDate);
  }

  static DateTime toDateTimeType(String inputIsoInstant) {
    final DateFormat isoInstantFormatter = DateFormat(isoInstant);
    final DateTime parsedDate = isoInstantFormatter.parse(inputIsoInstant, true);
    return parsedDate.toLocal();
  }

}
