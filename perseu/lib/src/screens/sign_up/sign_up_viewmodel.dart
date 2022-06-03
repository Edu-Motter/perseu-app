import 'package:perseu/src/states/foundation.dart';

class SignUpViewModel extends AppViewModel {
  static const _athlete = 'Atleta';
  static const _coach = 'Treinador';

  String name = '';
  String email = '';
  String birthday = '';
  String password = '';
  String confirmPassword = '';
  String cref = '';
  String userType = _athlete;

  bool get isAthlete => userType == _athlete;

  bool get isCoach => userType == _coach;

  void userTypeValue(String value) {
    userType = value;
    notifyListeners();
  }

  void signUp() async {
    notifyListeners();

    await Future.delayed(const Duration(seconds: 5));

    notifyListeners();
  }
}
