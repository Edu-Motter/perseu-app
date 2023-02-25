import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/athlete_info_dto.dart';
import 'package:perseu/src/models/dtos/athlete_training_dto.dart';
import 'package:perseu/src/models/dtos/training_dto.dart';
import 'package:perseu/src/services/clients/client_athlete.dart';
import 'package:perseu/src/services/clients/client_coach.dart';
import 'package:perseu/src/services/clients/client_training.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../models/dtos/athlete_check_dto.dart';

class AthleteTrainingsDetailsViewModel extends AppViewModel {
  ClientCoach clientCoach = locator<ClientCoach>();
  ClientAthlete clientAthlete = locator<ClientAthlete>();
  ClientTraining clientTraining = locator<ClientTraining>();

  String get authToken => session.authToken!;
  int get teamId => session.userSession!.team!.id;
  TrainingDTO? training;
  int athletesChecksCount = 0;

  Future<Result<TrainingDTO>> getTraining(int trainingId) async {
    Result<TrainingDTO> result =
        await clientCoach.getTraining(authToken, trainingId);
    if (result.success) training = result.data;
    return result;
  }

  Future<Result<TrainingDTO>> getCurrentTraining(int athleteId) async {
    Result<TrainingDTO> result =
        await clientAthlete.getCurrentTraining(authToken, athleteId);
    if (result.success) training = result.data;
    return result;
  }

  Future<bool> isJustOneTraining(int athleteId) async {
    Result<List<AthleteTrainingDTO>> result =
        await clientAthlete.getActiveTrainings(authToken, athleteId);

    if (result.error) return false;

    return result.data!.length > 1;
  }

  Future<Result<Object?>> getActiveTrainings(
    int athleteId,
  ) async {
    Result<List<AthleteTrainingDTO>> result =
        await clientAthlete.getActiveTrainings(authToken, athleteId);
    Result<TrainingDTO> resultCurrent =
        await clientAthlete.getCurrentTraining(authToken, athleteId);

    if (result.error) return result;

    if (resultCurrent.error) return resultCurrent;

    final activeTrainings = result.data!;
    final currentTraining = resultCurrent.data!;
    activeTrainings.removeWhere((e) => e.training.id == currentTraining.id);
    return Result.success(data: activeTrainings);
  }

  Future<Result<String>> deactivateTraining(
    int athleteId,
    int trainingId,
  ) async {
    Result<String> result = await clientTraining.deactivateTraining(
      athleteId,
      trainingId,
      authToken,
    );
    return result;
  }

  Future<Result<AthleteInfoDTO>> getAthleteInfo(int athleteId) async {
    final result =
        await clientAthlete.getAthlete(athleteId, session.authToken!);
    if (result.success) {
      athletesChecksCount = await getAthleteChecksCount(athleteId);
      return Result.success(data: AthleteInfoDTO.fromJson(result.data));
    }
    return Result.error(message: result.message);
  }

  Future<int> getAthleteChecksCount(int athleteId) async {
    Result<List<AthleteCheckDTO>> athleteChecksResult =
        await clientAthlete.getAthleteChecks(athleteId, authToken);
    final checks = athleteChecksResult.data!;
    return checks.length;
  }
}
