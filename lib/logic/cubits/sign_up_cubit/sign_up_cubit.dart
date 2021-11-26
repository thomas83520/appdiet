import 'package:appdiet/data/models/models.dart';
import 'package:appdiet/data/repository/authentication_repository.dart';
import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(
    this._authenticationRepository,
    String email,
  ) : super(const SignUpState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate(
          [email, state.password, state.confirmedPassword, state.codeDiet]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );
    emit(state.copyWith(
      password: password,
      confirmedPassword: confirmedPassword,
      status: Formz.validate(
          [state.email, password, state.confirmedPassword, state.codeDiet]),
    ));
  }

  void codeDietChanged(String value) {
    final codeDiet = CodeDiet.dirty(value);
    emit(state.copyWith(
      codeDiet: codeDiet,
      status: Formz.validate(
          [state.email, state.password, state.confirmedPassword, codeDiet]),
    ));
  }

  void dateChanged(BuildContext context) async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    final birthdate = BirthDate.dirty(date.toString());
    emit(state.copyWith(
        birthDate: birthdate,
        status: Formz.validate([state.name, state.firstName, birthdate])));
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );
    emit(state.copyWith(
      confirmedPassword: confirmedPassword,
      status: Formz.validate(
          [state.email, state.password, confirmedPassword, state.codeDiet]),
    ));
  }

  void nameChanged(String value) {
    final name = Name.dirty(value);
    emit(state.copyWith(
        name: name,
        status: Formz.validate([name, state.firstName, state.birthDate])));
  }

  void firstNameChanged(String value) {
    final firstName = FirstName.dirty(value);
    emit(state.copyWith(
        firstName: firstName,
        status: Formz.validate([firstName, state.name, state.birthDate])));
  }

  User getUserFromState(User user) {
    return User(
      id: user.id,
      name: state.name.value,
      firstName: state.firstName.value,
      email: state.email.value,
      uidDiet: state.codeDiet.value,
      creatingAccount: user.creatingAccount,
      linkFoodPlan: user.linkFoodPlan,
      linkStorageFolder: user.linkStorageFolder,
      birthDate: state.birthDate.value,
      suivi: ""
    );
  }

  Future<void> signUpFormSubmitted(User user, AuthenticationBloc bloc) async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      if (user.id != "") {
        User completeUser = await _authenticationRepository
            .completeUserSubscription(getUserFromState(user),user.id);
        bloc.add(AuthenticationUserChanged(completeUser));
      } else {
        await _authenticationRepository
            .addUserToWaiting(getUserFromState(user));
        await _authenticationRepository.signUp(
          email: state.email.value,
          password: state.password.value,
        );
      }
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> validCodeDiet(User user, String code) async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      bool codeOk = await _authenticationRepository.isCodeDietAvailable(code);
      codeOk
          ? emit(state.copyWith(status: FormzStatus.submissionSuccess))
          : emit(state.copyWith(
              status: FormzStatus.submissionFailure,
              codeDiet: CodeDiet.dirty("")));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
