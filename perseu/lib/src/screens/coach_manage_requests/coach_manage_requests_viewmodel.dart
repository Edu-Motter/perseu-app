import 'package:perseu/src/services/clients/client_coach.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';
import '../../models/requests/invite_request.dart';

class CoachManageRequestsViewModel extends AppViewModel {

  ClientCoach clientCoach = locator<ClientCoach>();

  Future<Result<List<InviteRequest>>> getRequests(int teamId){
    return clientCoach.getRequests(teamId);
  }

  Future<Result> acceptRequest(int requestId){
    return tryExec(() async {
      return await clientCoach.acceptRequest(requestId);
    });
  }

  Future<Result> refuseRequest(int requestId){
    return tryExec(() async {
        var result = await clientCoach.refuseRequest(requestId);
        return result;
    });
  }
}