import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/requests/user_request.dart';
import 'package:perseu/src/services/clients/client_firebase.dart';
import 'package:perseu/src/states/foundation.dart';

class TeamChatViewModel extends AppViewModel {
  ClientFirebase clientFirebase = locator.get<ClientFirebase>();

  bool get isNotBusy => !isBusy;

  String get teamName {
    if (session.user!.isAthlete) {
      return session.user!.athlete!.team!.name;
    }
    return session.user!.coach!.team!.name;
  }

  UserRequest get user => session.user!;

  void sendMessage(String message) async {
    tryExec(() => clientFirebase.saveMessage(message, user));
    debugPrint('message:' + message);
    notifyListeners();
  }
}