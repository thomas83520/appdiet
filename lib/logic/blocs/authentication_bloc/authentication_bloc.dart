import 'dart:async';

import 'package:appdiet/data/models/models.dart';
import 'package:appdiet/data/repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pedantic/pedantic.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  })  :
        _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(AuthenticationUserChanged(user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late StreamSubscription<User> _userSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationUserChanged) {
      yield await _mapAuthenticationUserChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      unawaited(_authenticationRepository.logOut());
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }

  Future<AuthenticationState> _mapAuthenticationUserChangedToState(
    AuthenticationUserChanged event,
  ) async {
    if (event.user != User.empty) {
      print(event.user);
      if (await _authenticationRepository.isUserInFirestore(event.user.id)) {
        final User user =
            await _authenticationRepository.getUserFromUid(event.user.id);
        if (user.creatingAccount)
          return AuthenticationState.creatingAccount(user);
        else
          return AuthenticationState.authenticated(user);
      } else {
        final User userWaiting = await _authenticationRepository.getUserFromWaiting(event.user.email);
        if (userWaiting != User.empty)
        {
          final User authenticateUser = await _authenticationRepository.completeUserSubscription(userWaiting,event.user.id);
          await _authenticationRepository.deleteUserFromWaiting(userWaiting.id);
          return AuthenticationState.authenticated(authenticateUser);
        }
        else {
          final User user = await _authenticationRepository.initUserInFirestore(
              event.user.id,
              event.user.email,
              event.user.name,
              event.user.firstName);
          return AuthenticationState.creatingAccount(user);
        }
      }
    } else
      return const AuthenticationState.unauthenticated();
  }
}