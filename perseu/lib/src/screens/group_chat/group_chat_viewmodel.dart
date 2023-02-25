import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/services/clients/client_firebase.dart';
import 'package:perseu/src/states/foundation.dart';

class GroupChatViewModel extends AppViewModel {
  final ClientFirebase clientFirebase = locator<ClientFirebase>();
  bool get isNotBusy => !isBusy;

  int get userId => session.userSession!.user.id;
  int get teamId => session.userSession!.team!.id;

  String get userEmail => session.userSession!.user.email;
  bool get isAthlete => session.userSession!.isAthlete;
  String get userName {
    if (isAthlete) {
      return session.userSession!.athlete!.name;
    }
    return session.userSession!.coach!.name;
  }

  Stream<QuerySnapshot> getMessages(int groupId) =>
      clientFirebase.getGroupMessages(groupId: groupId, teamId: teamId);

  void sendMessage(String message, int groupId) async {
    await tryExec(
      () => clientFirebase.saveMessageGroup(
        message: message,
        groupId: groupId,
        session: session.userSession!,
      ),
    );
  }
}
