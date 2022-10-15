import 'package:dio/dio.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/athlete_dto.dart';
import 'package:perseu/src/models/dtos/training_dto.dart';
import 'package:perseu/src/models/requests/assign_training.dart';
import 'package:perseu/src/services/foundation.dart';

class ClientTeam with ApiHelper {
  final dio = locator.get<Dio>();

  Future<Result<List<AthleteDTO>>> getAthletes(int teamId, String jwt) async {
    return process(
        dio.get('/team/$teamId/athletes',
            options: Options(headers: {'Authorization': 'Bearer $jwt'})),
        onSuccess: (response) {
      final athletes = response.data as List;
      return Result.success(data: athletes.map((i) => AthleteDTO.fromJson(i)).toList());
    }, onError: (response) {
      return const Result.error(message: 'Falha ao atribuir treino');
    });
  }
}
