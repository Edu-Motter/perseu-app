import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';
import '../../services/clients/client_user.dart';
import '../../services/foundation.dart';

class ProfileViewModel extends AppViewModel {
  ClientUser clientUser = locator<ClientUser>();

  String? name;
  String? email;
  String? birthday;
  String? cpf;
  String? cref;
  String? weight;
  String? height;

  bool get isAthlete => session.userSession!.isAthlete;
  bool get isCoach => session.userSession!.isCoach;


  //TODO: ARRUMAR!
  Future<Result> save() async {
    return const Result.error();
  }

  // Future<Result> save() async {
  //   return tryExec(() async {
  //     UserUpdateRequest updatedUser = updateUser();
  //     final result = await clientUser.updateUser(updatedUser);
  //     if (result.success) {
  //       var athlete = session.userSession!.athlete;
  //       if (athlete != null) {
  //         athlete.height = result.data!.athlete!.height;
  //         athlete.weight = result.data!.athlete!.weight;
  //       }
  //
  //       var coach = session.userSession!.coach;
  //       if (coach != null) {
  //         coach.cref = result.data!.coach!.cref;
  //       }
  //
  //       final user = result.data!.copyWith(
  //         status: session.userSession!.status,
  //         athlete: athlete,
  //         coach: session.userSession!.coach,
  //       );
  //
  //       session.setAuthTokenAndUser(session.authToken, user);
  //       return const Result.success(message: 'Atualizado com sucesso');
  //     } else {
  //       return result;
  //     }
  //   });
  // }
  //
  // UserUpdateRequest updateUser() {
  //   final user = session.userSession!;
  //   final userType = user.athlete != null ? 'Atleta' : 'Treinador';
  //   final userUpdated = UserUpdateRequest(
  //     user.id,
  //     name ?? user.name,
  //     userType,
  //     email ?? user.email,
  //     cpf ?? user.cpf,
  //     birthday ?? user.bornOn,
  //   );
  //
  //   if (isAthlete) {
  //     userUpdated.weight =
  //         weight != null ? int.tryParse(weight!) : user.athlete!.weight;
  //     userUpdated.height =
  //         height != null ? double.tryParse(height!) : user.athlete!.height;
  //   } else if (isCoach) {
  //     userUpdated.cref = cref ?? user.coach!.cref;
  //   }
  //
  //   return userUpdated;
  // }
}
