import 'package:appdiet/logic/cubits/login_cubit/login_cubit.dart';
import 'package:appdiet/logic/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:appdiet/presentation/pages/login_signup/sign_up_page.dart';
import 'package:the_apple_sign_in/apple_sign_in_button.dart' as applebutton;
import 'package:appdiet/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formz/formz.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart' as signin_button;
import 'package:the_apple_sign_in/apple_sign_in_button.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appleSignInAvailable =
        Provider.of<AppleSignInAvailable>(context, listen: false);

    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status.isSubmissionFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Theme.of(context).errorColor,
                content: Text("Echec de l'authentification"),
              ),
              );
            }
          },
        ),
        BlocListener<ResetPasswordCubit, ResetPasswordState>(
          listener: (context, state) {
            if (state.status.isSubmissionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Theme.of(context).primaryColor,
                content: Text('Email envoyé'),
                behavior: SnackBarBehavior.floating,
              ));
            }
            if (state.status.isSubmissionFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.code),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Theme.of(context).errorColor,
                ),
              );
            }
          },
        ),
      ],
      child: Align(
        alignment: const Alignment(0, -2 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 26.0),
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
              TextButton(
                onPressed: () => {
                  showDialog(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<ResetPasswordCubit>(context),
                      child: ResetPasswordDialog(),
                    ),
                  ),
                },
                child: Text("Mot de passe oublié ?"),
                style: TextButton.styleFrom(
                    primary: Theme.of(context).primaryColor),
              ),
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
                child: ElevatedButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  child: const Text(
                    'Continuer',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    onSurface: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
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
        Expanded(child: Text("Vous n'avez pas de compte ?")),
        TextButton(
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
        SvgPicture.asset(
          'assets/logo_7.svg',
          height: 120,
        ),
        Text(
          "DietUp!",
          style:
              TextStyle(color: Theme.of(context).primaryColor, fontSize: 20.0),
        ),
      ],
    );
  }
}

class ResetPasswordDialog extends StatelessWidget {
  const ResetPasswordDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Center(child: Text("Mot de passe oublié")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
            builder: (context, state) {
              return TextField(
                key: const Key('addPatient_emailInput_textField'),
                onChanged: (email) =>
                    context.read<ResetPasswordCubit>().emailChanged(email),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'email',
                  hintText: '',
                  errorText: state.email.invalid ? 'email non valide' : null,
                ),
              );
            },
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
              onPressed: () async {
                await context.read<ResetPasswordCubit>().sendResetPassword();
                Navigator.of(context).pop();
              },
              child: Text("Envoyer le lien")),
        ],
      ),
    );
  }
}
