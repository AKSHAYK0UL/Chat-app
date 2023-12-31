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
        return macos;
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
    apiKey: 'AIzaSyC6rZkfK2t-Q5wWqawXOOnH1lDX9hfRaoY',
    appId: '1:698694317808:web:674afb52917ea5cc3eb435',
    messagingSenderId: '698694317808',
    projectId: 'nexsocial-588a0',
    authDomain: 'nexsocial-588a0.firebaseapp.com',
    databaseURL: 'https://nexsocial-588a0-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'nexsocial-588a0.appspot.com',
    measurementId: 'G-8WT20LZKHF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAIOK7JUlIAe-pS6sU-UaZhQrpGy6ZsU_g',
    appId: '1:698694317808:android:dee88080f28f5dbf3eb435',
    messagingSenderId: '698694317808',
    projectId: 'nexsocial-588a0',
    databaseURL: 'https://nexsocial-588a0-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'nexsocial-588a0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCNx6dtWHk6yp3HumLPYe7eJ0aoUyLAhF4',
    appId: '1:698694317808:ios:36a61ac7dde4d56a3eb435',
    messagingSenderId: '698694317808',
    projectId: 'nexsocial-588a0',
    databaseURL: 'https://nexsocial-588a0-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'nexsocial-588a0.appspot.com',
    iosBundleId: 'com.example.nexSocial',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCNx6dtWHk6yp3HumLPYe7eJ0aoUyLAhF4',
    appId: '1:698694317808:ios:10d50e3c5279524a3eb435',
    messagingSenderId: '698694317808',
    projectId: 'nexsocial-588a0',
    databaseURL: 'https://nexsocial-588a0-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'nexsocial-588a0.appspot.com',
    iosBundleId: 'com.example.nexSocial.RunnerTests',
  );
}
