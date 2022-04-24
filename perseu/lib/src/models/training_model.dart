import 'dart:convert';

class TrainingModel {
  final double id;
  final String name;

  TrainingModel({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory TrainingModel.fromMap(Map<String, dynamic> map) {
    return TrainingModel(
      id: map['id'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());
}
