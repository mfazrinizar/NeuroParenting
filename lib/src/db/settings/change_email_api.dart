import 'package:firebase_auth/firebase_auth.dart';

class ChangeEmailAPI {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> changeEmail(String newEmail) async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        await user.updateEmail(newEmail);
        return 'SUCCESS'; // Return 'SUCCESS' if the email was updated successfully
      } catch (e) {
        return 'ERROR'; // Return 'ERROR' if there was an error updating the email
      }
    } else {
      return 'NO_USER'; // Return 'NO_USER' if no user is currently signed in
    }
  }
}
