import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import 'invite_status.dart';
import 'invited_athlete_dto.dart';

part 'invite_dto.freezed.dart';
part 'invite_dto.g.dart';

@freezed
class InviteDTO with _$InviteDTO {
  const factory InviteDTO({
    required int id,
    required InviteStatus status,
    required InvitedAthleteDTO athlete,
  }) = _InviteDTO;

  factory InviteDTO.fromJson(Map<String, Object?> json) =>
      _$InviteDTOFromJson(json);
}