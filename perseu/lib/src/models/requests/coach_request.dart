import 'dart:convert';

class CoachRequest {
  final int id;
  final int userId;
  final String cref;

  CoachRequest({required this.id, required this.userId, required this.cref});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'cref': cref,
    };
  }

  factory CoachRequest.fromMap(Map<String, dynamic> map) {
    return CoachRequest(
        id: map['id'], userId: map['user_id'], cref: map['cref']);
  }

  String toJson() => json.encode(toMap());
}
