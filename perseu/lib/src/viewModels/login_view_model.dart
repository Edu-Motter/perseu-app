import 'package:flutter/foundation.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/login_dto.dart';
import 'package:perseu/src/services/clients/client_user.dart';
import 'package:perseu/src/services/fcm_service.dart';

import '../services/foundation.dart';
import '../states/foundation.dart';

class LoginViewModel extends AppViewModel {
  final FcmService fcmService = locator<FcmService>();

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

  Future<Result<dynamic>> login() async {
    return tryExec(() async {
      await Future.delayed(const Duration(milliseconds: 250));
      final result = await clientPerseu.loginRequest(username, password);

      if (result.error) {
        return result;
      }

      //Check device token
      final resultFcm = await handleFcmCredentials(result.data!);
      if (resultFcm.error) return resultFcm;

      session.setAuthTokenAndUser(result.data!.token, result.data!);
      debugPrint('Success with login and fcm token registration');
      return Result.success(data: result.data);
    });
  }

  Future<Result> handleFcmCredentials(LoginDTO login) async {
    final String? deviceToken = await fcmService.getDeviceToken();
    if (deviceToken == null) {
      return const Result.error(message: 'Erro ao gerar device token');
    }

    return fcmService.saveDeviceToken(deviceToken, login.user.id, login.token);
  }
}
