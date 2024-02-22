import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:neuroparenting/firebase_options.dart';
import 'package:neuroparenting/src/pages/settings/payment_history.dart';
// import 'package:rxdart/rxdart.dart';

const channel = AndroidNotificationChannel(
  'high_importance_notifications', // id
  'High Importance Notifications', // title
  importance: Importance.max,
  enableVibration: true,
);

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    log('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    log('User granted provisional permission');
  } else {
    log('User declined or has not accepted permission');
  }
}

@pragma('vm:entry-point')
Future<void> loadFCM() async {
  if (!kIsWeb) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        selectNotification(details.payload);
      },
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: await currentPlatform);

  // Create an instance of PushNotificationAPI
  // RemoteNotification? notification = message.notification;
  // AndroidNotification? android = message.notification?.android;
  // if (notification != null && android != null && !kIsWeb) {
  //   flutterLocalNotificationsPlugin.show(
  //     notification.hashCode,
  //     notification.title,
  //     notification.body,
  //     NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         channel.id,
  //         channel.name,
  //         icon: '@mipmap/ic_launcher',
  //       ),
  //     ),
  //   );
  // }
  return;
}

Future<void> listenFCM() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    _handleMessage(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    _navigateToPageBasedOnMessage(message.data);
  });

  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    _navigateToPageBasedOnMessage(initialMessage.data);
  }

  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
}

Future selectNotification(String? payload) async {
  log('selectNotification: $payload');
  if (payload != null) {
    // Decode the payload into a RemoteMessage
    Map<String, dynamic> messageData = jsonDecode(payload);

    // Navigate based on the message data
    _navigateToPageBasedOnMessage(messageData);
  }
}

void _handleMessage(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }
}

void _navigateToPageBasedOnMessage(Map<String, dynamic> messageData) {
  log('Message data: $messageData');

  if (messageData['screen'] == 'discussion') {
    // Navigate to PaymentHistoryPage
    Get.offAll(() => const PaymentHistoryPage());
  }
}

class PushNotificationAPI {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  // Future<void> storeDeviceToken() async {
  //   final fcmToken = await FirebaseMessaging.instance.getToken();

  //   if (user != null) {
  //     DocumentReference userDoc = firestore.collection('users').doc(user?.uid);
  //     await userDoc.update(
  //       {
  //         'deviceToken': FieldValue.arrayUnion([fcmToken]),
  //       },
  //     );
  //   }
  // }

  Future<void> storeDeviceToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();

