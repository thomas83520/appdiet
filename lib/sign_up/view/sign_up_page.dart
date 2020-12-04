import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appdiet/sign_up/sign_up.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider<SignUpCubit>(
          create: (_) => SignUpCubit(context.read<AuthenticationRepository>()),
          child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container()),
                Expanded(
                  flex: 10,
                  child: SignUpForm(),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ),
        ),
      ),
    );
  }
}
