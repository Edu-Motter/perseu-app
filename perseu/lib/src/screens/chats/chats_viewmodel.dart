import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/group_name_dto.dart';
import 'package:perseu/src/services/clients/client_athlete.dart';
import 'package:perseu/src/services/clients/client_team.dart';
import 'package:perseu/src/services/clients/client_user.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../services/clients/client_firebase.dart';

class ChatsViewModel extends AppViewModel {
  ClientUser clientUser = locator<ClientUser>();
  ClientAthlete clientAthlete = locator<ClientAthlete>();
  ClientTeam clientTeam = locator<ClientTeam>();
  ClientFirebase clientFirebase = locator<ClientFirebase>();

  int get userId => session.userSession!.user.id;
  int get teamId => session.userSession!.team!.id;
  String get teamName => session.userSession!.team!.name;
  bool get isAthlete => session.userSession!.isAthlete;

  String get authToken => session.authToken!;

  bool _teamChatVisible = true;
  bool get isTeamChatVisible => _teamChatVisible;
  void changeTeamChatVisibility() {
    _teamChatVisible = !_teamChatVisible;
    notifyListeners();
  }

  bool _groupsChatVisible = true;
  bool get isGroupsChatVisible => _groupsChatVisible;
  void changeGroupsChatVisibility() {
    _groupsChatVisible = !_groupsChatVisible;
    notifyListeners();
  }

  bool _usersChatVisible = true;
  bool get isUsersChatVisible => _usersChatVisible;
  void changeUsersChatVisibility() {
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
      final athleteId = session.userSession!.athlete!.id;
      return clientAthlete.getAthleteGroups(authToken, athleteId);
    } else {
      return clientTeam.getGroups(authToken, teamId);
    }
  }

  Stream<DocumentSnapshot> getTeamLastMessage() =>
      clientFirebase.getTeamLastMessage(teamId: teamId);

  Stream<QuerySnapshot> getUsersLastMessages() =>
      clientFirebase.getUsersLastMessages(userId: userId, teamId: teamId);

  Stream<DocumentSnapshot> getGroupsLastMessages(int groupId) =>
      clientFirebase.getGroupsLastMessages(teamId: teamId, groupId: groupId);



}
