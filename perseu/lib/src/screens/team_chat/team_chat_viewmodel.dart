import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/services/clients/client_firebase.dart';
import 'package:perseu/src/states/foundation.dart';
import 'package:perseu/src/states/session.dart';

class TeamChatViewModel extends AppViewModel {
  ClientFirebase clientFirebase = locator.get<ClientFirebase>();

  UserSession get userSession => session.userSession!;
  bool get isNotBusy => !isBusy;

  int get teamId => session.userSession!.team!.id;

  String get teamName {
    if (userSession.isWithTeam) {
      return userSession.team!.name;
    }
    return 'No team';
  }

  Stream<QuerySnapshot> getMessages() =>
      clientFirebase.getTeamMessages(teamId: teamId);

  void sendMessage(String message) async {
    await tryExec(() => clientFirebase.saveMessage(message, userSession));
    notifyListeners();
  }
}
