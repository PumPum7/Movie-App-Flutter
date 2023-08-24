// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:movie_faves/globals/app_state_provider.dart';
import 'package:movie_faves/utils/router_utils.dart';
import 'package:movie_faves/utils/validator.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  final _registerFormKey = GlobalKey<FormState>();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Account'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  key: _registerFormKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: TextFormField(
                          focusNode: _focusName,
                          controller: _nameTextController,
                          validator: (value) =>
                              Validator.validateName(name: value),
                          decoration: InputDecoration(
                            hintText: 'Name',
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: TextFormField(
                          focusNode: _focusEmail,
                          controller: _emailController,
                          validator: (value) =>
                              Validator.validateEmail(email: value),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: TextFormField(
                          focusNode: _focusPassword,
                          controller: _passwordController,
                          validator: (value) =>
                              Validator.validatePassword(password: value),
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
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
                                  final message = await AppStateProvider()
                                      .registration(
                                          name: _nameTextController.text,
                                          email: _emailController.text,
                                          password: _passwordController.text);
                                  if (message!.contains("Success")) {
                                    if (context.mounted) {
                                      context.goNamed(AppPage.home.routeName);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              SnackBar(content: Text(message)));
                                    }
                                  } else {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              SnackBar(content: Text(message)));
                                    }
                                  }
                                }
                                setState(() {
                                  _isProcessing = false;
                                });
                              },
                              child: const Text('Create Account'),
                            ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      TextButton(
                        onPressed: () {
                          context.goNamed(AppPage.login.routeName);
                        },
                        child: const Text('Already registered?'),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
