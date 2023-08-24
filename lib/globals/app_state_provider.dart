// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateProvider with ChangeNotifier {
  void hasOnboarded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoardCount', 1);

    notifyListeners();
  }

  Future<String?> registration({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.isEmpty) {
      return "No name provided.";
    }
    if (email.isEmpty) {
      return "No email provided.";
    }
    else if (password.isEmpty) {
      return "No password provided.";
    }
    else if (!email.contains("@")) {
      return "Invalid email provided.";
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.updateDisplayName(name);
      await userCredential.user?.reload();
      notifyListeners();
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty) {
      return "No email provided.";
    }
    else if (password.isEmpty) {
      return "No password provided.";
    }
    else if (!email.contains("@")) {
      return "Invalid email provided.";
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future<User?> refreshUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.currentUser?.reload();

    return auth.currentUser;
  }
}
