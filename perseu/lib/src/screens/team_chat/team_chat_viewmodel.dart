import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/services/clients/client_firebase.dart';
import 'package:perseu/src/states/foundation.dart';
import 'package:perseu/src/states/session.dart';

class TeamChatViewModel extends AppViewModel {
  ClientFirebase clientFirebase = locator.get<ClientFirebase>();

  UserSession get userSession => session.userSession!;
  bool get isNotBusy => !isBusy;

  String get teamName {
    if (userSession.isWithTeam) {
      return userSession.team!.name;
    }
    return 'No team';
  }

  void sendMessage(String message) async {
    tryExec(() => clientFirebase.saveMessage(message, userSession));
    debugPrint('message:' + message);
    notifyListeners();
  }
}