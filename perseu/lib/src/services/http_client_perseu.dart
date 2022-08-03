import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/requests/invite_request.dart';
import 'package:perseu/src/models/requests/login_request.dart';
import 'package:perseu/src/models/requests/sign_up_request.dart';
import 'package:perseu/src/models/requests/training_request.dart';
import 'package:perseu/src/models/requests/user_request.dart';
import 'package:perseu/src/models/requests/user_update_request.dart';
import 'package:perseu/src/models/user_model.dart';

import '../models/requests/user_request.dart';
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

  Future<Result<UserRequest>> getUser(String email) async {
    return process(
        dio.get('/api/verficarDadosUsuario', queryParameters: {'email': email}),
        onSuccess: (response) {
      final user = UserRequest.fromMap(response.data as Map<String, dynamic>);
      return Result.success(data: user);
    }, onError: (response) {
      return const Result.error(message: 'E-mail já existente');
    });
  }

  Future<Result<String>> createTeam(String teamName, int coachId) async {
    return process(
        dio.post('/api/criarEquipe',
            data: {'nome': teamName, 'treinador_id': coachId}),
        onSuccess: (response) {
          return Result.success(data: response.data['nome']);
        },
        onError: (response) => const Result.error(
            message: 'Falha ao realizar cadastro de equipe'));
  }

  Future<Result<String>> createRequest(
      String requestCode, int athleteId) async {
    return process(
        dio.post('/api/criar-requisicao-equipe',
            data: {'codigo': requestCode, 'atleta': athleteId}),
        onSuccess: (response) {
          return Result.success(data: response.data['status']);
        },
        onError: (response) => const Result.error(
            message: 'Falha ao realizar cadastro de equipe'));
  }

  Future<Result<void>> changeTeamName(String teamName, teamId) {
    return process(
        dio.put('/api/alterar-dados-equipe/$teamId', data: {'nome': teamName}),
        onSuccess: (response) {
          return const Result.success(message: 'Nome alterado com sucesso');
        },
        onError: (response) =>
            const Result.error(message: 'Falha ao alterar nome'));
  }

  Future<Result<LoginRequest>> signUp(SignUpRequest signUpRequest) async {
    FormData body = FormData.fromMap(signUpRequest.toMap());
    return process(dio.post('/auth/register', data: body),
        onSuccess: (response) {
          return const Result.success();
        },
        onError: (response) =>
            const Result.error(message: 'Falha ao realizar cadastro'));
  }

  Future<Result<List<InviteRequest>>> getRequests(int teamId) async {
    await Future.delayed(const Duration(seconds: 5));
    return process(dio.get('/api/buscar-requisicoes-pendentes-equipe/$teamId'),
        onSuccess: (response) {
          var data = response.data as List;
          return Result.success(
              data: data.map((i) => InviteRequest.fromMap(i)).toList());
        },
        onError: (response) => const Result.error(
            message: 'Falha ao buscar solicitações pendentes'));
  }

  Future<Result<void>> acceptRequest(int requestId) async {
    return process(
        dio.put('/api/alteraStatusRequisicao/$requestId',
            data: {'status': 'Aceito'}),
        onSuccess: (response) {
          return const Result.success(message: 'Aceito com sucesso');
        },
        onError: (response) =>
            const Result.error(message: 'Falha ao aceitar solicitação'));
  }

  Future<Result<void>> refuseRequest(int requestId) async {
    return process(
        dio.put('/api/alteraStatusRequisicao/$requestId',
            data: {'status': 'Recusado'}),
        onSuccess: (response) {
          return const Result.success(message: 'Recusado com sucesso');
        },
        onError: (response) =>
            const Result.error(message: 'Falha ao aceitar solicitação'));
  }

  Future<Result<void>> checkEmail(String email) async {
    return process(
        dio.get('/api/verificar-email', queryParameters: {'email': email}),
        onSuccess: (response) {
      return const Result.success(message: 'E-mail disponível');
    }, onError: (response) {
      return const Result.error(message: 'E-mail já existente');
    });
  }

  Future<Result<UserRequest>> updateUser(UserUpdateRequest userUpdate) async {
    return process(
        dio.put('/api/alterarDadosUsuario/${userUpdate.id}',
            data: userUpdate.toJson()),
        onSuccess: (response) {
          final UserRequest data =
              UserRequest.fromMap(response.data as Map<String, dynamic>);

          return Result.success(message: 'Editado com sucesso', data: data);
        },
        onError: (response) =>
            const Result.error(message: 'Falha ao aceitar solicitação'));
  }

  Future<Result<void>> assignTraining(
      TrainingRequest assignTraining) async {
    return process(
        dio.post('/api/criar-treino',
            data: assignTraining.toJson()),
        onSuccess: (response) {
          // ignore: void_checks
          return Result.success(
              message: 'Editado com sucesso', data: response.data);
        },
        onError: (response) =>
            const Result.error(message: 'Falha ao aceitar solicitação'));
  }
}
