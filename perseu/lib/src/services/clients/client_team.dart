import 'package:dio/dio.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/athlete_dto.dart';
import 'package:perseu/src/models/dtos/group_dto.dart';
import 'package:perseu/src/models/dtos/group_name_dto.dart';
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
    await Future.delayed(const Duration(milliseconds: 600));
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

  Future<Result> createGroup(
    String groupName,
    List<int> athletes,
    int teamId,
    String authToken,
  ) async {
    return process(
      dio.post(
        '/team/$teamId/group',
        data: {'name': groupName, 'athletes': athletes},
        options: Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      ),
      onSuccess: (response) {
        return Result.success(
            message: 'Sucesso ao criar grupo', data: response.data);
      },
      onError: (response) {
        return const Result.error(message: 'Falha ao criar grupo');
      },
    );
  }

  Future<Result<List<GroupNameDTO>>> getGroups(
    String authToken,
    int teamId,
  ) {
    return process(
      dio.get(
        '/team/$teamId/group',
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      ),
      onSuccess: (response) {
        final data = response.data as List;
        return Result.success(
            data: data.map((e) => GroupNameDTO.fromJson(e)).toList());
      },
      onError: (response) =>
          const Result.error(message: 'Falha ao buscar grupos'),
    );
  }

  Future<Result<GroupDTO>> getGroupDetails(
    String authToken,
    int groupId,
  ) {
    return process(
      dio.get(
        '/group/$groupId',
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      ),
      onSuccess: (response) =>
          Result.success(data: GroupDTO.fromJson(response.data)),
      onError: (response) =>
          const Result.error(message: 'Falha ao buscar grupos'),
    );
  }
}
