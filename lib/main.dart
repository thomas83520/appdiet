import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:appdiet/app.dart';
import 'package:appdiet/simpleBlocObserver.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:provider/provider.dart';

FirebaseAnalytics analytics;

class AppleSignInAvailable {
  AppleSignInAvailable(this.isAvailable);
  final bool isAvailable;

  static Future<AppleSignInAvailable> check() async {
    return AppleSignInAvailable(await AppleSignIn.isAvailable());
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  analytics = FirebaseAnalytics();
  final appleSignInAvailable = await AppleSignInAvailable.check();
  runApp(Provider<AppleSignInAvailable>.value(
      value: appleSignInAvailable,
      child: App(authenticationRepository: AuthenticationRepository())));
}