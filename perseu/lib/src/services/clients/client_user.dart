import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/login_dto.dart';
import 'package:perseu/src/models/requests/sign_up_request.dart';
import 'package:perseu/src/models/requests/user_request.dart';
import 'package:perseu/src/models/requests/user_update_request.dart';
import 'package:perseu/src/services/foundation.dart';

class ClientUser with ApiHelper {
  final dio = locator.get<Dio>();

  Future<Result> signUpAthlete(
      SignUpAthleteRequest signUpAthleteRequest) async {
    return process(dio.post('/athlete', data: signUpAthleteRequest.toJson()),
        onSuccess: (response) {
          return const Result.success();
        },
        onError: (response) =>
            const Result.error(message: 'Falha ao realizar cadastro'));
  }

  Future<Result> signUpCoach(SignUpCoachRequest signUpCoachRequest) async {
    return process(dio.post('/coach', data: signUpCoachRequest.toJson()),
        onSuccess: (response) {
          return const Result.success();
        },
        onError: (response) =>
            const Result.error(message: 'Falha ao realizar cadastro'));
  }

  Future<Result<LoginDTO>> loginRequest(
      String username, String password) async {
    final body = jsonEncode({'email': username, 'password': password});
    return process(dio.post('/login', data: body),
        authErrors: true,
        onSuccess: (response) {
          final login = LoginDTO.fromJson(response.data);
          return Result.success(data: login);
        },
        onError: (response) =>
            const Result.error(message: 'E-mail ou senha inválidos'));
  }

  Future<Result<LoginDTO>> getUser(String token) async {
    return process(dio.post('/login/check', data: {'token': token}),
        onSuccess: (response) {
      final login = LoginDTO.fromJson(response.data);
      return Result.success(data: login);
    }, onError: (response) {
      return const Result.error(message: 'E-mail já existente');
    });
  }

  Future<Result<String>> getUserName(int userId, String token) async {
    return process(
        dio.get(
          '/user/$userId/name',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        ), onSuccess: (response) {
      final name = response.data['name'];
      return Result.success(data: name);
    }, onError: (response) {
      return const Result.error(message: 'Usuário não encontrado');
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

  Future<Result<void>> changePassword(
      String newPassword, String oldPassword, int userId, String jwt) async {
    return process(
        dio.patch(
          '/user/$userId/password',
          data: {'newPassword': newPassword, 'oldPassword': oldPassword},
          options: Options(headers: {'Authorization': 'Bearer $jwt'}),
        ),
        onSuccess: (response) {
          return const Result.success();
        },
        onError: (response) =>
            const Result.error(message: 'Falha ao alterar senha'));
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
}
