import 'package:dio/dio.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/athlete_dto.dart';
import 'package:perseu/src/models/dtos/team_info_dto.dart';
import 'package:perseu/src/models/dtos/user_chat_dto.dart';
import 'package:perseu/src/services/foundation.dart';

class ClientTeam with ApiHelper {
  final dio = locator.get<Dio>();

  Future<Result<List<AthleteDTO>>> getAthletes(
      int teamId, String authToken) async {
    return process(
        dio.get('/team/$teamId/athletes',
            options: Options(headers: {'Authorization': 'Bearer $authToken'})),
        onSuccess: (response) {
      final athletes = response.data as List;
      return Result.success(
          data: athletes.map((i) => AthleteDTO.fromJson(i)).toList());
    }, onError: (response) {
      return const Result.error(message: 'Falha ao atribuir treino');
    });
  }

  Future<Result<int>> getAthletesCount(int teamId, String authToken) async {
    return process(
        dio.get('/team/$teamId/athletes',
            options: Options(headers: {'Authorization': 'Bearer $authToken'})),
        onSuccess: (response) {
      return Result.success(data: (response.data as List).length);
    }, onError: (response) {
      return const Result.error(message: 'Falha ao atribuir treino');
    });
  }


  Future<Result<TeamInfoDTO>> getTeamInfo(int teamId, String authToken) async {
    return process(
        dio.get(
          '/team/$teamId',
          options: Options(headers: {'Authorization': 'Bearer $authToken'}),
        ),
        onSuccess: (response) {
          TeamInfoDTO teamInfo = TeamInfoDTO.fromJson(response.data);
          return Result.success(data: teamInfo);
        },
        onError: (response) =>
        const Result.error(message: 'Falha ao buscar informações do time'));
  }

  Future<Result<List<UserChatDTO>>> getUsers(
      int teamId, String authToken) async {
    return process(
        dio.get('/user/team/$teamId/',
            options: Options(headers: {'Authorization': 'Bearer $authToken'})),
        onSuccess: (response) {
      final users = response.data as List;
      return Result.success(
          data: users.map((i) => UserChatDTO.fromJson(i)).toList());
    }, onError: (response) {
      return const Result.error(message: 'Falha ao atribuir treino');
    });
  }
}
