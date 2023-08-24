// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:movie_faves/utils/router_utils.dart';
import 'package:movie_faves/utils/validator.dart';
import '../globals/app_state_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  final _registerFormKey = GlobalKey<FormState>();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
                key: _registerFormKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: TextFormField(
                        validator: (value) =>
                            Validator.validateEmail(email: value),
                        controller: _emailController,
                        focusNode: _focusEmail,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ))),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        focusNode: _focusPassword,
                        validator: (value) =>
                            Validator.validatePassword(password: value),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    _isProcessing
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isProcessing = true;
                              });
                              if (_registerFormKey.currentState!.validate()) {
                                final message = await AppStateProvider().login(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                                if (message!.contains("Success")) {
                                  if (context.mounted) {
                                    context.goNamed(AppPage.home.routeName);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(message)));
                                  }
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(message)));
                                  }
                                }
                              }
                              setState(() {
                                _isProcessing = false;
                              });
                            },
                            child: const Text('Login'),
                          ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    TextButton(
                      onPressed: () {
                        context.goNamed(AppPage.createAccount.routeName);
                      },
                      child: const Text('Create Account'),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
