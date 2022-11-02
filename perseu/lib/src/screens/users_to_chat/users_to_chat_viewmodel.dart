import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/services/clients/client_team.dart';
import 'package:perseu/src/states/foundation.dart';

class UsersToChatViewModel extends AppViewModel {
  ClientTeam clientTeam = locator<ClientTeam>();

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

  List<UserChat> allUsers = [];
  List<UserChat> users = [];

  Future<List<UserChat>> getUsers(String searchingValue) async {
    final usersMock =  [
      UserChat('Treinador-t', 22),
      UserChat('Nilce', 18),
      UserChat('Treinador', 19)
    ];
    allUsers = usersMock;
    users = usersMock;
    return usersMock;
    // final Result result = await clientTeam.getAthletes(teamId, authToken);
    // if (result.success) {
    //   allUsers = result.data!;
    //   users = searching ? search(searchingValue) : allUsers;
    //   return users;
    // }
    // return [];
  }

  List<UserChat> search(String searchingValue) {
    final String formattedValue = searchingValue.toUpperCase();
    return allUsers
        .where((u) => u.name.toUpperCase().contains(formattedValue))
        .toList();
  }
}

class UserChat {
  final String name;
  final int id;

  UserChat(this.name, this.id);
}
