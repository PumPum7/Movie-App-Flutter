// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:movie_faves/globals/app_state_provider.dart';
import 'package:movie_faves/utils/router_utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

Future<User?> getCurrentUser() async {
  return await AppStateProvider().refreshUser();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  late Future<User?> _currentUser;

  @override
  void initState() {
    _currentUser = getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: FutureBuilder(
            future: _currentUser,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                User currentUser = snapshot.data;

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'NAME: ${currentUser.displayName}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'EMAIL: ${currentUser.email}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16.0),
                      currentUser.emailVerified
                          ? Text(
                              'Email verified',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.green),
                            )
                          : Text(
                              'Email not verified',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.red),
                            ),
                      const SizedBox(height: 16.0),
                      currentUser.emailVerified
                          ? const SizedBox.shrink()
                          : _isSendingVerification
                              ? const CircularProgressIndicator()
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          _isSendingVerification = true;
                                        });
                                        await currentUser
                                            .sendEmailVerification();
                                        setState(() {
                                          _isSendingVerification = false;
                                        });
                                      },
                                      child: const Text('Verify email'),
                                    ),
                                    const SizedBox(width: 8.0),
                                    IconButton(
                                      icon: const Icon(Icons.refresh),
                                      onPressed: () async {
                                        Future<User?> user =
                                            AppStateProvider().refreshUser();

                                        User? awaitUser = await user;

                                        if (awaitUser != null) {
                                          setState(() {
                                            _currentUser = user;
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                      const SizedBox(height: 16.0),
                      _isSigningOut
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isSigningOut = true;
                                });
                                await FirebaseAuth.instance.signOut();
                                setState(() {
                                  _isSigningOut = false;
                                });
                                if (context.mounted) {
                                  context.goNamed(AppPage.login.routeName);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('Sign out'),
                            ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return const Icon(Icons.error_outline);
              } else {
                return Container(
                  color: Colors.white,
                  child: const Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      SpinKitRotatingCircle(color: Colors.blueAccent, size: 50),
                      Positioned(
                        bottom: 50.0,
                        left: 0.0,
                        right: 0.0,
                        child: Text(
                          "Loading profile details...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              fontSize: 14),
                        ),
                      )
                    ],
                  ),
                );
              }
            }));
  }
}
