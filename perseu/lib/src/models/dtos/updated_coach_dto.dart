import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'updated_coach_dto.freezed.dart';
part 'updated_coach_dto.g.dart';

@freezed
class UpdatedCoachDTO with _$UpdatedCoachDTO {
  const factory UpdatedCoachDTO({
    required String name,
    required String document,
    required String birthdate,
    required String cref,
  }) = _UpdatedCoachDTO;

  factory UpdatedCoachDTO.fromJson(Map<String, Object?> json) =>
      _$UpdatedCoachDTOFromJson(json);
}
