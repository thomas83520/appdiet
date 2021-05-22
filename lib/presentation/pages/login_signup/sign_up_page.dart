import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/cubits/sign_up_cubit/sign_up_cubit.dart';
import 'package:appdiet/presentation/view/info_perso_view.dart';
import 'package:appdiet/presentation/view/sign_up_form.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

var signUpNavigatorKey = GlobalKey<NavigatorState>();

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    final email =
        context.select((AuthenticationBloc bloc) => bloc.state.user.email);
    return Scaffold(
      body: BlocProvider<SignUpCubit>(
        create: (_) =>
            SignUpCubit(context.read<AuthenticationRepository>(), email),
        child: Navigator(
          key: signUpNavigatorKey,
          onGenerateRoute: (settings) {
            if (settings.name == '/infos_perso') {
              return MaterialPageRoute(builder: (context) => _InfosPage());
            } else {
              return MaterialPageRoute(
                builder: (context) => _SignUpForm(),
              );
            }
          },
        ),
      ),
    );
  }
}

class _InfosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 10,
          child: InfoPersoPage(),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
      ],
    );
  }
}

class _SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 10,
          child: SignUpForm(),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
      ],
    );
  }
}
