// under construction

import 'package:firebase_storage/firebase_storage.dart';

Future<String> getUserProfilePicUrl(String userId) async {
  final refJpg =
      FirebaseStorage.instance.ref().child('profile_pictures/$userId.jpg');
  final refPng =
      FirebaseStorage.instance.ref().child('profile_pictures/$userId.png');

  try {
    String url = await refJpg.getDownloadURL();
    return url;
  } catch (e) {
    String url = await refPng.getDownloadURL();
    return url;
  }
}
