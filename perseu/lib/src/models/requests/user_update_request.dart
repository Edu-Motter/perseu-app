import 'dart:convert';

import 'package:flutter/cupertino.dart';

class UserUpdateRequest {
  int id;
  String name;
  String userType;
  String email;
  String cpf;
  String birthday;
  int? weight;
  double? height;
  String? cref;

  UserUpdateRequest(
    this.id,
    this.name,
    this.userType,
    this.email,
    this.cpf,
    this.birthday,
  );

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'nome' : name,
      'tipo_usuario' : userType,
      'email' : email,
      'cpf' : cpf,
      'data_nascimento' : birthday,
      'altura' : height,
      'peso' : weight,
      'cref' : cref
    };
  }

  String toJson(){
    debugPrint(toMap().toString());
    return json.encode(toMap());
  }
}
