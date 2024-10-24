// Import the generated file
import 'package:cat_list/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

final class FirebaseService {
  Future<void> initFirebase() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
