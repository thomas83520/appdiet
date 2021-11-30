import 'package:appdiet/data/repository/authentication_repository.dart';
import 'package:appdiet/logic/observer/simpleBlocObserver.dart';
import 'package:appdiet/presentation/routers/app.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

FirebaseAnalytics analytics  = FirebaseAnalytics();

class AppleSignInAvailable {
  AppleSignInAvailable(this.isAvailable);
  final bool isAvailable;

  static Future<AppleSignInAvailable> check() async {
    return AppleSignInAvailable(await TheAppleSignIn.isAvailable());
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  //Bloc.observer = SimpleBlocObserver();
  final appleSignInAvailable = await AppleSignInAvailable.check();
  initializeDateFormatting('fr_FR', null).then((_) => runApp(Provider<AppleSignInAvailable>.value(
      value: appleSignInAvailable,
      child: App(authenticationRepository: AuthenticationRepository()))));
}