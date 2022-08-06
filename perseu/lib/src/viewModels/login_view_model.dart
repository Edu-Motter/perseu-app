import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/requests/login_request.dart';
import 'package:perseu/src/services/clients/client_user.dart';

import '../services/foundation.dart';
import '../states/foundation.dart';

class LoginViewModel extends AppViewModel {
  static const gif = 'assets/gifs/fitness.gif';

  String username = '';
  String password = '';

  final clientPerseu = locator<ClientUser>();

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

  Future<Result<LoginRequest>> login() async {
    return tryExec(() async {
      final result = await clientPerseu.loginRequest(username, password);
      if(result.success){
        session.setAuthTokenAndUser(result.data!.token.token, result.data!.user);
        return Result.success(data: result.data);
      } else {
        return const Result.error(message: 'Erro ao fazer login');
      }
    });
  }
}
