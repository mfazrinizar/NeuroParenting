import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordApi {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> changePassword(String newPassword) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Update the password in the user's Firebase Auth profile
        await currentUser.updatePassword(newPassword);

        return {
          'status': 'success',
          'message': 'Password changed successfully.'
        };
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
