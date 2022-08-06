
import 'package:perseu/src/services/clients/client_coach.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';
import '../../services/foundation.dart';

class NewTeamViewModel extends AppViewModel {

  ClientCoach clientCoach = locator<ClientCoach>();

  String? teamName;

  Future<Result> createTeam(){
    return tryExec(() async {
      final result = await clientCoach.createTeam(teamName!, session.user!.coach!.id);
      if(result.success){
        return Result.success(message: 'Equipe ${result.data} criada com sucesso');
      } else {
        return result;
      }
    });
  }
}