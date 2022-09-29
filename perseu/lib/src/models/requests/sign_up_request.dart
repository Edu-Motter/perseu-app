import 'dart:convert';

class SignUpAthleteRequest {
  final String name;
  final String email;
  final String document;
  final DateTime birthdate;
  final String password;
  final int height;
  final int weight;

  SignUpAthleteRequest({
    required this.name,
    required this.email,
    required this.document,
    required this.birthdate,
    required this.password,
    required this.height,
    required this.weight,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'document': document,
      'birthdate': birthdate.toIso8601String(),
      'password': password,
      'weight': weight,
      'height': height,
    };
  }

  factory SignUpAthleteRequest.fromMap(Map<String, dynamic> map) {
    return SignUpAthleteRequest(
      name: map['nome'],
      email: map['email'],
      document: map['document'],
      birthdate: map['birthdate'],
      password: map['password'],
      height: map['height'],
      weight: map['weight'],
    );
  }

  String toJson() => json.encode(toMap());
}

class SignUpCoachRequest {
  final String name;
  final String email;
  final String document;
  final DateTime birthdate;
  final String password;
  final String cref;

  SignUpCoachRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.document,
    required this.cref,
    required this.birthdate,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'document': document,
      'cref': cref,
      'birthdate': birthdate.toIso8601String(),
    };
  }

  factory SignUpCoachRequest.fromMap(Map<String, dynamic> map) {
    return SignUpCoachRequest(
      name: map['nome'],
      email: map['email'],
      password: map['password'],
      document: map['document'],
      cref: map['cref'],
      birthdate: map['birthdate'],
    );
  }

  String toJson() => json.encode(toMap());
}
