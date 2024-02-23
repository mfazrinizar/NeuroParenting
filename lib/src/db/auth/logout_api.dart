import 'package:firebase_auth/firebase_auth.dart';
import 'package:neuroparenting/src/db/push_notification/push_notification_api.dart';

class LogoutAPI {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logout() async {
    final pushNotificationApi = PushNotificationAPI();
    await pushNotificationApi.deleteDeviceToken();
    await _auth.signOut();
  }
}
