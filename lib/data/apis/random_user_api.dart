import 'package:dio/dio.dart';
import 'package:flutter_test_assignment/data/models/user_model.dart';

typedef ServerErrorException = DioException;

class RandomUserApi {
  final Dio dio;

  RandomUserApi(this.dio);

  factory RandomUserApi.withDefaultOptions() {
    return RandomUserApi(
      Dio(
        BaseOptions(
          baseUrl: 'https://randomuser.me',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 5),
        ),
      ),
    );
  }

  Future<UserModel> signIn(String email, String password) async {
    final response = await dio.get(
      '/api',
      queryParameters: {"email": email, "password": password},
    );
    final Map<String, dynamic> userData = response.data['results'][0];
    return UserModel(
      userData['email'],
      userData['login']?['username'],
      userData['picture']?['thumbnail'],
    );
  }
}
