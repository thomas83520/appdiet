part of 'reset_password_cubit.dart';

class ResetPasswordState extends Equatable {
  const ResetPasswordState(
      {this.email = const Email.pure(),
      this.status = FormzStatus.pure,
      this.code = ""});

  final FormzStatus status;
  final Email email;
  final String code;
  @override
  List<Object> get props => [status, email];

  ResetPasswordState copyWith(
      {FormzStatus? status, Email? email, String? code}) {
    return ResetPasswordState(
        status: status ?? this.status,
        email: email ?? this.email,
        code: code ?? this.code);
  }
}
