import 'package:dio/dio.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/requests/login_request.dart';
import 'package:perseu/src/models/requests/sign_up_request.dart';
import 'package:perseu/src/models/requests/user_request.dart';
import 'package:perseu/src/models/requests/user_update_request.dart';
import 'package:perseu/src/services/foundation.dart';

class ClientUser with ApiHelper {
  final dio = locator.get<Dio>();

  Future<Result<LoginRequest>> signUp(SignUpRequest signUpRequest) async {
    FormData body = FormData.fromMap(signUpRequest.toMap());
    return process(dio.post('/auth/register', data: body),
        onSuccess: (response) {
          return const Result.success();
        },
        onError: (response) =>
            const Result.error(message: 'Falha ao realizar cadastro'));
  }

  Future<Result<LoginRequest>> loginRequest(
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
      String newPassword, String oldPassword, int userId) async {
    return process(
        dio.put('/api/alterarSenha', data: {
          'user_id': userId,
          'newPassword': newPassword,
          'oldPassword': oldPassword
        }),
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
