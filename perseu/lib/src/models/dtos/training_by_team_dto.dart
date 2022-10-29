import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'training_by_team_dto.freezed.dart';
part 'training_by_team_dto.g.dart';

@freezed
class TrainingByTeamDTO with _$TrainingByTeamDTO {
  const factory TrainingByTeamDTO({
    required int id,
    required String name,
  }) = _TrainingByTeamDTO;

  factory TrainingByTeamDTO.fromJson(Map<String, Object?> json) =>
      _$TrainingByTeamDTOFromJson(json);
}
