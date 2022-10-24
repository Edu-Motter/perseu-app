import 'dart:convert';

import 'package:perseu/src/models/sessions_model.dart';

class TrainingModel {
  String name;
  final int id;
  final List<SessionModel> sessions;

  TrainingModel({
    required this.name,
    required this.id,
    required this.sessions
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sessions': sessions.map((e) => e.toMap()).toList(),
    };
  }

  factory TrainingModel.fromMap(Map<String, dynamic> map) {
    return TrainingModel(
      id: map['id'],
      name: map['name'],
      sessions: map['sessions']
    );
  }

  String toJson() => json.encode(toMap());
}
