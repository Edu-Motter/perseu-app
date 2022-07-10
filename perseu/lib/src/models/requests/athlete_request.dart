import 'dart:convert';

import 'package:perseu/src/models/requests/team_request.dart';

class AthleteRequest {
  final int id;
  final int userId;
  final String weight;
  final String height;
  final TeamRequest? team;

  AthleteRequest(
      {required this.id,
      required this.userId,
      required this.weight,
      required this.height,
      required this.team});

  AthleteRequest copyWith(
      {int? id,
      int? userId,
      String? weight,
      String? height,
      TeamRequest? team}) {
    return AthleteRequest(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        weight: weight ?? this.weight,
        height: height ?? this.height,
        team: team ?? this.team);
  }

  Map<String, dynamic> toMap() {
    String teamString = team != null ? team!.toJson() : '';
    return {
      'id': id,
      'user_id': userId,
      'peso': weight,
      'altura': height,
      'equipe': teamString
    };
  }

  factory AthleteRequest.fromMap(Map<String, dynamic> map) {
    if (map['equipe'] != '') {
      map['equipe'] =
          map['equipe'] is String ? json.decode(map['equipe']) : map['equipe'];
    }
    return AthleteRequest(
        id: map['id'],
        userId: map['user_id'],
        weight: map['peso'],
        height: map['altura'],
        team:
            map['equipe'] != null ? TeamRequest.fromMap(map['equipe']) : null);
  }

  String toJson() => json.encode(toMap());
}
