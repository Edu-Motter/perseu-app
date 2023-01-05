import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:perseu/src/models/dtos/athlete_dto.dart';

part 'group_dto.freezed.dart';
part 'group_dto.g.dart';

@freezed
class GroupDTO with _$GroupDTO {
  const factory GroupDTO({
    required int id,
    required String name,
    required List<AthleteDTO> athletes,
  }) = _GroupDTO;

  factory GroupDTO.fromJson(Map<String, Object?> json) =>
      _$GroupDTOFromJson(json);
}
