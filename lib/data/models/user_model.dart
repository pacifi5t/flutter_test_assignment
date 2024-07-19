import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String email;
  final String username;

  const UserModel(this.email, this.username);

  @override
  List<Object?> get props => [email, username];
}
