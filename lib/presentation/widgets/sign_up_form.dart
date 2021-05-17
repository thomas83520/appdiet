import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/cubits/sign_up_cubit/sign_up_cubit.dart';
import 'package:appdiet/presentation/pages/login_signup/sign_up_page.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Code diététicien(ne) incorrect')),
          );
        }
        if (state.status.isSubmissionSuccess) {
          signUpNavigatorKey.currentState.pushNamed('/infos_perso');
        }
      },
      child: Align(
        alignment: const Alignment(0, -1.25 / 3),
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
              _ConfirmPasswordInput(),
              const SizedBox(height: 8.0),
              _DietCodeInput(),
              const SizedBox(height: 8.0),
              _SignUpButton(),
              const SizedBox(height: 20.0),
              _LoginButton(),
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
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          initialValue: user.email,
          key: const Key('signUpForm_emailInput_textField'),
          onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'email',
            helperText: '',
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
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<SignUpCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            helperText: '',
            errorText: state.password.invalid
                ? 'Le mot de passe ne correspond pas aux critères'
                : null,
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_confirmedPasswordInput_textField'),
          onChanged: (confirmPassword) => context
              .read<SignUpCubit>()
              .confirmedPasswordChanged(confirmPassword),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'confirmer mot de passe',
            helperText: '',
            errorText: state.confirmedPassword.invalid
                ? 'Les mots de passe ne correspondent pas'
                : null,
          ),
        );
      },
    );
  }
}

class _DietCodeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _controller = TextEditingController();

    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.codeDiet != current.codeDiet,
      builder: (context, state) {
        return BlocListener<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state.status == FormzStatus.submissionFailure)
              _controller.clear();
          },
          child: TextField(
            controller: _controller,
            key: const Key('signUpForm_codeDietInput_textField'),
            onChanged: (codeDiet) =>
                context.read<SignUpCubit>().codeDietChanged(codeDiet),
            maxLength: 6,
            inputFormatters: [
              UpperCaseTextFormatter(),
            ],
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: 'code diététicien(ne)',
              helperText: '',
              errorText: state.codeDiet.invalid ? 'Code Incomplet' : null,
            ),
          ),
        );
      },
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user =
        context.select((AuthenticationBloc bloc) => bloc.state.user);
    final theme = Theme.of(context);
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  key: const Key('signUpForm_continue_raisedButton'),
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
                      ? () => context
                          .read<SignUpCubit>()
                          .validCodeDiet(user, state.codeDiet.value)
                      : null,
                ),
              );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Vous avez déjà un compte ?"),
        TextButton(
            key: const Key('loginForm_backtologin_flatButton'),
            child: Text(
              'Se connecter',
              style: TextStyle(
                  color: theme.primaryColor, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested());
              Navigator.of(context, rootNavigator: true).pop();
            }),
      ],
    );
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

class _InfoText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: <Widget>[
          Text(
            "Créer un compte",
            style: TextStyle(fontSize: 30.0),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      Row(
        children: <Widget>[
          Text(
            "Heureux de vous rencontrer !",
            style: TextStyle(color: Colors.grey, fontSize: 14.0),
          )
        ],
      ),
    ]);
  }
}
