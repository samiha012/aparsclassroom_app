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
    apiKey: 'AIzaSyAbmdI6Vr-cYOuUWXRBLLEVA1AYsOhBrgg',
    appId: '1:173461823991:android:60e363ce0a7ddad2d4cef2',
    messagingSenderId: '173461823991',
    projectId: 'aparsclassroomapp',
    storageBucket: 'aparsclassroomapp.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAroEI-22ZYVhnHDQMLPHC0fSBba8XqSAY',
    appId: '1:173461823991:ios:ad90925753abf78fd4cef2',
    messagingSenderId: '173461823991',
    projectId: 'aparsclassroomapp',
    storageBucket: 'aparsclassroomapp.firebasestorage.app',
    iosBundleId: 'com.example.aparsclassroomApp',
  );
}