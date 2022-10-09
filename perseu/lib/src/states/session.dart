import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:perseu/src/models/dtos/athlete_dto.dart';
import 'package:perseu/src/models/dtos/coach_dto.dart';
import 'package:perseu/src/models/dtos/login_dto.dart';
import 'package:perseu/src/models/dtos/status.dart';
import 'package:perseu/src/models/dtos/team_dto.dart';
import 'package:perseu/src/models/dtos/user_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session extends ChangeNotifier {
  String? _authToken;
  UserSession? _userSession;

  String? get authToken => _authToken;
  UserSession? get userSession => _userSession;
  bool get authenticated => _userSession != null;

  void setAuthTokenAndUser(String? authToken, LoginDTO? login) {
    final userSession = login != null ? UserSession.fromLogin(login) : null;

    bool notify = false;
    if (_authToken != authToken) {
      _authToken = authToken;
      notify = true;
    }
    if (_userSession != userSession) {
      _userSession = userSession;
      notify = true;
    }
    if (notify) {
      notifyListeners();
    }
  }

  void reset() {
    setAuthTokenAndUser(null, null);
  }

  /// Session padrão (não persistente) sempre retorna false
  /// Ver também (see [PersistentSession])
  Future<bool> load() {
    return Future.value(false);
  }
}

class PersistentSession extends Session {
  static const String authTokenKey = 'authToken';
  static const String userKey = 'user';

  @override
  Future<bool> load() async {
    try {
      final props = await _read([authTokenKey, userKey]);
      if (props[authTokenKey] != null && props[userKey] != null) {
        var prop = props[userKey];
        if (prop != null) {
          super.setAuthTokenAndUser(
            props[authTokenKey],
            LoginDTO.fromJson(json.decode(props[userKey]!)),
          );
          debugPrint('Loaded user session with success');
          return true;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  @override
  void setAuthTokenAndUser(String? authToken, LoginDTO? login) {
    super.setAuthTokenAndUser(authToken, login);
    _write({authTokenKey: authToken, userKey: jsonEncode(login?.toJson())});
  }

  Future<void> _write(Map<String, String?> props) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      for (final key in props.keys) {
        prefs.setString(key, props[key]!);
      }
    } catch (_) {}
  }

  Future<Map<String?, String?>> _read(List<String> keys) async {
    final props = <String?, String?>{};
    try {
      final prefs = await SharedPreferences.getInstance();
      for (final key in keys) {
        props[key] = prefs.getString(key);
      }
    } catch (_) {}
    return props;
  }
}

class UserSession extends ChangeNotifier {
  Status status;
  UserDTO user;
  AthleteDTO? athlete;
  CoachDTO? coach;
  TeamDTO? team;

  UserSession(this.status, this.user);

  factory UserSession.fromLogin(LoginDTO login) {
    final userSession = UserSession(login.status, login.user);
    userSession.team = login.team;
    userSession.athlete = login.athlete;
    userSession.coach = login.coach;
    return userSession;
  }

  bool get isAthlete => athlete != null;
  bool get isCoach => coach != null;
  bool get isWithTeam => team != null;
}
