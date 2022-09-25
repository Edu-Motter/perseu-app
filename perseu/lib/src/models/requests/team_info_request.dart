import 'dart:convert';

class TeamInfoRequest {
  final int id;
  final String name;
  final int coachId;
  final String code;
  final List<int> athletesIds;

  TeamInfoRequest(
      {required this.id,
      required this.name,
      required this.coachId,
      required this.code,
      required this.athletesIds});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': name, 'treinador_id': coachId, 'codigo': code};
  }

  factory TeamInfoRequest.fromMap(Map<String, dynamic> map) {
    List<dynamic> athletes = map['atletas_aprovados'] as List;

    return TeamInfoRequest(
        id: map['id'],
        name: map['nome'],
        coachId: map['treinador_id'],
        code: map['codigo'],
        athletesIds: athletes.map((a) => a['atleta_id'] as int).toList()
    );
  }

  String toJson() => json.encode(toMap());
}
