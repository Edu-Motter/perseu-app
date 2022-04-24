import 'dart:convert';

class ExerciseModel {
  final double id;
  final String name;
  final String description;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    return ExerciseModel(
        id: map['id'], name: map['name'], description: map['description']);
  }

  String toJson() => json.encode(toMap());
}
