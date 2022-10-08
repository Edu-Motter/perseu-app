import 'package:dio/dio.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/services/foundation.dart';

class ClientAthlete with ApiHelper {
  final dio = locator.get<Dio>();

  Future<Result<String>> createRequest(
      String requestCode, int athleteId, String jwt) async {
    return process(
        dio.post(
          '/athlete/$athleteId/request',
          data: {'code': requestCode},
          options: Options(headers: {'Authorization': 'Bearer $jwt'}),
        ),
        onSuccess: (response) {
          return Result.success(data: response.data['status']);
        },
        onError: (response) => const Result.error(
            message: 'Falha ao realizar solicitação para equipe'));
  }

  Future<Result<String>> getRequestByAthlete(int athleteId, String jwt) async {
    return process(
        dio.get(
          '/athlete/$athleteId/request',
          options: Options(headers: {'Authorization': 'Bearer $jwt'}),
        ),
        onSuccess: (response) {
          return Result.success(data: response.data['status']);
        },
        onError: (response) => const Result.error(
            message: 'Falha ao buscar solicitação'));
  }

  Future<Result<String>> cancelRequest(int athleteId, String jwt) async {
    return process(
        dio.delete(
          '/athlete/$athleteId/request/cancel',
          options: Options(headers: {'Authorization': 'Bearer $jwt'}),
        ),
        onSuccess: (response) {
          return Result.success(data: response.data['status']);
        },
        onError: (response) => const Result.error(
            message: 'Falha ao cancelar solictiação'));
  }
}
