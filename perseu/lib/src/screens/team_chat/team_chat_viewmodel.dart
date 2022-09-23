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

class CustomClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Path path = Path();
    // path.moveTo(0, 0);
    // path.lineTo(0, size.height);
    // path.lineTo(size.width * 0.75, size.height);
    // path.lineTo(size.width * 0.75, size.height * 0.3);
    // path.lineTo(size.width, 0);

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width - 25, size.height);
    path.lineTo(size.width - 25, size.height - 25);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
