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

  get isAthlete => athlete != null;
  get isCoach => coach != null;

  UserRequest(
      {required this.id,
      required this.name,
      required this.email,
      required this.cpf,
      required this.bornOn,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.coach,
      required this.athlete});

  UserRequest copyWith(
      {int? id,
      String? name,
      String? email,
      String? cpf,
      String? bornOn,
      StatusLogin? status,
      String? createdAt,
      String? updatedAt,
      AthleteRequest? athlete,
      CoachRequest? coach}) {
    return UserRequest(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        cpf: cpf ?? this.cpf,
        bornOn: bornOn ?? this.bornOn,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        coach: coach ?? this.coach,
        athlete: athlete ?? this.athlete);
  }

  Map<String, dynamic> toMap() {
    String coachString = coach != null ? coach!.toJson() : '';
    String athleteString = athlete != null ? athlete!.toJson() : '';
    return {
      'id': id,
      'nome': name,
      'email': email,
      'cpf': cpf,
      'data_nascimento': bornOn,
      'status': status.toJson,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'treinador': coachString,
      'atleta': athleteString
    };
  }

  factory UserRequest.fromMap(Map<String, dynamic> map) {
    return UserRequest(
      id: map['id'],
      name: map['nome'],
      email: map['email'],
      cpf: map['cpf'],
      bornOn: map['data_nascimento'],
      status: map['status'] != null ? StatusLoginString.getStatusLogin(map['status']) : StatusLogin.unknown,
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      coach: (map['treinador'] != '' && map['treinador'] != null)
          ? CoachRequest.fromMap(map['treinador'])
          : null,
      athlete: (map['atleta'] != '' && map['atleta'] != null)
          ? AthleteRequest.fromMap(map['atleta'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'UserRequest{id: $id, name: $name, email: $email, cpf: $cpf, bornOn: $bornOn, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, coach: $coach, athlete: $athlete}';
  }
}