    if (user != null) {
      DocumentReference userDoc = firestore.collection('users').doc(user?.uid);
      await userDoc.update(
        {
          'deviceToken': FieldValue.arrayUnion([fcmToken]),
        },
      );
    }
  }

  Future<List<String>?> fetchDeviceToken(String userId) async {
    if (user != null) {
      DocumentReference userDoc = firestore.collection('users').doc(userId);
      DocumentSnapshot userSnapshot = await userDoc.get();
      final deviceToken = await userSnapshot.get('deviceToken');
      if (deviceToken != null && deviceToken is List) {
        return deviceToken.map((item) => item.toString()).toList();
      }
    }
    return null;
  }

  Future<void> notifyUsersWithDiscussionId(
      {required String commentBody,
      required String discussionId,
      required String posterUserId,
      required List<String> commenterUserIds}) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final name = user?.displayName ?? 'Someone';
    List<String>? posterDeviceToken = await fetchDeviceToken(posterUserId);

    List<String> commenterDeviceTokens = [];
    if (commentBody.length > 150) {
      commentBody = '${commentBody.substring(0, 147)}. . .';
    }
    for (String commenterUserId in commenterUserIds) {
      List<String>? tokens = await fetchDeviceToken(commenterUserId);
      if (tokens != null) {
        commenterDeviceTokens.addAll(tokens);
      }
    }

    if (posterDeviceToken != null) {
      for (String token in posterDeviceToken) {
        commenterDeviceTokens
            .remove(token); // token could also be posterDeviceToken[0]
      }
    }
    log(commenterDeviceTokens.toString());
    commenterDeviceTokens.remove(fcmToken);
    posterDeviceToken?.remove(fcmToken) ?? [];
    commenterDeviceTokens = commenterDeviceTokens.toSet().toList();
    commenterDeviceTokens.add(fcmToken ?? "");
    log(commenterDeviceTokens.toString());

    Map<String, dynamic> data = {
      'poster': {
        'tokens': posterDeviceToken ?? [],
        'title': '$name (Your Discussion)',
        'body': commentBody,
        'imageUrl': 'nothing',
        'screen': 'discussion',
        'dataId': discussionId,
      },
      'commenter': {
        'tokens': commenterDeviceTokens,
        'title': '$name (Commented Discussion)',
        'body': commentBody,
        'imageUrl': 'nothing',
        'screen': 'discussion',
        'dataId': discussionId,
      },
    };

    await multiUserTypeSendNotification(data: data);
  }

  Future<void> deleteDeviceToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();

    if (user != null) {
      DocumentReference userDoc = firestore.collection('users').doc(user?.uid);
      await userDoc.update(
        {
          'deviceToken': FieldValue.arrayRemove([fcmToken]),
        },
      );
    }
  }

  Future<void> sendNotification(
    tokens,
    String title,
    String body,
    String? imageUrl,
  ) async {
    FirebaseFunctions functions =
        FirebaseFunctions.instanceFor(region: 'us-central1');

    try {
      final HttpsCallable callable =
          functions.httpsCallable('sendNotification');
      // ignore: unused_local_variable
      final response = await callable.call({
        'tokens': tokens,
        'title': title,
        'body': body,
        'imageUrl': imageUrl ?? "nothing",
        'screen': 'screen',
        'dataId': 'id',
      });

      // log('Message sent: ${response.data}');
    } catch (e) {
      // log('Error sending message: $e');
    }
  }

  Future<void> multiUserTypeSendNotification(
      // tokens,
      // String title,
      // String body,
      // String? imageUrl,
      {required Map<String, dynamic> data}) async {
    FirebaseFunctions functions =
        FirebaseFunctions.instanceFor(region: 'us-central1');

    log(data.toString());

    try {
      // final HttpsCallable callable =
      //     functions.httpsCallable('sendNotification');
      // final response = await callable.call(
      //   {
      //     'tokens': tokens,
      //     'title': title,
      //     'body': body,
      //     'imageUrl': imageUrl ?? "nothing",
      //   },
      // );

      final HttpsCallable callable =
          functions.httpsCallable('sendNotification');

      // Iterate over each user type in the data map
      // log(data.toString());
      for (Map<String, dynamic> notificationData in data.values) {
        // log(notificationData.toString());

        // ignore: unused_local_variable
        final response = await callable.call(notificationData);
        // log('Message sent: ${response.data}');
      }
    } catch (e) {
      // log('Error sending message: $e');
    }
  }

  Future<void> sendToDevice(
      String notifTitle, String notifBody, String deviceToken) async {
    // TODO: implement sendToDevice
  }

  Future<void> storeNotification({
    required String notifTitle,
    required String notifBody,
    required List<String> targetUserIds,
    required String screen,
    required String dataId,
  }) async {
    if (user != null) {
      final senderUserId = user?.uid ?? "";
      final senderPhotoUrl = user?.photoURL ?? "";

      WriteBatch batch = firestore.batch();

      for (String targetUserId in targetUserIds) {
        DocumentReference userDoc =
            firestore.collection('notifications').doc(targetUserId);

        DocumentSnapshot userSnapshot = await userDoc.get();

        int highestNotifId = userSnapshot.get('highestNotifId') ?? 0;
        highestNotifId++;

        String notifId = 'notif$highestNotifId';

        Map<String, dynamic> notifData = {
          'notifTitle': notifTitle,
          'notifBody': notifBody,
          'notifDateTime': DateTime.now(),
          'notifSenderUserId': senderUserId,
          'notifScreen': screen,
          'notifDataId': dataId,
          'notifSenderPhotoUrl': senderPhotoUrl,
        };

        batch.set(
          userDoc,
          {notifId: notifData, 'highestNotifId': highestNotifId},
          SetOptions(merge: true),
        );
      }

      return batch.commit();
    }
  }
}
