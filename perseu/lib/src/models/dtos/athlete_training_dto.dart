import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:perseu/src/models/dtos/training_dto.dart';

part 'athlete_training_dto.freezed.dart';
part 'athlete_training_dto.g.dart';

@freezed
class AthleteTrainingDTO with _$AthleteTrainingDTO {
  const factory AthleteTrainingDTO({
    required int id,
    required String? lastCheckIn,
    required TrainingDTO training,
  }) = _AthleteTrainingDTO;

  factory AthleteTrainingDTO.fromJson(Map<String, Object?> json) =>
      _$AthleteTrainingDTOFromJson(json);
}
