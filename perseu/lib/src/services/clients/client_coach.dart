import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/team_info_dto.dart';
import 'package:perseu/src/models/requests/invite_request.dart';
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

  Future<Result<void>> changeTeamName(String teamName, teamId) {
    return process(
        dio.put('/api/alterar-dados-equipe/$teamId', data: {'nome': teamName}),
        onSuccess: (response) {
          return const Result.success(message: 'Nome alterado com sucesso');
        },
        onError: (response) =>
            const Result.error(message: 'Falha ao alterar nome'));
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

  Future<Result<TeamInfoDTO>> getTeamInfo(int teamId, String authToken) async {
    return process(dio.get('/team/$teamId', options: Options(headers: {'Authorization': 'Bearer $authToken'}),),
        onSuccess: (response) {
          debugPrint(response.data.toString());
          TeamInfoDTO teamInfo = TeamInfoDTO.fromJson(response.data);
          return Result.success(data: teamInfo);
        },
        onError: (response) =>
            const Result.error(message: 'Falha ao buscar informações do time'));
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
}
