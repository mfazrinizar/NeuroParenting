// change_profile_picture.dart

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;

class ChangeProfilePictureApi {
  Future<void> changeProfilePicture(File pickedImage) async {
    EasyLoading.show(status: 'Uploading...');

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final firestore = FirebaseFirestore.instance;

      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${currentUser!.uid}${path.extension(pickedImage.path)}');

      await ref.putFile(pickedImage);

      final url = await ref.getDownloadURL();

      await currentUser.updatePhotoURL(url);

      final discussions = await firestore
          .collection('discussions')
          .where('discussionPostUserId', isEqualTo: currentUser.uid)
          .get();

      for (final doc in discussions.docs) {
        await doc.reference.update({
          'discussionUserPhotoProfileUrl': url,
        });
      }

      final comments = await firestore.collection('discussions').get();

      for (final doc in comments.docs) {
        final commentsList =
            List<Map<String, dynamic>>.from(doc.data()['commentsList'] ?? []);

        for (final comment in commentsList) {
          if (comment['commenterId'] == currentUser.uid) {
            comment['avatarUrl'] = url;
          }
        }

        await doc.reference.update({
          'commentsList': commentsList,
        });
      }

      EasyLoading.dismiss();
      Get.snackbar('Success', 'Image uploaded successfully.');
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar('Error', 'Failed to upload image.');
    }
  }
}
