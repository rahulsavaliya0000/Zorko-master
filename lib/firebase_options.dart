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
    apiKey: 'AIzaSyCNjbVKrXgjJEMGfQzmWMAuPfP869KlyMo',
    appId: '1:555650182020:web:78c94c0476669c12ab4bd1',
    messagingSenderId: '555650182020',
    projectId: 'zorko-158ad',
    authDomain: 'zorko-158ad.firebaseapp.com',
    storageBucket: 'zorko-158ad.appspot.com',
    measurementId: 'G-YEG73F1GGW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB1_RZo1UjbunegxsA8hpB89m9AV6kiHKM',
    appId: '1:555650182020:android:78adbb07aa2c6f00ab4bd1',
    messagingSenderId: '555650182020',
    projectId: 'zorko-158ad',
    storageBucket: 'zorko-158ad.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCkd6ODnZ3w-GZ3kTyNREjvh5CwV5mQiMg',
    appId: '1:555650182020:ios:a82b567f7033de01ab4bd1',
    messagingSenderId: '555650182020',
    projectId: 'zorko-158ad',
    storageBucket: 'zorko-158ad.appspot.com',
    iosBundleId: 'com.example.hack',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCkd6ODnZ3w-GZ3kTyNREjvh5CwV5mQiMg',
    appId: '1:555650182020:ios:1a4872cfff1ce147ab4bd1',
    messagingSenderId: '555650182020',
    projectId: 'zorko-158ad',
    storageBucket: 'zorko-158ad.appspot.com',
    iosBundleId: 'com.example.hack.RunnerTests',
  );
}
