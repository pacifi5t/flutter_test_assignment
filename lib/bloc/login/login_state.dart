part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginInProgress extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginError extends LoginState {
  final String errorMessage;

  const LoginError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class LoginSuccess extends LoginState {
  final UserModel user;

  const LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}
