import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:perseu/src/models/dtos/athlete_dto.dart';
import 'package:perseu/src/models/dtos/coach_dto.dart';
import 'package:perseu/src/models/dtos/status.dart';
import 'package:perseu/src/models/dtos/team_dto.dart';
import 'package:perseu/src/models/dtos/user_dto.dart';

part 'login_dto.freezed.dart';
part 'login_dto.g.dart';

@freezed
class LoginDTO with _$LoginDTO {
  factory LoginDTO({
    required String token,
    required UserDTO user,
    required Status status,
    AthleteDTO? athlete,
    CoachDTO? coach,
    TeamDTO? team,
  }) = _LoginDTO;

  factory LoginDTO.fromJson(Map<String, Object?> json) =>
      _$LoginDTOFromJson(json);
}
