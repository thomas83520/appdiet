import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

// ignore: must_be_immutable
class MockUser extends Mock implements User {}

void main() {
  AuthenticationRepository authenticationRepository;
  AuthenticationBloc authenticationBloc;
  User user;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    when(authenticationRepository.user).thenAnswer((_) => Stream.empty());
    authenticationBloc =
        AuthenticationBloc(authenticationRepository: authenticationRepository);
    user = MockUser();
  });

  test('InitialState is unknown', () {
    expect(authenticationBloc.state, AuthenticationState.unknown());
  });

  group('AuthenticationUserChanged', () {
    blocTest('Should emit unauthenticated if repo return user.empty',
        build: () {
          return authenticationBloc;
        },
        act: (AuthenticationBloc bloc) async =>
            bloc.add(AuthenticationUserChanged(User.empty)),
        expect: <AuthenticationState>[AuthenticationState.unauthenticated()]);

    group('User in Firestore', () {
      blocTest('User creating account should return creating account ',
          build: () {
            user = User(
                id: "1",
                creatingAccount: true,
                birthDate: "",
                linkFoodPlan: "",
                linkStorageFolder: '',
                email: '',
                firstName: '',
                name: '',
                uidDiet: '');
            when(authenticationRepository.isUserInFirestore("1"))
                .thenAnswer((_) => Future.value(true));
            when(authenticationRepository.getUserFromUid("1"))
                .thenAnswer((_) => Future.value(user));
            return authenticationBloc;
          },
          act: (AuthenticationBloc bloc) async =>
              bloc.add(AuthenticationUserChanged(user)),
          expect: <AuthenticationState>[
            AuthenticationState.creatingAccount(User(
                id: "1",
                creatingAccount: true,
                birthDate: "",
                linkFoodPlan: "",
                linkStorageFolder: '',
                email: '',
                firstName: '',
                name: '',
                uidDiet: ''))
          ]);

      blocTest('User account created return authenticated',
          build: () {
            user = User(
                id: "1",
                creatingAccount: false,
                birthDate: "",
                linkFoodPlan: "",
                linkStorageFolder: '',
                email: '',
                firstName: '',
                name: '',
                uidDiet: '');
            when(authenticationRepository.isUserInFirestore("1"))
                .thenAnswer((_) => Future.value(true));
            when(authenticationRepository.getUserFromUid("1"))
                .thenAnswer((_) => Future.value(user));
            return authenticationBloc;
          },
          act: (AuthenticationBloc bloc) async =>
              bloc.add(AuthenticationUserChanged(user)),
          expect: <AuthenticationState>[
            AuthenticationState.authenticated(User(
                id: "1",
                creatingAccount: false,
                birthDate: "",
                linkFoodPlan: "",
                linkStorageFolder: '',
                email: '',
                firstName: '',
                name: '',
                uidDiet: ''))
          ]);
    });

    group('User not in firestore', () {
      blocTest('If user waiting is empty, return creating account',
          build: () {
            user = User(
                id: "",
                creatingAccount: true,
                birthDate: "",
                linkFoodPlan: "",
                linkStorageFolder: '',
                email: 'email',
                firstName: '',
                name: '',
                uidDiet: '');
            when(authenticationRepository.isUserInFirestore(""))
                .thenAnswer((_) => Future.value(false));
            when(authenticationRepository.getUserFromWaiting("email"))
                .thenAnswer((_) => Future.value(User.empty));
            return authenticationBloc;
          },
          act: (AuthenticationBloc bloc) async =>
              bloc.add(AuthenticationUserChanged(user)),
          expect: <AuthenticationState>[
            AuthenticationState.creatingAccount(user),
          ]);

      blocTest('If user waiting is not empty, return authenticated',
          build: () {
            user = User(
                id: "",
                creatingAccount: true,
                birthDate: "",
                linkFoodPlan: "",
                linkStorageFolder: '',
                email: 'email',
                firstName: '',
                name: '',
                uidDiet: '');
            when(authenticationRepository.isUserInFirestore(""))
                .thenAnswer((_) => Future.value(false));
            when(authenticationRepository.getUserFromWaiting("email"))
                .thenAnswer((_) => Future.value(user));
            return authenticationBloc;
          },
          act: (AuthenticationBloc bloc) async =>
              bloc.add(AuthenticationUserChanged(user)),
          expect: <AuthenticationState>[
            AuthenticationState.authenticated(User(
                id: "",
                creatingAccount: true,
                birthDate: "",
                linkFoodPlan: "",
                linkStorageFolder: '',
                email: 'email',
                firstName: '',
                name: '',
                uidDiet: '')),
          ]);
    });
  });

   group('LogoutRequested', () {
      blocTest<AuthenticationBloc, AuthenticationState>(
        'invokes logOut',
        build: () {
          return authenticationBloc;
        },
        act: (bloc) => bloc.add(AuthenticationLogoutRequested()),
        verify: (_) {
          verify(authenticationRepository.logOut()).called(1);
        },
      );
    });
}
