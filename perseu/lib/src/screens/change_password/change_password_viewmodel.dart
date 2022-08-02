
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';
import '../../services/http_client_perseu.dart';

class ChangePasswordViewModel extends AppViewModel {
  String? password;
  String? newPassword;
  String? confirmNewPassword;

  HttpClientPerseu httpClientPerseu = locator<HttpClientPerseu>();

  Future<Result> changePassword(){
    return tryExec(() async {
      final result = await httpClientPerseu.changePassword(newPassword!, session.user!.id);
      if(result.success){
        return const Result.success(message: 'Sucesso ao alterar a senha!');
      } else {
        return result;
      }
    });
  }
}