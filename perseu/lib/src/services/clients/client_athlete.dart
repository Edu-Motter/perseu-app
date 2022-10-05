import 'package:dio/dio.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/services/foundation.dart';

class ClientAthlete with ApiHelper {
  final dio = locator.get<Dio>();

  Future<Result<String>> createRequest(String requestCode, int athleteId) async {
    return process(
        dio.post('/api/criar-requisicao-equipe', data: {'codigo': requestCode, 'atleta': athleteId}),
        onSuccess: (response) {
          return Result.success(data: response.data['status']);
        },
        onError: (response) => const Result.error(
            message: 'Falha ao realizar solicitação para equipe'));
  }

}