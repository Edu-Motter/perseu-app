class TokenRequest {
  final String type;
  final String token;
  final String refreshToken;

  TokenRequest(
      {required this.type, required this.token, required this.refreshToken});

  Map<String, dynamic> toMap() {
    return {'type': type, 'token': token, 'refreshToken': refreshToken};
  }

  factory TokenRequest.fromMap(Map<String, dynamic> map) {
    return TokenRequest(
        type: map['type'],
        token: map['token'],
        refreshToken: map['refreshToken']);
  }
}
