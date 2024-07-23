import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String email;
  final String username;
  final String pictureUrl;

  const UserModel(this.email, this.username, this.pictureUrl);

  @override
  List<Object?> get props => [email, username, pictureUrl];
}
