import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'exercise_dto.freezed.dart';
part 'exercise_dto.g.dart';

@freezed
class ExerciseDTO with _$ExerciseDTO {
  const factory ExerciseDTO({
    required int id,
    required String name,
    required String description,
    required String createdAt,
    required String updatedAt,
  }) = _ExerciseDTO;

  factory ExerciseDTO.fromJson(Map<String, Object?> json) =>
      _$ExerciseDTOFromJson(json);
}
