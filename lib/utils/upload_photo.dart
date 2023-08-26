// Dart imports:
import 'dart:io';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String?> uploadFile(File? photo, User user) async {
  if (photo == null) return null;

  try {
    final ref =
        FirebaseStorage.instance.ref("/pfps").child(user.uid).child('file/');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      // contentType: 'image/png',
      customMetadata: {'picked-file-path': photo.path},
    );

    await ref.putData(await photo.readAsBytes(), metadata);

    String url = await ref.getDownloadURL();
    return url;
  } catch (e) {
    return null;
  }
}
