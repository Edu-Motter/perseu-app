import 'package:flutter/material.dart';

class SignUpViewModel extends ChangeNotifier {
  bool _busy = false;
  bool get isBusy => _busy;
  bool get isNotBusy => !_busy;

  String name = '';
  String email = '';
  String birthday = '';
  String password = '';
  String confirmPassword = '';

  String get getName => name;
  set setName(value) {
    name = value;
    notifyListeners();
  }

  String get getEmail => email;
  set setEmail(value) {
    email = value;
    notifyListeners();
  }

  String get getBirthday => birthday;
  set setBirthday(value) {
    birthday = value;
    notifyListeners();
  }

  String get getPassword => password;
  set setPassword(value) {
    password = value;
    notifyListeners();
  }

  String get getConfirmPassword => confirmPassword;
  set setConfirmPassword(value) {
    confirmPassword = value;
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
