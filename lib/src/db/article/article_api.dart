import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Article {
  final String title;
  final String body;
  final String imageUrl;

  Article({
    required this.title,
    required this.body,
    required this.imageUrl,
  });
}

class ArticleApi {
  static Future<List<Article>> fetchArticles() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('articles').get();

    return snapshot.docs.map(
      (doc) {
        final data = doc.data();
        return Article(
          title: data['title'],
          body: data['body'],
          imageUrl: data['imageUrl'],
        );
      },
    ).toList();
  }

  static Future<String> postArticle({
    required String title,
    required String body,
    required File image,
  }) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if ((userDoc.data())!.containsKey('adminAccess') &&
        userDoc['adminAccess'] == true) {
      final ref = FirebaseStorage.instance.ref().child('article_images').child(
          '${DateTime.now().toIso8601String()}${path.extension(image.path)}');

      await ref.putFile(image);

      final url = await ref.getDownloadURL();

      final article = {
        'title': title,
        'body': body,
        'imageUrl': url,
      };

      await FirebaseFirestore.instance.collection('articles').add(article);

      return 'SUCCESS';
    } else {
      return 'NOT-ADMIN';
    }
  }
}
