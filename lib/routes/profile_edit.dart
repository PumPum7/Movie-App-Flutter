// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:movie_faves/globals/app_state_provider.dart';
import 'package:movie_faves/utils/router_utils.dart';
import 'package:movie_faves/utils/upload_photo.dart';
import 'package:movie_faves/utils/validator.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

Future<User?> getCurrentUser() async {
  return await AppStateProvider().refreshUser();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  bool _isEditingProfile = false;

  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  File? _image;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final _picker = ImagePicker();
  // Implementing the image picker

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  final _registerFormKey = GlobalKey<FormState>();

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

                _emailController.text = currentUser.email ?? "";
                _nameTextController.text = currentUser.displayName ?? "";
                return GestureDetector(
                    onTap: () {
                      _focusName.unfocus();
                      _focusEmail.unfocus();
                      _focusPassword.unfocus();
                    },
                    child: Column(
                      children: [
                        Stack(children: [
                          TextButton(
                              onPressed: () {
                                context.goNamed(AppPage.profile.routeName);
                              },
                              child: const Icon(Icons.arrow_back_ios)),
                          const Center(
                              child: Padding(
                                  padding: EdgeInsets.only(bottom: 25),
                                  child: Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.blueAccent,
                                    ),
                                  ))),
                        ]),
                        InkWell(
                          onTap: () => _showPicker(context),
                          child: Container(
                            height: 10.w * 10,
                            width: 10.w * 10,
                            margin: EdgeInsets.only(top: 10.w * 3),
                            child: Stack(
                              children: [
                                currentUser.photoURL == null || _image != null
                                    ? _image == null
                                        ? Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Icon(
                                              Icons.person,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.1,
                                            ))
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            child: Image.file(
                                              _image!,
                                              height: 300.sh,
                                              fit: BoxFit.fitHeight,
                                              width: 200.sw,
                                            ),
                                          )
                                    : ExtendedImage.network(
                                        currentUser.photoURL ?? "",
                                        handleLoadingProgress: true,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        height: 300.sh,
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
                                                      textAlign:
                                                          TextAlign.center,
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
                                Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Icon(Icons.edit, size: 25.w))
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Form(
                                  key: _registerFormKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
                                        child: TextFormField(
                                          focusNode: _focusName,
                                          controller: _nameTextController,
                                          validator: (value) =>
                                              Validator.validateName(
                                                  name: value),
                                          decoration: InputDecoration(
                                            hintText: 'Name',
                                            labelText: "Name",
                                            errorBorder: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
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
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
                                        child: TextFormField(
                                          focusNode: _focusEmail,
                                          controller: _emailController,
                                          validator: (value) =>
                                              Validator.validateEmail(
                                                  email: value),
                                          decoration: InputDecoration(
                                            hintText: 'Email',
                                            labelText: "Email",
                                            errorBorder: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
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
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
                                        child: TextFormField(
                                          focusNode: _focusPassword,
                                          controller: _passwordController,
                                          obscureText: true,
                                          validator: (value) =>
                                              Validator.validatePassword(
                                                  password: value),
                                          decoration: InputDecoration(
                                            hintText: 'Password',
                                            labelText: "Password",
                                            errorBorder: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                              borderSide: const BorderSide(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _isEditingProfile
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    _isEditingProfile = true;
                                  });

                                  if (_registerFormKey.currentState!
                                      .validate()) {
                                    var credential =
                                        EmailAuthProvider.credential(
                                            password: _passwordController.text,
                                            email: currentUser.email ?? "");

                                    try {
                                      await currentUser
                                          .reauthenticateWithCredential(
                                              credential);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content:
                                            Text("Wrong password provided!"),
                                        backgroundColor: Colors.red,
                                      ));
                                      setState(() {
                                        _isEditingProfile = false;
                                      });
                                      return;
                                    }

                                    if (_nameTextController.text !=
                                        currentUser.displayName) {
                                      await currentUser.updateDisplayName(
                                          _nameTextController.text);
                                    }

                                    if (_emailController.text !=
                                        currentUser.email) {
                                      await currentUser.verifyBeforeUpdateEmail(
                                          _emailController.text);
                                    }

                                    if (_image != null) {
                                      String? photoUrl =
                                          await uploadFile(_image, currentUser);
                                      if (photoUrl == null) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                                "Something went wrong while updating the image!"),
                                            backgroundColor: Colors.red,
                                          ));
                                          setState(() {
                                            _isEditingProfile = false;
                                          });
                                          return;
                                        }
                                      }
                                      await currentUser
                                          .updatePhotoURL(photoUrl);
                                    }

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "Profile successfully updated!"),
                                        backgroundColor: Colors.green,
                                      ));
                                      context
                                          .goNamed(AppPage.profile.routeName);
                                    }
                                  }

                                  setState(() {
                                    _isEditingProfile = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text('Save Changes'),
                              ),
                      ],
                    ));
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
