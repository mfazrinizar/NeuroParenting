import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeNameApi {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> changeName(String newName) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Update the name in the user's Firebase Auth profile
        await currentUser.updateDisplayName(newName);

        // Update the name in Firestore Database
        await _firestore.collection('users').doc(currentUser.uid).update({
          'name': newName,
        });

        final discussions = await _firestore
            .collection('discussions')
            .where('discussionPostUserId', isEqualTo: currentUser.uid)
            .get();

        for (final doc in discussions.docs) {
          await doc.reference.update({
            'discussionUserName': newName,
          });
        }

        final comments = await _firestore.collection('discussions').get();

        for (final doc in comments.docs) {
          final commentsList =
              List<Map<String, dynamic>>.from(doc.data()['commentsList'] ?? []);

          // Update the avatarUrl for comments made by the current user
          for (final comment in commentsList) {
            if (comment['commenterId'] == currentUser.uid) {
              comment['commenterName'] = newName;
            }
          }

          // Update the commentsList field in the discussion document
          await doc.reference.update({
            'commentsList': commentsList,
          });
        }

        return {'status': 'success', 'message': 'Name changed successfully.'};
      } else {
        return {
          'status': 'error',
          'message': 'No user is currently signed in.'
        };
      }
    } on FirebaseAuthException catch (e) {
      return {'status': 'error', 'message': e.code};
    } catch (e) {
      return {'status': 'error', 'message': 'An error occurred'};
    }
  }
}
