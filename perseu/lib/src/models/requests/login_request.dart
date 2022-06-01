import 'package:perseu/src/models/requests/token_request.dart';
import 'package:perseu/src/models/requests/user_request.dart';

class LoginRequest {
  final UserRequest user;
  final TokenRequest token;

  LoginRequest({required this.user, required this.token});

  Map<String, dynamic> toMap() {
    return {
      'usuario' : user,
      'login' : token
    };
  }

  factory LoginRequest.fromMap(Map<String, dynamic> map){
    return LoginRequest(user: UserRequest.fromMap(map['usuario']), token: TokenRequest.fromMap(map['login']));
  }
}