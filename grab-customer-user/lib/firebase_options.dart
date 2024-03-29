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
    apiKey: 'AIzaSyCP_3-ki0ApMEMoxeTnJ3yv-2cpFC7aVtk',
    appId: '1:982285894910:web:b2b457008387beab1351af',
    messagingSenderId: '982285894910',
    projectId: 'grab-intro2sw-96bbf',
    authDomain: 'grab-intro2sw-96bbf.firebaseapp.com',
    storageBucket: 'grab-intro2sw-96bbf.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCBVMTMWKSPn9RyjZmF6C4KdYvmYIPg6Pc',
    appId: '1:982285894910:android:76d788fe01c06b8b1351af',
    messagingSenderId: '982285894910',
    projectId: 'grab-intro2sw-96bbf',
    storageBucket: 'grab-intro2sw-96bbf.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCjdR8Qe2eXuGMlkbkp9rdlfHBBwfexKIk',
    appId: '1:982285894910:ios:b7ee9659f148e9fc1351af',
    messagingSenderId: '982285894910',
    projectId: 'grab-intro2sw-96bbf',
    storageBucket: 'grab-intro2sw-96bbf.appspot.com',
    androidClientId: '982285894910-3a7vfpht2hehcdq2tqm2bd4hono96flb.apps.googleusercontent.com',
    iosClientId: '982285894910-odu4014q60qq8sbjv4cj6hhnn55frgo9.apps.googleusercontent.com',
    iosBundleId: 'com.example.grab',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCjdR8Qe2eXuGMlkbkp9rdlfHBBwfexKIk',
    appId: '1:982285894910:ios:d2fadd077b8362081351af',
    messagingSenderId: '982285894910',
    projectId: 'grab-intro2sw-96bbf',
    storageBucket: 'grab-intro2sw-96bbf.appspot.com',
    androidClientId: '982285894910-3a7vfpht2hehcdq2tqm2bd4hono96flb.apps.googleusercontent.com',
    iosClientId: '982285894910-3t6qc74qop1gfin634aaqn0vb1eeuvgq.apps.googleusercontent.com',
    iosBundleId: 'com.example.grab.RunnerTests',
  );
}
