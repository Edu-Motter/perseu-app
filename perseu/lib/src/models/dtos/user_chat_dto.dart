import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_chat_dto.freezed.dart';
part 'user_chat_dto.g.dart';

@freezed
class UserChatDTO with _$UserChatDTO {
  const factory UserChatDTO({
    required int id,
    required String name,
  }) = _UserChatDTO;

  factory UserChatDTO.fromJson(Map<String, Object?> json) =>
      _$UserChatDTOFromJson(json);
}
