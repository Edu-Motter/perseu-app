import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDTO with _$UserDTO {
  const factory UserDTO({
    required int id,
    required String email,
  }) = _UserDTO;

  factory UserDTO.fromJson(Map<String, Object?> json) =>
      _$UserDTOFromJson(json);
}
