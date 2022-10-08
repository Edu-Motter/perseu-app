import 'package:freezed_annotation/freezed_annotation.dart';

enum InviteStatus{
  @JsonValue('PENDING')
  pending,

  @JsonValue('ACCEPTED')
  accepted,

  @JsonValue('DECLINED')
  refused,
}