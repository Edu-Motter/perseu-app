import 'package:perseu/src/states/foundation.dart';

class AthleteHomeViewModel extends AppViewModel {

  String get athleteName => session.userSession?.athlete?.name ?? ' - - ';

  String get teamName => session.userSession?.team?.name ?? ' - - ';
}