import 'package:perseu/src/services/http_client_perseu.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';
import '../../services/foundation.dart';

class ChangeTeamNameViewModel extends AppViewModel {
  HttpClientPerseu httpClientPerseu = locator<HttpClientPerseu>();

  String? teamName;

  Future<Result> changeTeamName() {
    return tryExec(() async {
      return await httpClientPerseu.changeTeamName(teamName!, 7);
    });
  }
}
