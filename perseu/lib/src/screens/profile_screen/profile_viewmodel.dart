import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/updated_athlete_dto.dart';
import 'package:perseu/src/models/dtos/updated_coach_dto.dart';
import 'package:perseu/src/services/clients/client_athlete.dart';
import 'package:perseu/src/services/clients/client_coach.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';
import 'package:perseu/src/utils/date_formatters.dart';
import 'package:perseu/src/utils/formatters.dart';

class ProfileViewModel extends AppViewModel {
  ClientAthlete clientAthlete = locator<ClientAthlete>();
  ClientCoach clientCoach = locator<ClientCoach>();

  String? name;
  String? email;
  String? birthdate;
  String? document;
  String? cref;
  String? weight;
  String? height;

  Map<String, Object?> userData = {};
  String get oldName => userData['name'] as String;
  String get oldBirthdate {
    final isoInstant = userData['birthdate'] as String;
    return DateFormatters.toDateString(isoInstant);
  }

  String get oldDocument =>
      Formatters.cpf().maskText(userData['document'] as String);
  String get oldCref => userData['cref'] as String? ?? '';
  int get oldWeight => userData['weight'] as int? ?? 0;
  int get oldHeight => userData['height'] as int? ?? 0;

  bool get isAthlete => session.userSession!.isAthlete;
  bool get isCoach => session.userSession!.isCoach;

  String get authToken => session.authToken!;
  int get id => isAthlete
      ? session.userSession!.athlete!.id
      : session.userSession!.coach!.id;

  Future<Result> getUserData() async {
    Result result;
    if (isAthlete) {
      result = await clientAthlete.getAthlete(id, authToken);
    } else {
      result = await clientCoach.getCoach(id, authToken);
    }
    userData = result.data;
    loadUserData();
    return const Result.success();
  }

  void loadUserData() {
    email = session.userSession!.user.email;
    name = userData['name'] as String;

    String _birthdate = userData['birthdate'] as String;
    birthdate = DateFormatters.toDateString(_birthdate);

    String _document = userData['document'] as String;
    document = Formatters.cpf().maskText(_document);

    if (isCoach) {
      cref = userData['cref'] as String;
    }
    if (isAthlete) {
      weight = Formatters.weight().maskText(userData['weight'].toString());
      height = Formatters.height().maskText(userData['height'].toString());
    }
  }

  Future<Result> save() async {
    return tryExec(() async {
      Result result;
      if (isAthlete) {
        result =
            await clientAthlete.updateAthlete(updatedAthlete(), id, authToken);
      } else {
        result = await clientCoach.updateCoach(updatedCoach(), id, authToken);
      }

      //TODO: atualizar a sessao do usuario
      // session.setAuthTokenAndUser(session.authToken, user);
      if (result.success) {
        return const Result.success(message: 'Atualizado com sucesso');
      } else {
        return result;
      }
    });
  }

  UpdatedCoachDTO updatedCoach() {
    return UpdatedCoachDTO(
      name: name ?? oldName,
      document: document ?? oldDocument,
      birthdate: birthdateToIsoInstant(),
      cref: cref ?? oldCref,
    );
  }

  UpdatedAthleteDTO updatedAthlete() {
    return UpdatedAthleteDTO(
      name: name ?? oldName,
      document: document ?? oldDocument,
      birthdate: birthdateToIsoInstant(),
      weight: parsedWeight(),
      height: parsedHeight(),
    );
  }

  String birthdateToIsoInstant() {
    if (birthdate != null) {
      return DateFormatters.toIsoInstant(birthdate!);
    }
    return DateFormatters.toIsoInstant(oldBirthdate);
  }

  int parsedWeight() {
    if (weight != null) {
      final String unmaskedWeight = Formatters.weight().unmaskText(weight!);
      return int.parse(unmaskedWeight);
    }
    return oldWeight;
  }

  int parsedHeight() {
    if (height != null) {
      final String unmaskedHeight = Formatters.height().unmaskText(height!);
      return int.parse(unmaskedHeight);
    }
    return oldHeight;
  }
}
