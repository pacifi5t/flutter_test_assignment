import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_assignment/data/apis/apis.dart';
import 'package:flutter_test_assignment/data/models/user_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final randomUserApi = RandomUserApi.withDefaultOptions();

  LoginBloc(super.initialState) {
    on<LoginAttempt>((event, emit) async {
      emit(LoginInProgress());

      try {
        // A small delay to simulate slow response from the server
        final user = await Future.delayed(
          const Duration(seconds: 2),
          () => randomUserApi.signIn(event.email, event.password),
        );
        emit(LoginSuccess(user));
      } on ServerErrorException catch (exception) {
        debugPrint(exception.toString());
        emit(const LoginError("Server error, please try again"));
      } catch (exception) {
        debugPrint(exception.toString());
        emit(const LoginError("Unknown error, please try again"));
      }
    });
  }
}
