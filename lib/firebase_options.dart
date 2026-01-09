import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDyq3vEkutpwh0omV6U5RbG15aJ4ysEVOk',
    appId: '1:267035792691:web:2a520ae1011e7698081a46',
    messagingSenderId: '267035792691',
    projectId: 'lezgo-4d9fb',
    authDomain: 'lezgo-4d9fb.firebaseapp.com',
    storageBucket: 'lezgo-4d9fb.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDyq3vEkutpwh0omV6U5RbG15aJ4ysEVOk',
    appId: '1:267035792691:android:2a520ae1011e7698081a46',
    messagingSenderId: '267035792691',
    projectId: 'lezgo-4d9fb',
    storageBucket: 'lezgo-4d9fb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDyq3vEkutpwh0omV6U5RbG15aJ4ysEVOk',
    appId: '1:267035792691:ios:2a520ae1011e7698081a46',
    messagingSenderId: '267035792691',
    projectId: 'lezgo-4d9fb',
    storageBucket: 'lezgo-4d9fb.appspot.com',
    iosBundleId: 'com.example.fylo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDyq3vEkutpwh0omV6U5RbG15aJ4ysEVOk',
    appId: '1:267035792691:macos:2a520ae1011e7698081a46',
    messagingSenderId: '267035792691',
    projectId: 'lezgo-4d9fb',
    storageBucket: 'lezgo-4d9fb.appspot.com',
    iosBundleId: 'com.example.fylo',
  );
}
