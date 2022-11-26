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
    apiKey: 'AIzaSyAJoJcsTWRG7W5bazSniYMKopW_JIvNke0',
    appId: '1:251763925269:web:bc077efb48b7ac9059091c',
    messagingSenderId: '251763925269',
    projectId: 'online-technician-849da',
    authDomain: 'online-technician-849da.firebaseapp.com',
    storageBucket: 'online-technician-849da.appspot.com',
    measurementId: 'G-NSM0MFZ1P6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJY83guOIn4l6HfqkpMVMtlf3D1g3_ojE',
    appId: '1:251763925269:android:1f88031ce233b22159091c',
    messagingSenderId: '251763925269',
    projectId: 'online-technician-849da',
    storageBucket: 'online-technician-849da.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDfN9kLOjQHO3JqwK7yySteRc7MDs7-BdI',
    appId: '1:251763925269:ios:d577f3382059896459091c',
    messagingSenderId: '251763925269',
    projectId: 'online-technician-849da',
    storageBucket: 'online-technician-849da.appspot.com',
    androidClientId: '251763925269-vcb33nocvill7iv6geopr2rhnosj1krj.apps.googleusercontent.com',
    iosClientId: '251763925269-pgntt0ad2ilghv84csf1qlfkgqcfcan5.apps.googleusercontent.com',
    iosBundleId: 'com.onlinetechnician.onlineTechnician',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDfN9kLOjQHO3JqwK7yySteRc7MDs7-BdI',
    appId: '1:251763925269:ios:d577f3382059896459091c',
    messagingSenderId: '251763925269',
    projectId: 'online-technician-849da',
    storageBucket: 'online-technician-849da.appspot.com',
    androidClientId: '251763925269-vcb33nocvill7iv6geopr2rhnosj1krj.apps.googleusercontent.com',
    iosClientId: '251763925269-pgntt0ad2ilghv84csf1qlfkgqcfcan5.apps.googleusercontent.com',
    iosBundleId: 'com.onlinetechnician.onlineTechnician',
  );
}
