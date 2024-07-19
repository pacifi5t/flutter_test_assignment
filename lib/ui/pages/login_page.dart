import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_assignment/bloc/login/login_bloc.dart';
import 'package:flutter_test_assignment/ui/pages/pages.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(flex: 2),
          Text(
            'Sign In',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const Spacer(flex: 1),
          const LoginForm(),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _loginBlocStateListener(BuildContext context, LoginState state) {
    if (state is LoginError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          content: Text(state.errorMessage),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          margin: const EdgeInsets.fromLTRB(8, 0, 8, 16),
        ),
      );
    } else if (state is LoginSuccess) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    }
  }

  String? _emailValidator(String? input) {
    if (input == null || input.isEmpty) {
      return 'Email field is empty';
    }

    final validEmailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+\\/=?^_`{|}~-]{1,10}@"
      r"(?:(?!.*--)[a-zA-Z0-9-]{1,10}(?<!-))(?:\.(?:[a-zA-Z0-9-]{2,10}))+$",
    );
    final lengthIsCorrect = input.length >= 6 && input.length <= 30;

    if (lengthIsCorrect && validEmailRegExp.hasMatch(input)) {
      return null;
    }
    return 'Email is incorrect';
  }

  String? _passwordValidator(String? input) {
    if (input == null || input.isEmpty) {
      return 'Password is empty';
    }

    final lengthIsCorrect = input.length >= 6 && input.length <= 10;
    final inputContainsRequiredCharacters = input.contains(RegExp(r'[A-Z]+')) &&
        input.contains(RegExp(r'[a-z]+')) &&
        input.contains(RegExp(r'[0-9]+'));

    if (lengthIsCorrect && inputContainsRequiredCharacters) {
      return null;
    }
    return 'Password is incorrect';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: LoginTextField(
              validator: _emailValidator,
              controller: _emailController,
              labelText: 'Email',
              hintText: 'Enter your email',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: LoginTextField(
              validator: _passwordValidator,
              controller: _passwordController,
              labelText: 'Password',
              hintText: 'Enter your password',
            ),
          ),
          BlocConsumer<LoginBloc, LoginState>(
            listener: _loginBlocStateListener,
            builder: (context, state) {
              return Container(
                height: 40,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FilledButton(
                  onPressed: () {
                    if (state is LoginInProgress) {
                      return;
                    }

                    //FIXME: this will break the individual input field
                    // validation, try fixing this later
                    bool inputIsValid = _formKey.currentState!.validate();
                    if (inputIsValid) {
                      BlocProvider.of<LoginBloc>(context).add(
                        LoginAttempt(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        ),
                      );
                    }
                  },
                  child: state is LoginInProgress
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Log In'),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class LoginTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?) validator;

  const LoginTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.validator,
  });

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  bool _isFocused = false;
  late FocusNode _focusNode;
  String? _errorText;

  void onFocusChange() {
    bool becameUnfocused = _isFocused && !_focusNode.hasFocus;
    if (becameUnfocused) {
      setState(() {
        _errorText = widget.validator(widget.controller.text);
      });
    }

    _isFocused = _focusNode.hasFocus;
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          const errorAndHelperTextStyle = TextStyle(fontSize: 12, height: 1.0);
          return TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            focusNode: _focusNode,
            enabled: state is! LoginInProgress,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: const OutlineInputBorder(),
              labelText: widget.labelText,
              hintText: widget.hintText,
              errorText: _errorText,
              errorStyle: errorAndHelperTextStyle,
              helperText: ' ',
              helperStyle: errorAndHelperTextStyle,
            ),
          );
        },
      ),
    );
  }
}
