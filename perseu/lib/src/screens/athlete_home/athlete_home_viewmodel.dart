import 'package:perseu/src/states/foundation.dart';

class AthleteHomeViewModel extends AppViewModel {

  String get userName => session.user!.name;
}