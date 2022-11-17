import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'team_info_dto.freezed.dart';
part 'team_info_dto.g.dart';

@freezed
class TeamInfoDTO with _$TeamInfoDTO {
  const factory TeamInfoDTO({
    required int id,
    required String name,
    required String code,
    required String createdAt,
    required String updatedAt,
    required int? numberOfAthletes

  }) = _TeamInfoDTO;

  factory TeamInfoDTO.fromJson(Map<String, Object?> json) =>
      _$TeamInfoDTOFromJson(json);
}