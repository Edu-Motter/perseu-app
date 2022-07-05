import 'dart:convert';

import 'package:perseu/src/models/requests/athlete_request.dart';
import 'package:perseu/src/models/requests/coach_request.dart';
import 'package:perseu/src/models/requests/status_login.dart';

class UserRequest {
  final int id;
  final String name;
  final String email;
  final String cpf;
  final String bornOn;
  final StatusLogin status;
  final String createdAt;
  final String updatedAt;
  final CoachRequest? coach;
  final AthleteRequest? athlete;

  UserRequest({
    required this.id,
    required this.name,
    required this.email,
    required this.cpf,
    required this.bornOn,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.coach,
    required this.athlete
  });

  Map<String, dynamic> toMap() {
    String coachString = coach != null ? coach!.toJson() : '';
    String athleteString = athlete != null ? athlete!.toJson() : '';
    return {
      'id' : id,
      'nome' : name,
      'email' : email,
      'cpf' : cpf,
      'data_nascimento' : bornOn,
      'status' : status.toJson,
      'created_at' : createdAt,
      'updated_at' : updatedAt,
      'treinador' : coachString,
      'atleta' : athleteString
    };
  }

  factory UserRequest.fromMap(Map<String, dynamic> map){
    return UserRequest(
        id: map['id'],
        name: map['nome'],
        email: map['email'],
        cpf: map['cpf'],
        bornOn: map['data_nascimento'],
        status: StatusLoginString.getStatusLogin(map['status']),
        createdAt: map['created_at'],
        updatedAt: map['updated_at'],
        coach: map['treinador'] != '' ? CoachRequest.fromMap(map['treinador']) : null,
        athlete: map['atleta'] != '' ? AthleteRequest.fromMap(map['atleta']) : null,
    );
  }

  String toJson() => json.encode(toMap());
}