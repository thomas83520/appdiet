part of 'sign_up_cubit.dart';

enum ConfirmPasswordValidationError { invalid }

class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.codeDiet = const CodeDiet.pure(),
    this.status = FormzStatus.pure,
    this.name = const Name.pure(),
    this.firstName = const FirstName.pure(),
    this.birthDate = const BirthDate.pure(),
  });

  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final CodeDiet codeDiet;
  final FormzStatus status;
  final Name name;
  final FirstName firstName;
  final BirthDate birthDate;

  @override
  List<Object> get props => [
        email,
        password,
        confirmedPassword,
        codeDiet,
        status,
        name,
        firstName,
        birthDate
      ];

  SignUpState copyWith({
    Email email,
    Password password,
    ConfirmedPassword confirmedPassword,
    CodeDiet codeDiet,
    FormzStatus status,
    Name name,
    FirstName firstName,
    BirthDate birthDate,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
      codeDiet: codeDiet ?? this.codeDiet,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      birthDate: birthDate ?? this.birthDate,
    );
  }
}
