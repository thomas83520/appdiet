  import 'package:appdiet/sign_up/view/sign_up_page.dart';
import 'package:authentication_repository/authentication_repository.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';

  import 'authentication/authentication.dart';
  import 'home/home.dart';
  import 'login/login.dart';
  import 'splash/splash.dart';
  import 'theme.dart';

  class App extends StatelessWidget {
    const App({
      Key key,
      @required this.authenticationRepository,
    })  : assert(authenticationRepository != null),
          super(key: key);

    final AuthenticationRepository authenticationRepository;

    @override
    Widget build(BuildContext context) {
      return RepositoryProvider.value(
        value: authenticationRepository,
        child: BlocProvider(
          create: (_) => AuthenticationBloc(
            authenticationRepository: authenticationRepository,
          ),
          child: AppView(),
        ),
      );
    }
  }

  class AppView extends StatefulWidget {
    @override
    _AppViewState createState() => _AppViewState();
  }

  class _AppViewState extends State<AppView> {
    final _navigatorKey = GlobalKey<NavigatorState>();

    NavigatorState get _navigator => _navigatorKey.currentState;

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        theme: theme,
        navigatorKey: _navigatorKey,
        builder: (context, child) {
          return BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              switch (state.status) {
                case AuthenticationStatus.authenticated:
                  _navigator.pushAndRemoveUntil<void>(
                    HomePage.route(),
                    (route) => false,
                  );
                  break;
                case AuthenticationStatus.creatingAccount:
                  _navigator.push<void>(
                    SignUpPage.route(),
                  );
                  break;
                case AuthenticationStatus.unauthenticated:
                  _navigator.pushAndRemoveUntil<void>(
                    LoginPage.route(),
                    (route) => false,
                  );
                  break;
                default:
                  break;
              }
            },
            child: child,
          );
        },
        onGenerateRoute: (_) => SplashPage.route(),
      );
   }
 }

/*import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appdiet/authentication/authentication.dart';
import 'package:appdiet/home/home.dart';
import 'package:appdiet/login/login.dart';
import 'package:appdiet/splash/splash.dart';
import 'package:appdiet/theme.dart';

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.authenticationRepository,
  })  : assert(authenticationRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
        ),
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(),
                  (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}*/
