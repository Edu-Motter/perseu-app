import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:perseu/src/models/dtos/exercise_dto.dart';

part 'session_dto.freezed.dart';
part 'session_dto.g.dart';

@freezed
class SessionDTO with _$SessionDTO {
  const factory SessionDTO({
    required int id,
    required String name,
    required String createdAt,
    required String updatedAt,
    List<ExerciseDTO>? exercises,
  }) = _SessionDTO;

  factory SessionDTO.fromJson(Map<String, Object?> json) =>
      _$SessionDTOFromJson(json);
}
