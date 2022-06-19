import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:perseu/src/models/requests/user_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session extends ChangeNotifier {
  String? _authToken;
  UserRequest? _user;


  String? get authToken => _authToken;
  UserRequest? get user => _user;
  bool get authenticated => _user != null;

  void setAuthTokenAndUser(String? authToken, UserRequest? user) {
    bool notify = false;
    if (_authToken != authToken) {
      _authToken = authToken;
      notify = true;
    }
    if (_user != user) {
      _user = user;
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
        if(prop != null){
          Map<String, dynamic> test = json.decode(prop);
          if(test['treinador'] != null) test['treinador'] = json.decode(test['treinador']);
          if(test['atleta'] != null) test['atleta'] = json.decode(test['atleta']);
          var userRequest = UserRequest.fromMap(test);
          super.setAuthTokenAndUser(props[authTokenKey],userRequest);
          debugPrint('Returning true');
          return true;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  @override
  void setAuthTokenAndUser(String? authToken, UserRequest? user) {
    super.setAuthTokenAndUser(authToken, user);
    _write(
        {authTokenKey: authToken, userKey: user?.toJson()});
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
