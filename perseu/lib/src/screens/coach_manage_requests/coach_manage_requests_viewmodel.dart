import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/services/http_client_perseu.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';
import '../../models/requests/invite_request.dart';

class CoachManageRequestsViewModel extends AppViewModel {

  HttpClientPerseu httpClientPerseu = locator<HttpClientPerseu>();

  Future<Result<List<InviteRequest>>> getRequests(int teamId){
    return httpClientPerseu.getRequests(teamId);
  }

  Future<Result> acceptRequest(int requestId){
    return tryExec(() async {
      return await httpClientPerseu.acceptRequest(requestId);
    });
  }

  Future<Result> refuseRequest(int requestId){
    return tryExec(() async {
        var result = await httpClientPerseu.refuseRequest(requestId);
        return result;
    });
  }
}