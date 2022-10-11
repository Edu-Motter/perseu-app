import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/invite_dto.dart';
import 'package:perseu/src/models/dtos/team_info_dto.dart';
import 'package:perseu/src/models/dtos/updated_coach_dto.dart';
import 'package:perseu/src/services/foundation.dart';

class ClientCoach with ApiHelper {
  final dio = locator.get<Dio>();

  Future<Result<String>> createTeam(
      String teamName, int coachId, String authToken) async {
    return process(
        dio.post(
          '/team/$coachId',
          options: Options(headers: {'Authorization': 'Bearer $authToken'}),
          data: {'name': teamName},
        ),
        onSuccess: (response) {
          return Result.success(data: response.data['name']);
        },
        onError: (response) => const Result.error(
            message: 'Falha ao realizar cadastro de equipe'));
  }

  Future<Result<void>> changeTeamName(
      String teamName, int teamId, String authToken) {
    return process(
        dio.patch(
          '/team/$teamId',
          data: {'name': teamName},
          options: Options(
            headers: {'Authorization': 'Bearer $authToken'},
          ),
        ),
        onSuccess: (response) {
          return const Result.success(message: 'Nome alterado com sucesso');
        },
        onError: (response) =>
            const Result.error(message: 'Falha ao alterar nome'));
  }

  Future<Result<List<InviteDTO>>> getRequests(
      int teamId, String authToken) async {
    await Future.delayed(const Duration(seconds: 5));
    return process(
        dio.get(
          '/team/$teamId/request',
          options: Options(headers: {'Authorization': 'Bearer $authToken'}),
        ),
        onSuccess: (response) {
          final data = response.data as List;
          return Result.success(
              data: data.map((i) => InviteDTO.fromJson(i)).toList());
        },
        onError: (response) => const Result.error(
            message: 'Falha ao buscar solicitações pendentes'));
  }

  Future<Result<TeamInfoDTO>> getTeamInfo(int teamId, String authToken) async {
    return process(
        dio.get(
          '/team/$teamId',
          options: Options(headers: {'Authorization': 'Bearer $authToken'}),
        ),
        onSuccess: (response) {
          debugPrint(response.data.toString());
          TeamInfoDTO teamInfo = TeamInfoDTO.fromJson(response.data);
          return Result.success(data: teamInfo);
        },
        onError: (response) =>
            const Result.error(message: 'Falha ao buscar informações do time'));
  }

  Future<Result<void>> acceptRequest(int athleteId, String authToken) async {
    return process(
        dio.patch(
          '/athlete/$athleteId/request/accept',
          options: Options(headers: {'Authorization': 'Bearer $authToken'}),
        ),
        onSuccess: (response) {
          return const Result.success(message: 'Aceito com sucesso');
        },
        onError: (response) =>
            const Result.error(message: 'Falha ao aceitar solicitação'));
  }

  Future<Result<void>> declineRequest(int athleteId, String authToken) async {
    return process(
        dio.patch(
          '/athlete/$athleteId/request/decline',
          options: Options(headers: {'Authorization': 'Bearer $authToken'}),
        ),
        onSuccess: (response) {
          return const Result.success(message: 'Recusado com sucesso');
        },
        onError: (response) =>
            const Result.error(message: 'Falha ao aceitar solicitação'));
  }

  Future<Result> getCoach(int coachId, String authToken) async {
    return process(
        dio.get(
          '/coach/$coachId',
          options: Options(headers: {'Authorization': 'Bearer $authToken'}),
        ),
        onSuccess: (response) {
          return Result.success(data: response.data);
        },
        onError: (response) => const Result.error(
            message: 'Falha ao buscar informações do treinador'));
  }

  Future<Result> updateCoach(
      UpdatedCoachDTO updatedCoach,
      int coachId,
      String authToken,
      ) async {
    return process(
        dio.put(
          '/coach/$coachId',
          data: updatedCoach.toJson(),
          options: Options(headers: {'Authorization': 'Bearer $authToken'}),
        ),
        onSuccess: (response) {
          return Result.success(data: response.data);
        },
        onError: (response) => const Result.error(
            message: 'Falha ao atualizar seu perfil'));
  }

}
