import 'package:appdiet/authentication/authentication.dart';
import 'package:appdiet/sign_up/cubit/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InfoPersoPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => InfoPersoPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Sign Up Failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -2.5 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _BackButton(),
              const SizedBox(height: 50.0),
              _InfoText(),
              const SizedBox(height: 30.0),
              _NameInput(),
              const SizedBox(height: 8.0),
              _FirstNameInput(),
              const SizedBox(height: 8.0),
              _DateInput(),
              const SizedBox(height: 8.0),
              //_DietCodeInput(),
              const SizedBox(height: 8.0),
              //_SignUpButton(),
              const SizedBox(height: 20.0),
              //_LoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RaisedButton.icon(
            elevation: 0,
            color: Color(0xFFFFFAFA),
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back),
            label: Text("Retour")),
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
            "Informations personnelles",
            style: TextStyle(fontSize: 25.0),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    ]);
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          initialValue: user.email,
          key: const Key('signUpForm_nameInput_textField'),
          onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Nom',
            helperText: '',
            errorText: state.email.invalid ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}

class _FirstNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_firstNameInput_textField'),
          onChanged: (password) =>
              context.read<SignUpCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Prénom',
            helperText: '',
            errorText: state.password.invalid ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _DateInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          controller : TextEditingController(text: state.birthDate.toString()),
          key: const Key('signUpForm_dateInput_textField'),
          onChanged: (password) =>
              context.read<SignUpCubit>().passwordChanged(password),
          obscureText: true,
          onTap: () => context.read<SignUpCubit>().dateChanged(context),
          decoration: InputDecoration(
            labelText: 'Date de naissance',
            helperText: '',
            errorText: state.password.invalid ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}
