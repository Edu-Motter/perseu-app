import 'package:flutter/cupertino.dart';
import 'package:perseu/src/models/requests/user_request.dart';
import 'package:perseu/src/models/requests/user_update_request.dart';
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
      UserUpdateRequest updatedUser = updateUser();
      final result = await httpClientPerseu.updateUser(updatedUser);
      if (result.success) {

        var athlete = session.user!.athlete;
        if (athlete != null) {
          athlete.height = result.data!.athlete!.height;
          athlete.weight = result.data!.athlete!.weight;
        }

        var coach = session.user!.coach;
        if(coach != null){
          coach.cref = result.data!.coach!.cref;
        }

        final user = result.data!.copyWith(
          status: session.user!.status,
          athlete: athlete,
          coach: session.user!.coach,
        );

        session.setAuthTokenAndUser(session.authToken, user);
        return const Result.success(message: 'Atualizado com sucesso');
      } else {
        return result;
      }
    });
  }

  UserUpdateRequest updateUser() {
    final user = session.user!;
    final userType = user.athlete != null ? 'Atleta' : 'Treinador';
    final userUpdated = UserUpdateRequest(
      user.id,
      name ?? user.name,
      userType,
      email ?? user.email,
      cpf ?? user.cpf,
      birthday ?? user.bornOn,
    );

    if (isAthlete) {
      userUpdated.weight =
          weight != null ? int.tryParse(weight!) : user.athlete!.weight;
      userUpdated.height =
          height != null ? double.tryParse(height!) : user.athlete!.height;
    } else if (isCoach) {
      userUpdated.cref = cref ?? user.coach!.cref;
    }

    return userUpdated;
  }
}
