
import 'package:perseu/src/services/clients/client_coach.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';
import '../../services/foundation.dart';

class NewTeamViewModel extends AppViewModel {

  ClientCoach clientCoach = locator<ClientCoach>();
  
  String get coachName => session.userSession!.coach!.name;
  
  String? teamName;

  Future<Result> createTeam(){
    return tryExec(() async {
      String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Imxlb25AZ21haWwuY29tIiwiaWF0IjoxNjY0ODQyMjQ1LCJleHAiOjE2NjQ4NDk0NDV9.OH35dVyM-m_zK9S-qMgUcS0r7K6LhCjtEH_ZxsAppwY';
      final result = await clientCoach.createTeam(teamName!, 4, token);
      if(result.success){
        return Result.success(message: 'Equipe ${result.data} criada com sucesso');
      } else {
        return result;
      }
    });
  }
}