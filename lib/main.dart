import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_assignment/bloc/login/login_bloc.dart';
import 'package:flutter_test_assignment/ui/color_scheme.dart';
import 'package:flutter_test_assignment/ui/pages/pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test Assignment',
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
      ),
      home: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(LoginInitial()),
        child: const LoginPage(),
      ),
    );
  }
}
