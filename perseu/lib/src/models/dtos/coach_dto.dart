import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'coach_dto.freezed.dart';
part 'coach_dto.g.dart';

@freezed
class CoachDTO with _$CoachDTO {
  const factory CoachDTO({
    required int id,
    required String name,
  }) = _CoachDTO;

  factory CoachDTO.fromJson(Map<String, Object?> json) =>
      _$CoachDTOFromJson(json);
}
