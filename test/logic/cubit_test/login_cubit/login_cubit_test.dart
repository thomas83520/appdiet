import 'package:appdiet/data/models/signin_login/email.dart';
import 'package:appdiet/data/models/signin_login/password.dart';
import 'package:appdiet/logic/cubits/login_cubit/login_cubit.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

// ignore: must_be_immutable
class Mockuser extends Mock implements User {}

void main() {
  const invalidEmailString = 'invalid';
  const invalidEmail = Email.dirty(invalidEmailString);

  const validEmailString = 'email@mail.com';
  const validEmail = Email.dirty(validEmailString);

  const invalidPasswordString = 'invalid';
  const invalidPassword = Password.dirty(invalidPasswordString);

  const validPasswordString = 'PassW0rd';
  const validPassword = Password.dirty(validPasswordString);

  AuthenticationRepository authenticationRepository;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
  });
  group('Email', () {
    blocTest<LoginCubit, LoginState>(
      'emits [invalid] when email/password are invalid',
      build: () => LoginCubit(authenticationRepository),
      act: (cubit) => cubit.emailChanged(invalidEmailString),
      expect: <LoginState>[
        LoginState(email: invalidEmail, status: FormzStatus.invalid),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [valid] when email/password are valid',
      build: () => LoginCubit(authenticationRepository),
      seed: LoginState(
        password: validPassword,
      ),
      act: (cubit) => cubit.emailChanged(validEmailString),
      expect: <LoginState>[
        LoginState(
          email: validEmail,
          password: validPassword,
          status: FormzStatus.valid,
        ),
      ],
    );
  });

  group('Password', () {
    blocTest<LoginCubit, LoginState>(
      'emits [invalid] when email/password are invalid',
      build: () => LoginCubit(authenticationRepository),
      act: (cubit) => cubit.passwordChanged(invalidPasswordString),
      expect: <LoginState>[
        LoginState(password: invalidPassword, status: FormzStatus.invalid),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [valid] when email/password are valid',
      build: () => LoginCubit(authenticationRepository),
      seed: LoginState(
        email: validEmail,
      ),
      act: (cubit) => cubit.passwordChanged(validPasswordString),
      expect: <LoginState>[
        LoginState(
          email: validEmail,
          password: validPassword,
          status: FormzStatus.valid,
        ),
      ],
    );
  });

  group('Login with credentials', () {
    blocTest('Should emit failure if repository throw',
        build: () {
          when(authenticationRepository.logInWithEmailAndPassword(
                  email: validEmailString, password: validPasswordString))
              .thenThrow(Exception('oops'));
          return LoginCubit(authenticationRepository);
        },
        seed: LoginState(
            email: validEmail,
            password: validPassword,
            status: FormzStatus.valid),
        act: (LoginCubit cubit) async => cubit.logInWithCredentials(),
        expect: <LoginState>[
          LoginState(
              email: validEmail,
              password: validPassword,
              status: FormzStatus.submissionInProgress),
          LoginState(
              email: validEmail,
              password: validPassword,
              status: FormzStatus.submissionFailure),
        ]);

      blocTest('Should emit success if repository do not throw',
        build: () {
          when(authenticationRepository.logInWithEmailAndPassword(
                  email: validEmailString, password: validPasswordString))
              .thenAnswer((_) => Future.value());
          return LoginCubit(authenticationRepository);
        },
        seed: LoginState(
            email: validEmail,
            password: validPassword,
            status: FormzStatus.valid),
        act: (LoginCubit cubit) async => cubit.logInWithCredentials(),
        expect: <LoginState>[
          LoginState(
              email: validEmail,
              password: validPassword,
              status: FormzStatus.submissionInProgress),
          LoginState(
              email: validEmail,
              password: validPassword,
              status: FormzStatus.submissionSuccess),
        ]);
  });

  group('Login with Google', () {
    blocTest('Should emit failure if repository throw Exception',
        build: () {
          when(authenticationRepository.logInWithGoogle())
              .thenThrow(Exception('oops'));
          return LoginCubit(authenticationRepository);
        },
        seed: LoginState(
            email: validEmail,
            password: validPassword,
            status: FormzStatus.valid),
        act: (LoginCubit cubit) async => cubit.logInWithGoogle(),
        expect: <LoginState>[
          LoginState(
              email: validEmail,
              password: validPassword,
              status: FormzStatus.submissionInProgress),
          LoginState(
              email: validEmail,
              password: validPassword,
              status: FormzStatus.submissionFailure),
        ]);


      blocTest('Should emit success if repository do not throw',
        build: () {
          when(authenticationRepository.logInWithGoogle())
              .thenAnswer((_) => Future.value());
          return LoginCubit(authenticationRepository);
        },
        seed: LoginState(
            email: validEmail,
            password: validPassword,
            status: FormzStatus.valid),
        act: (LoginCubit cubit) async => cubit.logInWithGoogle(),
        expect: <LoginState>[
          LoginState(
              email: validEmail,
              password: validPassword,
              status: FormzStatus.submissionInProgress),
          LoginState(
              email: validEmail,
              password: validPassword,
              status: FormzStatus.submissionSuccess),
        ]);
  });

  group('Login with Apple', () {
    blocTest('Should emit failure if repository throw',
        build: () {
          when(authenticationRepository.logInWithApple(scopes: [Scope.email, Scope.fullName]))
              .thenThrow(Exception('oops'));
          return LoginCubit(authenticationRepository);
        },
        seed: LoginState(
            email: validEmail,
            password: validPassword,
            status: FormzStatus.valid),
        act: (LoginCubit cubit) async => cubit.logInWithApple(),
        expect: <LoginState>[
          LoginState(
              email: validEmail,
              password: validPassword,
              status: FormzStatus.submissionInProgress),
          LoginState(
              email: validEmail,
              password: validPassword,
              status: FormzStatus.submissionFailure),
        ]);

      blocTest('Should emit success if repository do not throw',
        build: () {
          when(authenticationRepository.logInWithApple(scopes: [Scope.email, Scope.fullName]))
              .thenAnswer((_) => Future.value());
          return LoginCubit(authenticationRepository);
        },
        seed: LoginState(
            email: validEmail,
            password: validPassword,
            status: FormzStatus.valid),
        act: (LoginCubit cubit) async => cubit.logInWithApple(),
        expect: <LoginState>[
          LoginState(
              email: validEmail,
              password: validPassword,
              status: FormzStatus.submissionInProgress),
          LoginState(
              email: validEmail,
              password: validPassword,
              status: FormzStatus.submissionSuccess),
        ]);
  });
}
