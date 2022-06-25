import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/requests/login_request.dart';
import 'package:perseu/src/models/requests/sign_up_request.dart';
import 'package:perseu/src/models/user_model.dart';

import 'foundation.dart';

class HttpClientPerseu with ApiHelper {
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

  Future<Result<LoginRequest>> loginRequestRefactor(
      String username, String password) async {
    return process(
        dio.post('/auth/login',
            queryParameters: {'email': username, 'password': password}),
        authErrors: true,
        onSuccess: (response) {
          final loginRequest =
              LoginRequest.fromMap(response.data as Map<String, dynamic>);
          return Result.success(data: loginRequest);
        },
        onError: (response) =>
            const Result.error(message: 'Falha ao realizar login'));
  }

  Future<Result<String>> createTeam(String teamName, int coachId) async {
    return process(
        dio.post('/api/criarEquipe', data: {'nome': teamName, 'treinador_id': coachId}),
        onSuccess: (response) {
          return Result.success(data: response.data['nome']);
        },
        onError: (response) => const Result.error(
            message: 'Falha ao realizar cadastro de equipe'));
  }

  Future<Result<String>> createRequest(String requestCode, int athleteId) async {
    return process(
        dio.post('/api/criar-requisicao-equipe', data: {'codigo': requestCode, 'atleta': athleteId}),
        onSuccess: (response) {
          return Result.success(data: response.data['status']);
        },
        onError: (response) => const Result.error(
            message: 'Falha ao realizar cadastro de equipe'));
  }

  Future<Result<LoginRequest>> signUp(SignUpRequest signUpRequest) async {
    FormData body = FormData.fromMap(signUpRequest.toMap());
    return process(
        dio.post('/auth/register', data: body),
        onSuccess: (response) {
          return const Result.success();
        },
        onError: (response) =>
          const Result.error(message: 'Falha ao realizar cadastro'));
  }
}
