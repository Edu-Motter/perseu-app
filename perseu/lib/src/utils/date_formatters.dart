import 'package:intl/intl.dart';

class DateFormatters {
  static const isoInstant = 'yyyy-MM-ddTHH:mm:ss';
  static const date = 'dd/MM/yyyy';
  static const time = 'HH:mm';

  static toTime(DateTime inputDate) {
    final DateFormat dateTimeFormatter = DateFormat(time);
    return dateTimeFormatter.format(inputDate);
  }

  static toDateString(String inputIsoInstant) {
    final DateFormat isoInstantFormatter = DateFormat(isoInstant);
    final DateFormat dateFormatter = DateFormat(date);
    final DateTime parsedDate = isoInstantFormatter.parse(inputIsoInstant);
    return dateFormatter.format(parsedDate);
  }

  static toIsoInstant(String inputDate) {
    final DateFormat dateFormatter = DateFormat(date);
    final DateFormat isoInstantFormatter = DateFormat(isoInstant);
    final DateTime parsedDate = dateFormatter.parse(inputDate);
    return isoInstantFormatter.format(parsedDate);
  }
}
