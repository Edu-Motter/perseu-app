import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'updated_athlete_dto.freezed.dart';
part 'updated_athlete_dto.g.dart';

@freezed
class UpdatedAthleteDTO with _$UpdatedAthleteDTO {
  const factory UpdatedAthleteDTO({
    required String name,
    required String document,
    required String birthdate,
    required int weight,
    required int height,
  }) = _UpdatedAthleteDTO;

  factory UpdatedAthleteDTO.fromJson(Map<String, Object?> json) =>
      _$UpdatedAthleteDTOFromJson(json);
}
