import 'dart:convert';

import 'package:perseu/src/models/sessions_model.dart';

class TrainingModel {
  final double id;
  final String name;
  final List<SessionModel> sessions;

  TrainingModel({
    required this.id,
    required this.name,
    required this.sessions
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sessions': sessions,
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
