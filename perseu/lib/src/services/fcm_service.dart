import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:perseu/src/services/clients/client_firebase.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/session.dart';

import '../app/locator.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: \nMessage:");
  if (message.data.containsKey('msg')) {
    debugPrint(message.data['msg'].toString());
  } else {
    debugPrint('msg key is empty');
  }
}

class FcmService {
  final clientFirebase = locator<ClientFirebase>();

  void init() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      final session = locator<PersistentSession>();
      final userId = session.userSession!.user.id;
      final authToken = session.authToken!;

      saveDeviceToken(fcmToken, userId, authToken);
    }).onError((err) {
      debugPrint('REFRESH TOKEN ERROR: $err');
    });
  }

  Future<String?> getDeviceToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<Result> saveDeviceToken(
      String deviceToken, int userId, String authToken) async {
    return await clientFirebase.saveDeviceToken(deviceToken, userId, authToken);
  }

  Future<Result<String>> getDeviceTokenFromServer(
      int userId, String authToken) async {
    return await clientFirebase.getDeviceToken(userId, authToken);
  }
}
