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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyBckO5KGM5ZsKdSKiivsmy6FYmn58g7W9Q',
    appId: '1:730123638566:web:66a32d682bae2c98eb13e7',
    messagingSenderId: '730123638566',
    projectId: 'project-92157',
    authDomain: 'project-92157.firebaseapp.com',
    storageBucket: 'project-92157.appspot.com',
    measurementId: 'G-LC1KWS90PC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCB0sRy_DRPewMhNayfoP6HEulrOurRo38',
    appId: '1:730123638566:android:9cab1ddf3082c8b5eb13e7',
    messagingSenderId: '730123638566',
    projectId: 'project-92157',
    storageBucket: 'project-92157.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB0siwNZwYaS_ZpsxJZdx44KQXmff4WwAM',
    appId: '1:730123638566:ios:a672de25bec8de34eb13e7',
    messagingSenderId: '730123638566',
    projectId: 'project-92157',
    storageBucket: 'project-92157.appspot.com',
    iosBundleId: 'com.example.project',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB0siwNZwYaS_ZpsxJZdx44KQXmff4WwAM',
    appId: '1:730123638566:ios:a672de25bec8de34eb13e7',
    messagingSenderId: '730123638566',
    projectId: 'project-92157',
    storageBucket: 'project-92157.appspot.com',
    iosBundleId: 'com.example.project',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBckO5KGM5ZsKdSKiivsmy6FYmn58g7W9Q',
    appId: '1:730123638566:web:544f1a40539f409aeb13e7',
    messagingSenderId: '730123638566',
    projectId: 'project-92157',
    authDomain: 'project-92157.firebaseapp.com',
    storageBucket: 'project-92157.appspot.com',
    measurementId: 'G-1NV34430J2',
  );

}