class InviteRequest {
  int id;
  int athleteId;
  int teamId;
  String status;
  InviteAthlete athlete;

  InviteRequest(
      {required this.id,
      required this.athleteId,
      required this.teamId,
      required this.status,
      required this.athlete});

  factory InviteRequest.fromMap(Map<String, dynamic> map) {
    return InviteRequest(
        id: map['id'],
        athleteId: map['atleta_id'],
        teamId: map['equipe_id'],
        status: map['status'],
        athlete: InviteAthlete.fromMap(map['atleta'])
    );
  }
}

class InviteAthlete {
  final int id;
  final String name;

  InviteAthlete({required this.id, required this.name});

  factory InviteAthlete.fromMap(Map<String, dynamic> map){
    return InviteAthlete(id: map['id'], name: map['nome']);
  }
}
