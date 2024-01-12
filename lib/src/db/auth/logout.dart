import 'package:firebase_auth/firebase_auth.dart';

class LogoutAPI {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logout() async {
    await _auth.signOut();
  }
}
