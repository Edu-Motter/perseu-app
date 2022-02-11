import 'dart:convert';

class UserModel {
  final double id;
  final String name;
  final String cpf;
  final String email;
  final String token;
  final DateTime birthday;

  UserModel(
      {required this.id,
      required this.cpf,
      required this.birthday,
      required this.name,
      required this.email,
      required this.token});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cpf': cpf,
      'email': email,
      'token': token,
      'birthday': birthday
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        cpf: map['cpf'],
        token: map['token'],
        birthday: map['birthday']);
  }

  String toJson() => json.encode(toMap());
}
