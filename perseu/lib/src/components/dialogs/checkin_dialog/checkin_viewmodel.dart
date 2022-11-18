import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/services/clients/client_training.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

class CheckInDialogViewModel extends AppViewModel {
  ClientTraining clientTraining = locator<ClientTraining>();

  String get authToken => session.authToken!;
  int get athleteId => session.userSession!.athlete!.id;

  bool _enabled = false;
  bool get enabled => _enabled;
  setEnabled({required bool value}) {
    if (_enabled) return;
    _enabled = value;
    notifyListeners();
  }

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  Future<Result> checkIn(int trainingId) {
    final int effort = selectedIndex;
    return clientTraining.checkIn(athleteId, trainingId, effort, authToken);
  }
}
