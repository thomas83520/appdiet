import 'package:appdiet/logic/cubits/login_cubit/login_cubit.dart';
import 'package:appdiet/presentation/pages/sign_up_page.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:apple_sign_in/apple_sign_in_button.dart' as applebutton;
import 'package:appdiet/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart' as signin_button;

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appleSignInAvailable =
        Provider.of<AppleSignInAvailable>(context, listen: false);

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -2 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LogoAndName(),
              const SizedBox(height: 26.0),
              _InfoText(),
              const SizedBox(height: 30.0),
              _EmailInput(),
              const SizedBox(height: 8.0),
              _PasswordInput(),
              const SizedBox(height: 8.0),
              _LoginButton(),
              const SizedBox(height: 8.0),
              _Separation(),
              const SizedBox(height: 8.0),
              _GoogleLoginButton(),
              const SizedBox(height: 8.0),
              if (appleSignInAvailable.isAvailable) _AppleLoginButton(),
              const SizedBox(height: 4.0),
              _SignUpButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'email',
            hintText: '',
            errorText: state.email.invalid ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password',
            helperText: '',
            errorText: state.password.invalid ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        final theme = Theme.of(context);
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.infinity,
                height: 50.0,
                child: RaisedButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  child: const Text(
                    'Continuer',
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: theme.primaryColor,
                  onPressed: state.status.isValidated
                      ? () => context.read<LoginCubit>().logInWithCredentials()
                      : null,
                ),
              );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 50.0,
        child: signin_button.SignInButton(
          elevation: 2,
          btnColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide.none),
          buttonType: signin_button.ButtonType.google,
          onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
        ));
  }
}

class _AppleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppleSignInButton(
        style: applebutton.ButtonStyle.black,
        onPressed: () => context.read<LoginCubit>().logInWithApple());
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Vous n'avez pas de compte ?"),
        FlatButton(
          key: const Key('loginForm_createAccount_flatButton'),
          child: Text(
            'Créer un compte',
            style: TextStyle(
                color: theme.primaryColor, fontWeight: FontWeight.bold),
          ),
          onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
        ),
      ],
    );
  }
}

class _Separation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.grey,
            ),
          ),
        ),
        Text("OU"),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: <Widget>[
          Text(
            "Se connecter",
            style: TextStyle(fontSize: 30.0),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      Row(
        children: <Widget>[
          Text(
            "Heureux de vous revoir !",
            style: TextStyle(color: Colors.grey, fontSize: 14.0),
          )
        ],
      ),
    ]);
  }
}

class _LogoAndName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/splash.png',
          height: 120,
        ),
        Text(
          "Ma diet et moi",
          style: TextStyle(color: Colors.lightGreen, fontSize: 15.0),
        ),
      ],
    );
  }
}
