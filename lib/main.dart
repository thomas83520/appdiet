import 'package:appdiet/UpdateCheck.dart';
import 'package:appdiet/logic/observer/simpleBlocObserver.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
//import 'package:the_apple_sign_in/the_apple_sign_in.dart';


class AppleSignInAvailable {
  AppleSignInAvailable(this.isAvailable);
  final bool isAvailable;

  static Future<AppleSignInAvailable> check() async {
    return AppleSignInAvailable(await TheAppleSignIn.isAvailable());
  }
}

Future<void>_firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("handling a background message: ${message.notification}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert:true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  EquatableConfig.stringify = kDebugMode;
  final appleSignInAvailable = await AppleSignInAvailable.check();
  BlocOverrides.runZoned(
    () {
      runApp(Provider<AppleSignInAvailable>.value(
          value: appleSignInAvailable,
          child: UpdateCheck()));
    },
    blocObserver: SimpleBlocObserver(),
  );
}
