import 'dart:convert';

import 'package:perseu/src/models/requests/team_request.dart';

class CoachRequest {
  final int id;
  final int userId;
  final String cref;
  final TeamRequest? team;

  CoachRequest(
      {required this.id,
      required this.userId,
      required this.cref,
      required this.team});

  CoachRequest copyWith(
      {int? id, int? userId, String? cref, TeamRequest? team}) {
    return CoachRequest(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        cref: cref ?? this.cref,
        team: team ?? this.team);
  }

  Map<String, dynamic> toMap() {
    String teamString = team != null ? team!.toJson() : '';
    return {'id': id, 'user_id': userId, 'cref': cref, 'equipe': teamString};
  }

  factory CoachRequest.fromMap(Map<String, dynamic> map) {
    if (map['equipe'] != '') {
      map['equipe'] = map['equipe'] is String ? json.decode(map['equipe']) : map['equipe'];
    }
    return CoachRequest(
        id: map['id'],
        userId: map['user_id'],
        cref: map['cref'],
        team:
            map['equipe'] != null ? TeamRequest.fromMap(map['equipe']) : null);
  }

  String toJson() => json.encode(toMap());
}
