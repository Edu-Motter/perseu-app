import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/athlete_check_dto.dart';
import 'package:perseu/src/services/clients/client_athlete.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';
import 'package:perseu/src/utils/date_formatters.dart';
import 'package:table_calendar/table_calendar.dart';

class AthleteChecksViewModel extends AppViewModel {
  bool _calendarView = true;
  bool get calendarView => _calendarView;
  void changeView() {
    _calendarView = !_calendarView;
    notifyListeners();
  }

  ClientAthlete clientAthlete = locator<ClientAthlete>();

  final kToday = DateTime.now();
  final kFirstDay = DateTime(2022, 1, 1);
  final kLastDay = DateTime(2023, 12, 31);

  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  String get authToken => session.authToken!;
  int get sessionId => session.userSession!.athlete!.id;

  List<AthleteCheckDTO> checks = [];
  List<AthleteCheckDTO> dayChecks = [];

  Future<Result<List<AthleteCheckDTO>>> getAthleteChecks(int? athleteId) async {
    Result<List<AthleteCheckDTO>> athleteChecksResult =
        await clientAthlete.getAthleteChecks(athleteId ?? sessionId, authToken);
    if (athleteChecksResult.success) checks = athleteChecksResult.data!;
    return athleteChecksResult;
  }

  List<AthleteCheckDTO> loadChecks(DateTime day) {
    List<AthleteCheckDTO> checksOfDay = [];
    for (AthleteCheckDTO check in checks) {
      final DateTime parsedDate = DateFormatters.toDateTimeType(check.date);
      if (isSameDay(parsedDate, day)) {
        checksOfDay.add(check);
      }
    }
    return checksOfDay;
  }
}
