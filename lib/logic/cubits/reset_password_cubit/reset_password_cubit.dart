import 'package:appdiet/data/models/models.dart';
import 'package:appdiet/data/repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this.authenticationRepository)
      : super(ResetPasswordState());

  final AuthenticationRepository authenticationRepository;
  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email]),
    ));
  }

  Future<void> sendResetPassword() async {
    if (state.email.valid) {
      try {
        await authenticationRepository.sendResetPassword(state.email.value);
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } on FirebaseAuthException catch (e) {
        if (e.code == "user-not-found")
          emit(state.copyWith(
              status: FormzStatus.submissionFailure,
              code: "L'adresse mail renseigné n'existe pas."));
        else
          emit(state.copyWith(
              status: FormzStatus.submissionFailure,
              code: "Une erreur est survenue lors de l'envoie du mail."));
      }
    } else
      emit(state.copyWith(status: FormzStatus.submissionFailure,code: "Votre email n'est pas valide."));
  }
}
