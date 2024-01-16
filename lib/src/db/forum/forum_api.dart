// under construction
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String text;
  final String avatarUrl;
  final String commenterName;
  final String commenterId;
  final DateTime commentDate;

  Comment({
    required this.text,
    required this.avatarUrl,
    required this.commenterName,
    required this.commenterId,
    required this.commentDate,
  });
}

class Discussion {
  final String userAvatarUrl;
  final String userName;
  final String userType;
  final String title;
  final List<String> tags;
  final DateTime datePosted;
  final List<String> likes;
  int likesTotal;
  final int comments;
  final List<Comment> commentsList;
  final String discussionId;

  Discussion({
    required this.discussionId,
    required this.userAvatarUrl,
    required this.userName,
    required this.userType,
    required this.title,
    required this.tags,
    required this.datePosted,
    required this.likes,
    required this.likesTotal,
    required this.comments,
    required this.commentsList,
  });
}

class ForumApi {
  static Future<List<Discussion>> fetchDiscussions() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('discussions').get();

    return snapshot.docs.map(
      (doc) {
        final data = doc.data();
        return Discussion(
          discussionId: data['discussionId'],
          userAvatarUrl: data['discussionUserPhotoProfileUrl'],
          userName: data['discussionUserName'],
          userType: data['discussionUserType'],
          title: data['discussionTitle'],
          tags: List<String>.from(data['discussionTags']),
          datePosted: (data['postDateAndTime'] as Timestamp).toDate(),
          likes: List<String>.from(data['likes']),
          likesTotal: List<String>.from(data['likes']).length,
          comments: data['commentTotal'],
          commentsList: (data['commentsList'] as List).map(
            (commentData) {
              return Comment(
                text: commentData['text'],
                avatarUrl: commentData['avatarUrl'],
                commenterName: commentData['commenterName'],
                commenterId: commentData['commenterId'],
                commentDate: commentData['commentDate'],
              );
            },
          ).toList(),
        );
      },
    ).toList();
  }

  static Future<void> postComment({
    required String discussionId,
    required Comment comment,
  }) async {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case when the user is not signed in
      return;
    }

    // Prepare the comment details
    final commentData = {
      'text': comment.text,
      'avatarUrl': comment.avatarUrl,
      'commenterName': comment.commenterName,
      'commenterId': user.uid, // Use the user's ID
      'commentDate': DateTime.now(),
    };

    // Add the comment to the 'comments' subcollection of the discussion
    final docRef = await FirebaseFirestore.instance
        .collection('discussions')
        .doc(discussionId)
        .collection('commentsList')
        .add(commentData);

    await docRef.update({'commentId': docRef.id});

    await FirebaseFirestore.instance
        .collection('discussions')
        .doc(discussionId)
        .update({'commentTotal': FieldValue.increment(1)});
  }

  static Future<void> likeOrDislikeDiscussion({
    required String discussionId,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case when the user is not signed in
      return;
    }

    final docRef =
        FirebaseFirestore.instance.collection('discussions').doc(discussionId);
    final doc = await docRef.get();
    final data = doc.data();
    final likes = List<String>.from(data!['likes']);

    if (likes.contains(user.uid)) {
      // The user has already liked the discussion, so they are unliking it
      likes.remove(user.uid);
    } else {
      // The user hasn't liked the discussion yet, so they are liking it
      likes.add(user.uid);
    }

    // Update the likes in Firestore
    await docRef.update({'likes': likes});
  }

  static Future<void> postDiscussion({
    required String titlePost,
    required String descriptionPost,
    required Map<String, bool> tagCheckboxes,
    required File newPostImage,
    required String userType,
  }) async {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case when the user is not signed in
      return;
    }
    List<String> likes = [];
    const int initialComment = 0;
    List<Comment> comments = [];
    final postDateAndTime = DateTime.now();

    // Upload the image to Firebase Storage
    final ref = FirebaseStorage.instance.ref().child('discussion_images').child(
        '${postDateAndTime.toIso8601String()}${path.extension(newPostImage.path)}');

    await ref.putFile(newPostImage);

    // Get the URL of the uploaded image
    final url = await ref.getDownloadURL();

    // Prepare the discussion details
    final discussion = {
      'discussionUserName': user.displayName,
      'discussionUserType': userType,
      'discussionUserPhotoProfileUrl':
          user.photoURL, // Use the user's photo URL
      'discussionPostUserId': user.uid, // Use the user's ID
      'discussionImage': url,
      'discussionTitle': titlePost,
      'discussionDescription': descriptionPost,
      'discussionTags': tagCheckboxes.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList(), // Only true tags
      'postDateAndTime': postDateAndTime,
      'commentTotal': initialComment,
      'commentsList': comments,
      'likes': likes,
    };

    // Upload the discussion details to Firestore
    final docRef = await FirebaseFirestore.instance
        .collection('discussions')
        .add(discussion);

    // Update the document to include the ID
    await docRef.update(
      {'discussionId': docRef.id},
    );
  }
}
