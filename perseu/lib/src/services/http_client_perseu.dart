import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/user_model.dart';

class HttpClientPerseu {
  final dio = locator.get<Dio>();

  Future<UserModel> loginRequest(String username, String password) async {
    Response response = await dio.post('/auth/login',
        queryParameters: {'email': username, 'password': password});
    debugPrint(response.statusCode.toString());

    if (response.data == null || response.data == 'Not allow') {
      throw "Internal Erro";
    }

    return UserModel.fromMap(response.data as Map<String, dynamic>);
  }
}
