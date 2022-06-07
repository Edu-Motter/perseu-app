import 'dart:convert';

class SignUpRequest {
  final String name;
  final String email;
  final String cpf;
  final String birthday;
  final String password;
  final String userType;

  String? height;
  String? weight;
  String? cref;

  SignUpRequest(
      {required this.name,
      required this.email,
      required this.cpf,
      required this.birthday,
      required this.password,
      required this.userType});

  Map<String, dynamic> toMap() {
    return {
      'nome': name,
      'email': email,
      'cpf': cpf,
      'nascimento': birthday,
      'senha': password,
      'tipo_usuario': userType,
      if (userType == 'atleta') 'peso': weight,
      if (userType == 'atleta') 'altura': height,
      if (userType == 'treinador') 'cref': cref,
    };
  }

  factory SignUpRequest.fromMap(Map<String, dynamic> map) {
    return SignUpRequest(
        name: map['nome'],
        email: map['email'],
        cpf: map['cpf'],
        birthday: map['nascimento'],
        password: map['senha'],
        userType: map['tipo_usuario']);
  }

  String toJson() => json.encode(toMap());
}
