import 'dart:async';

import 'package:appdiet/data/models/models.dart';
import 'package:appdiet/data/repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(AuthenticationUserChanged(user)),
    );
    on<AuthenticationLogoutRequested>((event,emit) => unawaited(_authenticationRepository.logOut()));
    on<AuthenticationUserChanged>((event,emit) => _mapAuthenticationUserChangedToState(event,emit));
  }

  final AuthenticationRepository _authenticationRepository;
  late StreamSubscription<User> _userSubscription;

  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationUserChanged) {
      //yield await _mapAuthenticationUserChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      unawaited(_authenticationRepository.logOut());
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }

  Future<void> _mapAuthenticationUserChangedToState(
    AuthenticationUserChanged event, Emitter<AuthenticationState> emit
  ) async {
    print("user changeed");
    if (event.user != User.empty) {
      if (await _authenticationRepository.isUserInFirestore(event.user.id)) {
        final User user =
            await _authenticationRepository.getUserFromUid(event.user.id);
        if (user.creatingAccount)
          emit(AuthenticationState.creatingAccount(user));
        else
          emit(AuthenticationState.authenticated(user));
      } else {
        final User userWaiting = await _authenticationRepository
            .getUserFromWaiting(event.user.email);
        if (userWaiting != User.empty) {
          final User authenticateUser = await _authenticationRepository
              .completeUserSubscription(userWaiting, event.user.id);
          await _authenticationRepository.deleteUserFromWaiting(userWaiting.id);
          emit(AuthenticationState.authenticated(authenticateUser));
        } else {
          final User user = await _authenticationRepository.initUserInFirestore(
              event.user.id,
              event.user.email,
              event.user.name,
              event.user.firstName);
          emit(AuthenticationState.creatingAccount(user));
        }
      }
    } else
      emit(const AuthenticationState.unauthenticated());
  }
}
