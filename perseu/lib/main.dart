import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:perseu/src/app/app.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/services/fcm_service.dart';
import 'package:perseu/src/utils/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'perseu',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeLocator();
  final fcmService = locator<FcmService>();
  fcmService.init();

  runApp(const PerseuApp());
}
