import 'package:appdiet/data/models/models.dart';
import 'package:appdiet/logic/cubits/sign_up_cubit/sign_up_cubit.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mockito/mockito.dart';

import '../../bloc_test/authentication_bloc/authentication_bloc_test.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class Mockuser extends Mock implements User {}

void main() {
  const invalidEmailString = 'invalid';
  const invalidEmail = Email.dirty(invalidEmailString);

  const validEmailString = 'email@test.fr';
  const validEmail = Email.dirty(validEmailString);

  const invalidPasswordString = 'invalid';
  const invalidPassword = Password.dirty(invalidPasswordString);

  const validPasswordString = 'PassWord00';
  const validPassword = Password.dirty(validPasswordString);

  const invalidConfirmedPasswordString = 'invalid';
  const invalidConfirmedPassword = ConfirmedPassword.dirty(
      password: validPasswordString, value: invalidConfirmedPasswordString);

  const validConfirmedPasswordString = 'PassWord00';
  const validConfirmedPassword = ConfirmedPassword.dirty(
      password: validPasswordString, value: validConfirmedPasswordString);

  const invalidCodeDietString = 'invalid';
  const invalidCodeDiet = CodeDiet.dirty(invalidCodeDietString);

  const validCodeDietString = 'ABCDEF';
  const validCodeDiet = CodeDiet.dirty(validCodeDietString);

  const invalidNameString = '00000';
  const invalidName = Name.dirty(invalidNameString);

  const validNameString = 'Valid';
  const validName = Name.dirty(validNameString);

  const invalidFirstNameString = '00000';
  const invalidFirstName = FirstName.dirty(invalidFirstNameString);

  const validFirstNameString = 'Valid';
  const validFirstName = FirstName.dirty(validFirstNameString);

  const validBirthDateString = '12/12/2021';
  const validBirthDate = BirthDate.dirty(validBirthDateString);

  User user;

  group('SignUp cubit', () {
    AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      user = MockUser();
    });

    test('initial state is SignUpState', () {
      expect(SignUpCubit(authenticationRepository, '').state, SignUpState());
    });

    group('emailChanged', () {
      blocTest<SignUpCubit, SignUpState>(
        'emits [invalid] when email/password/confirmedPassword are invalid',
        build: () => SignUpCubit(authenticationRepository, ''),
        act: (cubit) => cubit.emailChanged(invalidEmailString),
        expect: <SignUpState>[
          SignUpState(email: invalidEmail, status: FormzStatus.invalid),
        ],
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [valid] when email/password/confirmedPassword are valid',
        build: () => SignUpCubit(authenticationRepository, ''),
        seed: SignUpState(
          password: validPassword,
          confirmedPassword: validConfirmedPassword,
          codeDiet: validCodeDiet,
          name: validName,
          firstName: validFirstName,
          birthDate: validBirthDate,
        ),
        act: (cubit) => cubit.emailChanged(validEmailString),
        expect: <SignUpState>[
          SignUpState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            status: FormzStatus.valid,
            codeDiet: validCodeDiet,
            name: validName,
            firstName: validFirstName,
            birthDate: validBirthDate,
          ),
        ],
      );
    });

    group('Password Changed', () {
      blocTest<SignUpCubit, SignUpState>(
        'emits [invalid] when at least one field is invalid',
        build: () => SignUpCubit(authenticationRepository, ''),
        act: (cubit) => cubit.passwordChanged(invalidPasswordString),
        expect: <SignUpState>[
          SignUpState(
              confirmedPassword: ConfirmedPassword.dirty(
                password: invalidPasswordString,
                value: '',
              ),
              password: invalidPassword,
              status: FormzStatus.invalid),
        ],
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [valid] when all field are valid',
        build: () => SignUpCubit(authenticationRepository, ''),
        seed: SignUpState(
          email: validEmail,
          confirmedPassword: validConfirmedPassword,
          codeDiet: validCodeDiet,
          name: validName,
          firstName: validFirstName,
          birthDate: validBirthDate,
        ),
        act: (cubit) => cubit.passwordChanged(validPasswordString),
        expect: <SignUpState>[
          SignUpState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            status: FormzStatus.valid,
            codeDiet: validCodeDiet,
            name: validName,
            firstName: validFirstName,
            birthDate: validBirthDate,
          ),
        ],
      );
    });

    group('confirmedPasswordChanged', () {
      blocTest<SignUpCubit, SignUpState>(
        'emits [invalid] when all field are invalid',
        build: () => SignUpCubit(authenticationRepository, ''),
        act: (cubit) =>
            cubit.confirmedPasswordChanged(invalidConfirmedPasswordString),
        expect: <SignUpState>[
          SignUpState(
            confirmedPassword: invalidConfirmedPassword,
            status: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [valid] when all field are valid',
        build: () => SignUpCubit(authenticationRepository, ''),
        seed: SignUpState(
          email: validEmail,
          password: validPassword,
          codeDiet: validCodeDiet,
          name: validName,
          firstName: validFirstName,
          birthDate: validBirthDate,
        ),
        act: (cubit) => cubit.confirmedPasswordChanged(
          validConfirmedPasswordString,
        ),
        expect: <SignUpState>[
          SignUpState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            status: FormzStatus.valid,
            codeDiet: validCodeDiet,
            name: validName,
            firstName: validFirstName,
            birthDate: validBirthDate,
          ),
        ],
      );
    });

    group('Code diet', () {
      blocTest<SignUpCubit, SignUpState>(
        'emits [invalid] when all field are invalid',
        build: () => SignUpCubit(authenticationRepository, ''),
        act: (cubit) => cubit.codeDietChanged(invalidCodeDietString),
        expect: <SignUpState>[
          SignUpState(
            codeDiet: invalidCodeDiet,
            status: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [valid] when all field are valid',
        build: () => SignUpCubit(authenticationRepository, ''),
        seed: SignUpState(
          email: validEmail,
          password: validPassword,
          confirmedPassword: validConfirmedPassword,
          name: validName,
          firstName: validFirstName,
          birthDate: validBirthDate,
        ),
        act: (cubit) => cubit.codeDietChanged(
          validCodeDietString,
        ),
        expect: <SignUpState>[
          SignUpState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            status: FormzStatus.valid,
            codeDiet: validCodeDiet,
            name: validName,
            firstName: validFirstName,
            birthDate: validBirthDate,
          ),
        ],
      );
    });

    group('Valid Code diet', () {
      blocTest('Should emit submission failure when repository throw',
          build: () {
            when(authenticationRepository
                    .isCodeDietAvailable(validCodeDietString))
                .thenThrow(Exception('oops'));
            return SignUpCubit(authenticationRepository, '');
          },
          seed: SignUpState(
              email: validEmail,
              password: validPassword,
              confirmedPassword: validConfirmedPassword,
              status: FormzStatus.valid,
              codeDiet: validCodeDiet,
              name: validName,
              firstName: validFirstName,
              birthDate: validBirthDate),
          act: (SignUpCubit cubit) async =>
              cubit.validCodeDiet(user, validCodeDietString),
          expect: <SignUpState>[
            SignUpState(
                email: validEmail,
                password: validPassword,
                confirmedPassword: validConfirmedPassword,
                codeDiet: validCodeDiet,
                status: FormzStatus.submissionInProgress,
                name: validName,
                firstName: validFirstName,
                birthDate: validBirthDate),
            SignUpState(
                email: validEmail,
                password: validPassword,
                confirmedPassword: validConfirmedPassword,
                codeDiet: validCodeDiet,
                status: FormzStatus.submissionFailure,
                name: validName,
                firstName: validFirstName,
                birthDate: validBirthDate),
          ]);

      blocTest(
          'Should emit submission failure when repository return code is invalid',
          build: () {
            when(authenticationRepository
                    .isCodeDietAvailable(validCodeDietString))
                .thenAnswer((_) => Future.value(false));
            return SignUpCubit(authenticationRepository, '');
          },
          seed: SignUpState(
              email: validEmail,
              password: validPassword,
              confirmedPassword: validConfirmedPassword,
              status: FormzStatus.valid,
              codeDiet: validCodeDiet,
              name: validName,
              firstName: validFirstName,
              birthDate: validBirthDate),
          act: (SignUpCubit cubit) async =>
              cubit.validCodeDiet(user, validCodeDietString),
          expect: <SignUpState>[
            SignUpState(
                email: validEmail,
                password: validPassword,
                confirmedPassword: validConfirmedPassword,
                codeDiet: validCodeDiet,
                status: FormzStatus.submissionInProgress,
                name: validName,
                firstName: validFirstName,
                birthDate: validBirthDate),
            SignUpState(
                email: validEmail,
                password: validPassword,
                confirmedPassword: validConfirmedPassword,
                codeDiet: CodeDiet.dirty(''),
                status: FormzStatus.submissionFailure,
                name: validName,
                firstName: validFirstName,
                birthDate: validBirthDate),
          ]);

      blocTest(
          'Should emit submission success when repository return code is valid',
          build: () {
            when(authenticationRepository
                    .isCodeDietAvailable(validCodeDietString))
                .thenAnswer((_) => Future.value(true));
            return SignUpCubit(authenticationRepository, '');
          },
          seed: SignUpState(
              email: validEmail,
              password: validPassword,
              confirmedPassword: validConfirmedPassword,
              status: FormzStatus.valid,
              codeDiet: validCodeDiet,
              name: validName,
              firstName: validFirstName,
              birthDate: validBirthDate),
          act: (SignUpCubit cubit) async =>
              cubit.validCodeDiet(user, validCodeDietString),
          expect: <SignUpState>[
            SignUpState(
                email: validEmail,
                password: validPassword,
                confirmedPassword: validConfirmedPassword,
                codeDiet: validCodeDiet,
                status: FormzStatus.submissionInProgress,
                name: validName,
                firstName: validFirstName,
                birthDate: validBirthDate),
            SignUpState(
                email: validEmail,
                password: validPassword,
                confirmedPassword: validConfirmedPassword,
                codeDiet: validCodeDiet,
                status: FormzStatus.submissionSuccess,
                name: validName,
                firstName: validFirstName,
                birthDate: validBirthDate),
          ]);
    });
  });
}
