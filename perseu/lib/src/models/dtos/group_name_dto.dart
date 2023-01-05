import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_name_dto.freezed.dart';
part 'group_name_dto.g.dart';

@freezed
class GroupNameDTO with _$GroupNameDTO {
  const factory GroupNameDTO({
    required int id,
    required String name,
  }) = _GroupNameDTO;

  factory GroupNameDTO.fromJson(Map<String, Object?> json) =>
      _$GroupNameDTOFromJson(json);
}
