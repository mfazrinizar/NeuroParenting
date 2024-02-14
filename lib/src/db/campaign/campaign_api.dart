import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Campaign {
  final DateTime campaignDate;
  final String campaignUrl;
  final String campaignDescription;
  final String campaignImage;

  Campaign({
    required this.campaignDate,
    required this.campaignUrl,
    required this.campaignDescription,
    required this.campaignImage,
  });
}

class CampaignApi {
  static Future<List<Campaign>> fetchCampaigns() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('campaigns').get();

    return snapshot.docs.map(
      (doc) {
        final data = doc.data();
        return Campaign(
          campaignDate: (data['campaignDate'] as Timestamp).toDate(),
          campaignUrl: data['campaignUrl'],
          campaignDescription: data['campaignDescription'],
          campaignImage: data['campaignImage'],
        );
      },
    ).toList();
  }

  static Future<String> postCampaign({
    required String campaignUrl,
    required String campaignDescription,
    required File campaignImage,
  }) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if ((userDoc.data())!.containsKey('adminAccess') &&
        userDoc['adminAccess'] == true) {
      final ref = FirebaseStorage.instance.ref().child('campaign_images').child(
          '${DateTime.now().toIso8601String()}${path.extension(campaignImage.path)}');

      await ref.putFile(campaignImage);

      final url = await ref.getDownloadURL();

      final campaign = {
        'campaignUrl': campaignUrl,
        'campaignDescription': campaignDescription,
        'campaignImage': url,
        'campaignDate': DateTime.now(),
      };

      await FirebaseFirestore.instance.collection('campaigns').add(campaign);

      return 'SUCCESS';
    } else {
      return 'NOT-ADMIN';
    }
  }
}
