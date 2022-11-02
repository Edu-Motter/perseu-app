import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/services/clients/client_firebase.dart';
import 'package:perseu/src/states/foundation.dart';

class UserChatViewModel extends AppViewModel {
  final ClientFirebase clientFirebase = locator<ClientFirebase>();
  bool get isNotBusy => !isBusy;

  int get userId => session.userSession!.user.id;
  String get userEmail => session.userSession!.user.email;
  bool get isAthlete => session.userSession!.isAthlete;
  String get userName {
    if (isAthlete) {
      return session.userSession!.athlete!.name;
    }
    return session.userSession!.coach!.name;
  }

  void sendMessage(String message, int friendId) async {
    await tryExec(
      () => clientFirebase.saveMessageUserToUser(
        message: message,
        userName: userName,
        friendId: friendId,
        userSession: session.userSession!,
      ),
    );
  }
}
