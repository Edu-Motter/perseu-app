import 'package:perseu/src/services/clients/client_user.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';

class ChangePasswordViewModel extends AppViewModel {
  String? password;
  String? newPassword;
  String? confirmNewPassword;

  ClientUser clientUser = locator<ClientUser>();

  Future<Result> changePassword() {
    return tryExec(() async {
      final result = await clientUser.changePassword(
        newPassword!,
        password!,
        session.userSession!.user.id,
        session.authToken!,
      );
      if (result.success) {
        return const Result.success(message: 'Sucesso ao alterar a senha!');
      } else {
        return result;
      }
    });
  }
}
