import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:perseu/src/models/requests/sign_up_request.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/services/http_client_perseu.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';

class SignUpViewModel extends AppViewModel {
  HttpClientPerseu httpClientPerseu = locator<HttpClientPerseu>();

  static const _athlete = 'Atleta';
  static const _coach = 'Treinador';

  String userType = _athlete;

  String name = '';
  String email = '';
  String cpf = '';
  String birthday = '';
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

    SignUpRequest signUpRequest = SignUpRequest(
        name: name,
        email: email,
        cpf: unmaskedCpf,
        birthday: birthday,
        password: password,
        userType: userType.toLowerCase());

    if(userType == _athlete){
      signUpRequest.height = height;
      signUpRequest.weight = weight;
    } else {
      signUpRequest.cref = cref;
    }

    return tryExec(() async {
      final result = await httpClientPerseu.signUp(signUpRequest);
      if (result.success) {
        return const Result.success(message: 'Conta criada com sucesso');
      } else {
        return const Result.error(message: 'Erro ao fazer login');
      }
    });
  }
}
