import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/cubits/sign_up_cubit/sign_up_cubit.dart';
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
          ScaffoldMessenger.of(context).showSnackBar(
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
              _SignUpButton(),
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
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                elevation: 0, onSurface: Color(0xFFFFFAFA)),
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
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextFormField(
          initialValue: user.name,
          key: const Key('signUpForm_nameInput_textField'),
          onChanged: (name) => context.read<SignUpCubit>().nameChanged(name),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Nom',
            helperText: '',
            errorText: state.name.invalid ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}

class _FirstNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.firstName != current.firstName,
      builder: (context, state) {
        return TextFormField(
          initialValue: user.firstName,
          key: const Key('signUpForm_firstNameInput_textField'),
          onChanged: (firstName) =>
              context.read<SignUpCubit>().firstNameChanged(firstName),
          decoration: InputDecoration(
            labelText: 'Prénom',
            helperText: '',
            errorText: state.firstName.invalid ? 'Caractères non valide' : null,
          ),
        );
      },
    );
  }
}

class _DateInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController txt = TextEditingController();
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.birthDate != current.birthDate,
      builder: (context, state) {
        switch (state.birthDate.value) {
          case "":
            txt.text = "";
            break;
          case "null":
            txt.text = "";
            break;
          default:
            txt.text = state.birthDate.value.substring(0, 10);
            break;
        }
        return TextField(
          controller: txt,
          key: const Key('signUpForm_dateInput_textField'),
          onTap: () => context.read<SignUpCubit>().dateChanged(context),
          decoration: InputDecoration(
            labelText: 'Date de naissance',
            helperText: '',
            errorText:
                state.birthDate.invalid ? 'Date de naissance non valide' : null,
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    final bloc = context.select((AuthenticationBloc bloc) => bloc);
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
                    'Créer un compte',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    onSurface: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: state.status.isValidated
                      ? () => {
                            context
                                .read<SignUpCubit>()
                                .signUpFormSubmitted(user, bloc)
                          }
                      : null,
                ),
              );
      },
    );
  }
}
