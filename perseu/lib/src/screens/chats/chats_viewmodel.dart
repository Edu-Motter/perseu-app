import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/services/clients/client_user.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

class ChatsViewModel extends AppViewModel {
  ClientUser clientUser = locator<ClientUser>();

  int get userId => session.userSession!.user.id;
  int get teamId => session.userSession!.team!.id;
  String get authToken => session.authToken!;

  Future<String> getFriendName(int friendId) async {
    final Result result = await clientUser.getUserName(friendId, authToken);
    if (result.error) {
      return 'Não encontrado';
    }
    return result.data;
  }
}
