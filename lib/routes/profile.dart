// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    FlutterNativeSplash.remove();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 10,
        ),
        body: FutureBuilder(
            future: _currentUser,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                User currentUser = snapshot.data;
                return SafeArea(
                    child: Column(
                  children: [
                    const Center(
                        child: Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text(
                              'Profile',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.blueAccent,
                              ),
                            ))),
                    InkWell(
                        onTap: () {
                          context.goNamed(AppPage.profileEdit.routeName);
                        },
                        child: Container(
                          height: 10.w * 10,
                          width: 10.w * 10,
                          margin: EdgeInsets.only(top: 10.w * 3),
                          child: Stack(
                            children: <Widget>[
                              currentUser.photoURL == null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2, color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(150),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.person, size: 100),
                                      ))
                                  : ExtendedImage.network(
                                      currentUser.photoURL ?? "",
                                      handleLoadingProgress: true,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      height: 200.sh,
                                      fit: BoxFit.fitHeight,
                                      shape: BoxShape.circle,
                                      width: 200.sw,
                                      clearMemoryCacheIfFailed: true,
                                      clearMemoryCacheWhenDispose: true,
                                      cache: false, loadStateChanged:
                                          (ExtendedImageState state) {
                                      switch (state.extendedImageLoadState) {
                                        case LoadState.loading:
                                          return const Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                CircularProgressIndicator(
                                                  color: Colors.blueAccent,
                                                )
                                              ],
                                            ),
                                          );
                                        case LoadState.completed:
                                          return null;
                                        case LoadState.failed:
                                          return GestureDetector(
                                            child: const Stack(
                                              fit: StackFit.expand,
                                              children: <Widget>[
                                                Icon(Icons.error),
                                                Positioned(
                                                  bottom: 0.0,
                                                  left: 0.0,
                                                  right: 0.0,
                                                  child: Text(
                                                    "load image failed, click to reload",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              ],
                                            ),
                                            onTap: () {
                                              state.reLoadImage();
                                            },
                                          );
                                      }
                                    }),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  height: 10.w * 2.5,
                                  width: 10.w * 2.5,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 2, color: Colors.blueAccent)),
                                  child: Center(
                                    heightFactor: 10.w * 1.5,
                                    widthFactor: 10.w * 1.5,
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.blueAccent,
                                      size: ScreenUtil().setSp(10.w * 1.5),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${currentUser.displayName}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(10.w * 1.7),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "${currentUser.email}",
                                  textAlign: TextAlign.start,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
                            ),
                            child: const Text('Sign out'),
                          ),
                  ],
                ));

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'NAME: ${currentUser.displayName}',
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'EMAIL: ${currentUser.email}',
                      ),
                      const SizedBox(height: 16.0),
                      currentUser.emailVerified
                          ? const Text(
                              'Email verified',
                            )
                          : const Text(
                              'Email not verified',
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
