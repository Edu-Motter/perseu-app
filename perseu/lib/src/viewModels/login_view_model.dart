import 'package:flutter/foundation.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/user_model.dart';
import 'package:perseu/src/services/http_client_perseu.dart';

class LoginViewModel extends ChangeNotifier {
  static const gif = 'assets/gifs/fitness.gif';

  String username = '';
  String password = '';

  bool _busy = false;

  final httpClientPerseu = locator<HttpClientPerseu>();

  String get getUsername => username;
  set setUsername(String value) {
    username = value;
    notifyListeners();
  }

  String get getPassword => password;
  set setPassword(String value) {
    password = value;
    notifyListeners();
  }

  bool get isBusy => _busy;

  bool get isNotBusy => !_busy;

  void login() async {
    _busy = true;
    notifyListeners();

    debugPrint('Loging in..');
    try {
      UserModel userModel =
          await httpClientPerseu.loginRequest(username, password);
      debugPrint('Welcome: ${userModel.name}');
    } catch (e) {
      debugPrint(e.toString());
    }

    _busy = false;
    notifyListeners();
  }
}
