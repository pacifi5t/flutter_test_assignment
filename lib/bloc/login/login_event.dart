part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginAttempt extends LoginEvent {
  final String email;
  final String password;

  const LoginAttempt(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}
