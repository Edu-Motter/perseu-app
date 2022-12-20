import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/login_dto.dart';
import 'package:perseu/src/services/clients/client_user.dart';

import '../services/foundation.dart';
import '../states/foundation.dart';

class LoginViewModel extends AppViewModel {
  static const gif = 'assets/gifs/fitness.gif';
  static const image = 'assets/images/dumbbell-accent.png';

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

  Future<Result<LoginDTO>> login() async {
    return tryExec(() async {
      final result = await clientPerseu.loginRequest(username, password);
      if(result.success){
        session.setAuthTokenAndUser(result.data!.token, result.data!);
        return Result.success(data: result.data);
      } else {
        return const Result.error(message: 'Erro ao fazer login');
      }
    });
  }
}
