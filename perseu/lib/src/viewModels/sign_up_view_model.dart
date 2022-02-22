import 'package:flutter/material.dart';

class SignUpViewModel extends ChangeNotifier {
  bool _busy = false;
  bool get isBusy => _busy;
  bool get isNotBusy => !_busy;

  String nome = '';
  String email = '';
  String nascimento = '';
  String senha = '';
  String confirmaSenha = '';
  bool tipoUsuario = true;

  String get getName => nome;
  set setName(value) {
    nome = value;
    notifyListeners();
  }

  String get getEmail => email;
  set setEmail(value) {
    email = value;
    notifyListeners();
  }

  String get getBirthday => nascimento;
  set setBirthday(value) {
    nascimento = value;
    notifyListeners();
  }

  String get getPassword => senha;
  set setPassword(value) {
    senha = value;
    notifyListeners();
  }

  String get getConfirmPassword => confirmaSenha;
  set setConfirmPassword(value) {
    confirmaSenha = value;
    notifyListeners();
  }

  bool get getUserType => tipoUsuario;
  set setUserType(value) {
    if (value) {
      tipoUsuario = true;
    } else {
      tipoUsuario = false;
    }
    notifyListeners();
  }

  void signUp() async {
    _busy = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 5));

    _busy = false;
    notifyListeners();
  }
}
