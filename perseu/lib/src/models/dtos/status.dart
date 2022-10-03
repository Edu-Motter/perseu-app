import 'package:freezed_annotation/freezed_annotation.dart';

enum Status {
  @JsonValue('ATHLETE_WITH_TEAM')
  athleteWithTeam,

  @JsonValue('ATHLETE_WITH_PENDING_TEAM')
  athleteWithPendingTeam,

  @JsonValue('ATHLETE_WITHOUT_TEAM')
  athleteWithoutTeam,

  @JsonValue('COACH_WITH_TEAM')
  coachWithTeam,

  @JsonValue('COACH_WITHOUT_TEAM')
  coachWithoutTeam,

  @JsonValue('UNKNOWN')
  unknown
}