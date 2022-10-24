import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:perseu/src/models/dtos/session_dto.dart';

part 'training_dto.freezed.dart';
part 'training_dto.g.dart';

@freezed
class TrainingDTO with _$TrainingDTO {
  const factory TrainingDTO({
    required int id,
    required String name,
    required String createdAt,
    required String updatedAt,
    List<SessionDTO>? sessions,
  }) = _TrainingDTO;

  factory TrainingDTO.fromJson(Map<String, Object?> json) =>
      _$TrainingDTOFromJson(json);
}
