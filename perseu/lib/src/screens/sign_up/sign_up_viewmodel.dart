import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:intl/intl.dart';
import 'package:perseu/src/models/requests/sign_up_request.dart';
import 'package:perseu/src/services/clients/client_user.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';
import 'package:perseu/src/utils/formatters.dart';

import '../../app/locator.dart';

class SignUpViewModel extends AppViewModel {
  ClientUser clientUser = locator<ClientUser>();

  static const _athlete = 'Atleta';
  static const _coach = 'Treinador';

  String userType = '';

  String name = '';
  String email = '';
  String cpf = '';
  String birthdate = '';
  String password = '';
  String confirmPassword = '';
  String cref = '';
  String height = '';
  String weight = '';

  bool get isAthlete => userType == _athlete;

  bool get isCoach => userType == _coach;

  void userTypeValue(String value) {
    userType = value;
    notifyListeners();
  }

  Future<Result<void>> signUp() async {
    String unmaskedCpf = CPFValidator.strip(cpf);
    String unmaskedHeight = Formatters.height().unmaskText(height);
    String unmaskedWeight = Formatters.weight().unmaskText(weight);

    final format = DateFormat('dd/MM/yyyy');
    DateTime parsedDate = format.parse(birthdate);

    if (_verifyInvalidAge(parsedDate)) {
      return const Result.error(message: 'Data inválida');
    }

    if (isAthlete) {
      return await registerAthlete(unmaskedCpf, parsedDate, unmaskedHeight, unmaskedWeight);
    } else {
      return await registerCoach(unmaskedCpf, parsedDate);
    }
  }

  Future<Result> registerAthlete(
    String unmaskedCpf,
    DateTime parsedDate,
    String unmaskedHeight,
    String unmaskedWeight,
  ) async {
    SignUpAthleteRequest signUpAthleteRequest = SignUpAthleteRequest(
      name: name.trim(),
      email: email,
      document: unmaskedCpf,
      birthdate: parsedDate,
      password: password,
      height: int.parse(unmaskedHeight),
      weight: int.parse(unmaskedWeight),
    );

    return tryExec(() async {
      final result = await clientUser.signUpAthlete(signUpAthleteRequest);
      if (result.success) {
        return const Result.success(message: 'Conta Atleta criada com sucesso');
      } else {
        return Result.error(message: result.message);
      }
    });
  }

  Future<Result> registerCoach(
    String unmaskedCpf,
    DateTime parsedDate,
  ) async {
    SignUpCoachRequest signUpCoachRequest = SignUpCoachRequest(
      name: name,
      email: email,
      document: unmaskedCpf,
      birthdate: parsedDate,
      password: password,
      cref: cref,
    );

    return tryExec(() async {
      final result = await clientUser.signUpCoach(signUpCoachRequest);
      if (result.success) {
        return const Result.success(message: 'Conta Treinador criada com sucesso');
      } else {
        return Result.error(message: result.message);
      }
    });
  }

  bool _verifyInvalidAge(DateTime dateTime) {
    const maxYear = 150;
    const minYear = 12;

    if (dateTime.year > DateTime.now().year - minYear) return true;

    if (dateTime.year < DateTime.now().year - maxYear) return true;

    return false;
  }
}
