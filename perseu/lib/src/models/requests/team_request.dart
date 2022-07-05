import 'dart:convert';

class TeamRequest {
  final int id;
  final String name;
  final int coachId;
  final String code;

  TeamRequest(
      {required this.id,
      required this.name,
      required this.coachId,
      required this.code});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': name, 'treinador_id': coachId, 'codigo': code};
  }

  factory TeamRequest.fromMap(Map<String, dynamic> map) {
    return TeamRequest(
        id: map['id'],
        name: map['nome'],
        coachId: map['treinador_id'],
        code: map['codigo']);
  }

  String toJson() => json.encode(toMap());
}
