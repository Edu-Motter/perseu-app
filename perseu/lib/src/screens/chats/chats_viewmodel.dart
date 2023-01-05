import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/group_name_dto.dart';
import 'package:perseu/src/services/clients/client_athlete.dart';
import 'package:perseu/src/services/clients/client_team.dart';
import 'package:perseu/src/services/clients/client_user.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

class ChatsViewModel extends AppViewModel {
  ClientUser clientUser = locator<ClientUser>();
  ClientAthlete clientAthlete = locator<ClientAthlete>();
  ClientTeam clientTeam = locator<ClientTeam>();

  int get userId => session.userSession!.user.id;
  int get teamId => session.userSession!.team!.id;
  bool get isAthlete => session.userSession!.isAthlete;

  String get authToken => session.authToken!;

  bool _teamChatVisible = true;
  bool get isTeamChatVisible => _teamChatVisible;
  void changeTeamChatVisibility(){
    _teamChatVisible = !_teamChatVisible;
    notifyListeners();
  }

  bool _groupsChatVisible = true;
  bool get isGroupsChatVisible => _groupsChatVisible;
  void changeGroupsChatVisibility(){
    _groupsChatVisible = !_groupsChatVisible;
    notifyListeners();
  }

  bool _usersChatVisible = true;
  bool get isUsersChatVisible => _usersChatVisible;
  void changeUsersChatVisibility(){
    _usersChatVisible = !_usersChatVisible;
    notifyListeners();
  }

  Future<String> getFriendName(int friendId) async {
    final Result result = await clientUser.getUserName(friendId, authToken);
    if (result.error) {
      return 'Não encontrado';
    }
    return result.data;
  }

  Future<Result<List<GroupNameDTO>>> getUserGroups() {
    if (isAthlete) {
      return clientAthlete.getAthleteGroups(authToken, teamId);
    } else {
      return clientTeam.getGroups(authToken, teamId);
    }
  }
}
