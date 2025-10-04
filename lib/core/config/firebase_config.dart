import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

class FirebaseConfig {
  // Prevent instantiation
  FirebaseConfig._();

  static FirebaseOptions get currentPlatform {
    if (Platform.isIOS) {
      return ios;
    } else if (Platform.isAndroid) {
      return android;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCn34Xkt8aBVLTVYCAtWj7TsIG09Qm6F20',
    appId: '1:708647142889:android:8e3622994810a76c54b778',
    messagingSenderId: '708647142889',
    projectId: 'aparsclassroom-app',
    storageBucket: 'aparsclassroom-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDDoNjL2_KFa5reIs1y2rk_nkeV8wCn65o',
    appId: '1:708647142889:ios:90b56c7f4735f67554b778',
    messagingSenderId: '708647142889',
    projectId: 'aparsclassroom-app',
    storageBucket: 'aparsclassroom-app.firebasestorage.app',
    iosBundleId: 'com.apars.shop',
  );
}