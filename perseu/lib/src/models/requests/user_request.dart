
import 'dart:convert';

class UserRequest {
  final int id;
  final String name;
  final String email;
  final String cpf;
  final String bornOn;
  final String createdAt;
  final String updatedAt;
  final String? manager;
  final String? athlete;

  UserRequest({
    required this.id,
    required this.name,
    required this.email,
    required this.cpf,
    required this.bornOn,
    required this.createdAt,
    required this.updatedAt,
    required this.manager,
    required this.athlete
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'nome' : name,
      'email' : email,
      'cpf' : cpf,
      'data_nascimento' : bornOn,
      'created_at' : createdAt,
      'updated_at' : updatedAt,
      'treinador' : manager,
      'atleta' : athlete
    };
  }

  factory UserRequest.fromMap(Map<String, dynamic> map){
    return UserRequest(
        id: map['id'],
        name: map['nome'],
        email: map['email'],
        cpf: map['cpf'],
        bornOn: map['data_nascimento'],
        createdAt: map['created_at'],
        updatedAt: map['updated_at'],
        manager: map['treinador'],
        athlete: map['atleta']
    );
  }

  String toJson() => json.encode(toMap());
}