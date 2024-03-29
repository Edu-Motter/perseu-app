// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB5AW2kLZBVVL-icI5hRJ13-LL9bxocGsY',
    appId: '1:402995173964:web:e44d88fc1a766b9e3a72e9',
    messagingSenderId: '402995173964',
    projectId: 'perseu-76901',
    authDomain: 'perseu-76901.firebaseapp.com',
    storageBucket: 'perseu-76901.appspot.com',
    measurementId: 'G-B75N5Z102V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAwp7GDEQz19lezYYSguRj4iLpnniNbB8g',
    appId: '1:402995173964:android:5151773c6f1d2b9e3a72e9',
    messagingSenderId: '402995173964',
    projectId: 'perseu-76901',
    storageBucket: 'perseu-76901.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAvn-Edf5gt-5ruNzezTZg3huxiQD0ifuk',
    appId: '1:402995173964:ios:22627a2f73594d433a72e9',
    messagingSenderId: '402995173964',
    projectId: 'perseu-76901',
    storageBucket: 'perseu-76901.appspot.com',
    iosClientId: '402995173964-oelfp8487oe6s98a4cr6cvckn946q6vh.apps.googleusercontent.com',
    iosBundleId: 'com.example.perseu',
  );
}
