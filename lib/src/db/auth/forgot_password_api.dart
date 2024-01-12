import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordApi {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      // Send password reset request
      await _auth.sendPasswordResetEmail(email: email);
      return {'status': 'success', 'message': 'Password reset email sent.'};
    } on FirebaseAuthException catch (e) {
      return {'status': 'error', 'message': e.code};
    } catch (e) {
      return {'status': 'error', 'message': 'An error occurred'};
    }
  }
}
