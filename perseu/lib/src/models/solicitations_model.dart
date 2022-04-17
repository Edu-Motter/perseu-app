import 'dart:convert';

class SolicitationsModel {
  final double id;
  final String name;

  SolicitationsModel({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory SolicitationsModel.fromMap(Map<String, dynamic> map) {
    return SolicitationsModel(
      id: map['id'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());
}
