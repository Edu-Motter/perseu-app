import 'dart:io';

import 'package:dio/dio.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/athlete_check_dto.dart';
import 'package:perseu/src/models/dtos/athlete_training_dto.dart';
import 'package:perseu/src/models/dtos/training_dto.dart';
import 'package:perseu/src/models/dtos/updated_athlete_dto.dart';
import 'package:perseu/src/services/foundation.dart';

import '../../models/dtos/group_name_dto.dart';

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
        onError: (response) =>
            const Result.error(message: 'Falha ao buscar solicitação'));
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
        onError: (response) =>
            const Result.error(message: 'Falha ao cancelar solicitação'));
  }

  Future<Result> getAthlete(int athleteId, String authToken) async {
    return process(
        dio.get(
          '/athlete/$athleteId',
          options: Options(headers: {'Authorization': 'Bearer $authToken'}),
        ),
        onSuccess: (response) {
          return Result.success(data: response.data);
        },
        onError: (response) => const Result.error(
            message: 'Falha ao buscar informações do atleta'));
  }

  Future<Result> updateAthlete(
    UpdatedAthleteDTO updatedAthlete,
    int athleteId,
    String authToken,
  ) async {
    return process(
        dio.put(
          '/athlete/$athleteId',
          data: updatedAthlete.toJson(),
          options: Options(headers: {'Authorization': 'Bearer $authToken'}),
        ),
        onSuccess: (response) {
          return Result.success(data: response.data);
        },
        onError: (response) =>
            const Result.error(message: 'Falha ao atualizar seu perfil'));
  }

  Future<Result<TrainingDTO>> getCurrentTraining(
    String authToken,
    int athleteId,
  ) {
    return process(
        dio.get(
          '/athlete/$athleteId/training/current',
          options: Options(headers: {'Authorization': 'Bearer $authToken'}),
        ),
        onSuccess: (response) =>
            Result.success(data: TrainingDTO.fromJson(response.data)),
        onError: (dynamic error) {
          Response? response = (error as DioError).response;
          if (HttpStatus.notFound == response?.statusCode) {
            return Result.notFound(
                message: response?.data['message'] ?? 'Não encontrado');
          }
          return const Result.error(message: 'Falha ao buscar treinos');
        });
  }

  Future<Result<List<AthleteTrainingDTO>>> getActiveTrainings(
    String authToken,
    int athleteId,
  ) {
    return process(
      dio.get(
        '/athlete/$athleteId/training',
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      ),
      onSuccess: (response) {
        final athleteTrainings = (response.data as List)
            .map((i) => AthleteTrainingDTO.fromJson(i))
            .toList();
        return Result.success(data: athleteTrainings);
      },
      onError: (response) =>
          const Result.error(message: 'Falha ao buscar treinos'),
    );
  }

  Future<Result<List<AthleteCheckDTO>>> getAthleteChecks(
    int athleteId,
    String authToken,
  ) {
    return process(
      dio.get(
        '/athlete/$athleteId/check-in',
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      ),
      onSuccess: (response) {
        final athleteChecks = (response.data as List)
            .map((i) => AthleteCheckDTO.fromJson(i))
            .toList();
        return Result.success(data: athleteChecks);
      },
      onError: (response) =>
          const Result.error(message: 'Falha ao buscar check-ins'),
    );
  }


  Future<Result<List<GroupNameDTO>>> getAthleteGroups(
      String authToken,
      int athleteId,
      ) {
    return process(
      dio.get(
        '/athlete/$athleteId/group',
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
}
