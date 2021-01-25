part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  authenticated,
  creatingAccount,
  unauthenticated,
  unknown
}

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user = User.empty,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(User user)
      : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  const AuthenticationState.creatingAccount(User user)
      : this._(status: AuthenticationStatus.creatingAccount,user : user);

  final AuthenticationStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];
}