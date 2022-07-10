import 'package:perseu/src/models/requests/user_request.dart';
import 'package:perseu/src/services/http_client_perseu.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';
import '../../services/foundation.dart';

class ProfileViewModel extends AppViewModel {

  HttpClientPerseu httpClientPerseu = locator<HttpClientPerseu>();

  String? name;
  String? email;
  String? birthday;
  String? cpf;
  String? cref;
  String? weight;
  String? height;

  bool get isAthlete => session.user!.athlete != null;
  bool get isCoach => session.user!.coach != null;

  Future<Result> save() async {
    return tryExec(() async {
      UserRequest updatedUser = updateUser();
      final result = await httpClientPerseu.updateUser(updatedUser);
      if(result.success){
        return const Result.success(message: 'Atualizado com sucesso');
      } else {
        return result;
      }
    });
  }

  UserRequest updateUser() {
    UserRequest updatedUser = session.user!.copyWith(
      name: name,
      email: email,
      bornOn: birthday,
      cpf: cpf,
      coach: isCoach ? session.user!.coach!.copyWith(cref: cref) : null,
      athlete: isAthlete
          ? session.user!.athlete!.copyWith(height: height, weight: weight)
          : null,
    );
    return updatedUser;
  }
}