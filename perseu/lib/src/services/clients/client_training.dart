import 'package:dio/dio.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/requests/assign_training.dart';
import 'package:perseu/src/services/foundation.dart';


class ClientTraining with ApiHelper {
  final dio = locator.get<Dio>();

  Future<Result> assignTraining(AssignTrainingRequest assignTraining) async {
    return process(dio.post('/api/criar-treino', data: assignTraining.toJson()),
        onSuccess: (response) {
          return const Result.success(message: 'Treino atribuído com sucesso');
        },
        onError: (response) =>
            const Result.error(message: 'Falha ao atribuir treino'));
  }
}