import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'team_dto.freezed.dart';
part 'team_dto.g.dart';

@freezed
class TeamDTO with _$TeamDTO {
  const factory TeamDTO({
    required int id,
    required String name,
  }) = _TeamDTO;

  factory TeamDTO.fromJson(Map<String, Object?> json) =>
      _$TeamDTOFromJson(json);
}
