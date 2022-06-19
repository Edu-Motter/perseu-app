import 'dart:convert';

class AthleteRequest {
  final int id;
  final int userId;
  final String weight;
  final String height;

  AthleteRequest(
      {required this.id,
      required this.userId,
      required this.weight,
      required this.height});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'peso': weight,
      'altura': height,
    };
  }

  factory AthleteRequest.fromMap(Map<String, dynamic> map) {
    return AthleteRequest(
        id: map['id'],
        userId: map['user_id'],
        weight: map['peso'],
        height: map['altura']);
  }

  String toJson() => json.encode(toMap());
}
