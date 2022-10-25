import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:perseu/src/models/dtos/status.dart';

part 'athlete_info_dto.freezed.dart';
part 'athlete_info_dto.g.dart';

@freezed
class AthleteInfoDTO with _$AthleteInfoDTO {
  const factory AthleteInfoDTO({
    required int id,
    required String name,
    required String document,
    required String birthdate,
    required Status status,
    required int height,
    required int weight,
  }) = _AthleteInfoDTO;

  factory AthleteInfoDTO.fromJson(Map<String, Object?> json) =>
      _$AthleteInfoDTOFromJson(json);
}
