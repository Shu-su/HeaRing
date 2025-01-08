// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDbSTLnaJynvkf2ycw0GNnbhBnBoF7_OWk',
    appId: '1:470928698645:web:93580834616988bb1d4d1c',
    messagingSenderId: '470928698645',
    projectId: 'hearing-3e9c3',
    authDomain: 'hearing-3e9c3.firebaseapp.com',
    storageBucket: 'hearing-3e9c3.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBmPIdpy3xNftWtORDWzquV5x9r9DLOQ5w',
    appId: '1:470928698645:android:d0ee931bc37bdb5e1d4d1c',
    messagingSenderId: '470928698645',
    projectId: 'hearing-3e9c3',
    storageBucket: 'hearing-3e9c3.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDbSTLnaJynvkf2ycw0GNnbhBnBoF7_OWk',
    appId: '1:470928698645:web:ac560ac189730cd71d4d1c',
    messagingSenderId: '470928698645',
    projectId: 'hearing-3e9c3',
    authDomain: 'hearing-3e9c3.firebaseapp.com',
    storageBucket: 'hearing-3e9c3.appspot.com',
  );
}