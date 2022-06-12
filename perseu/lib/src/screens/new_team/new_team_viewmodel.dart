
import 'package:perseu/src/services/http_client_perseu.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';
import '../../services/foundation.dart';

class NewTeamViewModel extends AppViewModel {

  HttpClientPerseu httpClientPerseu = locator<HttpClientPerseu>();

  String? teamName;

  Future<Result> createTeam(){
    return tryExec(() async {
      final result = await httpClientPerseu.createTeam(teamName!, session.user!.coach!.id);
      if(result.success){
        return Result.success(message: 'Equipe ${result.data} criada com sucesso');
      } else {
        return result;
      }
    });
  }
}