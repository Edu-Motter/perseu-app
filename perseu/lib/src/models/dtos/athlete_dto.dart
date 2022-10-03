import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'athlete_dto.freezed.dart';
part 'athlete_dto.g.dart';

@freezed
class AthleteDTO with _$AthleteDTO {
  const factory AthleteDTO({
    required int id,
    required String name,
  }) = _AthleteDTO;

  factory AthleteDTO.fromJson(Map<String, Object?> json) =>
      _$AthleteDTOFromJson(json);
}
