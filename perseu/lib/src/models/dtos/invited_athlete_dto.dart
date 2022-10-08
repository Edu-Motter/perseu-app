import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:perseu/src/models/dtos/status.dart';

part 'invited_athlete_dto.freezed.dart';
part 'invited_athlete_dto.g.dart';

@freezed
class InvitedAthleteDTO with _$InvitedAthleteDTO {
  const factory InvitedAthleteDTO({
    required int id,
    required String name,
    required String document,
    required String birthdate, //TODO: Transformar em data
    required Status status,
    required int height,
    required int weight,
  }) = _InvitedAthleteDTO;

  factory InvitedAthleteDTO.fromJson(Map<String, Object?> json) =>
      _$InvitedAthleteDTOFromJson(json);
}