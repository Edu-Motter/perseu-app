import 'package:perseu/src/states/foundation.dart';
import 'package:perseu/src/states/session.dart';

class AthleteDrawerViewModel extends AppViewModel {
  UserSession get userSession => session.userSession!;

  String get userName =>
      userSession.isCoach ? userSession.coach!.name : userSession.athlete!.name;

  String get userEmail => userSession.user.email;
}
