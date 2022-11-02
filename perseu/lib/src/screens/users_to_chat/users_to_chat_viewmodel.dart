import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/user_chat_dto.dart';
import 'package:perseu/src/services/clients/client_team.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

class UsersToChatViewModel extends AppViewModel {
  ClientTeam clientTeam = locator<ClientTeam>();

  int get userId => session.userSession!.user.id;

  String get authToken => session.authToken!;
  int get teamId => session.userSession!.team!.id;

  bool _searching = false;
  bool get searching => _searching;
  set searching(bool value) {
    _searching = value;
    notifyListeners();
  }

  String _searchingValue = '';
  String get searchingValue => _searchingValue;
  set searchingValue(String value) {
    _searchingValue = value;
    notifyListeners();
  }

  List<UserChatDTO> allUsers = [];
  List<UserChatDTO> users = [];

  Future<List<UserChatDTO>> getUsers(String searchingValue) async {
    final Result<List<UserChatDTO>> result =
        await clientTeam.getUsers(teamId, authToken);
    if (result.success) {
      allUsers = result.data!;
      allUsers.removeWhere((user) => user.id == userId);

      users = searching ? search(searchingValue) : allUsers;
      return users;
    }
    return [];
  }

  List<UserChatDTO> search(String searchingValue) {
    final String formattedValue = searchingValue.toUpperCase();
    return allUsers
        .where((u) => u.name.toUpperCase().contains(formattedValue))
        .toList();
  }
}
