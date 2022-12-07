import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import 'training_dto.dart';

part 'athlete_check_dto.freezed.dart';
part 'athlete_check_dto.g.dart';

@freezed
class AthleteCheckDTO with _$AthleteCheckDTO {
  const factory AthleteCheckDTO({
    required int id,
    required int effort,
    required String date,
    required TrainingDTO training,
  }) = _AthleteCheckDTO;

  factory AthleteCheckDTO.fromJson(Map<String, Object?> json) =>
      _$AthleteCheckDTOFromJson(json);
}
