class InviteRequest {
  int id;
  int athleteId;
  int teamId;
  String status;

  InviteRequest(
      {required this.id,
      required this.athleteId,
      required this.teamId,
      required this.status});

  factory InviteRequest.fromMap(Map<String, dynamic> map) {
    return InviteRequest(
        id: map['id'],
        athleteId: map['atleta_id'],
        teamId: map['equipe_id'],
        status: map['status']);
  }
}
