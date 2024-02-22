// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neuroparenting/src/encrypted/env.dart';

import 'package:neuroparenting/main.dart';

Future<void> main() async {
  final json = await rootBundle.loadString('encryption_key.json');
  final secretsMap = jsonDecode(json) as Map<String, dynamic>;
  final encryptionKey = secretsMap['ENCRYPTION_KEY'] as String;
  final iv = secretsMap['IV'] as String;
  final env = Env(encryptionKey, iv);

  if (kDebugMode) {
    print(env.toString());
  }

  // await dotenv.load(fileName: ".env");

  // expect(env.midtransClientKeyProduction,
  //     dotenv.env['MIDTRANS_CLIENT_KEY_PRODUCTION']);
  // expect(
  //     env.midtransClientKeySandbox, dotenv.env['MIDTRANS_CLIENT_KEY_SANDBOX']);
  // expect(env.midtransMerchantBaseUrl, dotenv.env['MIDTRANS_MERCHANT_BASE_URL']);
  // expect(env.midtransCancelBaseUrl, dotenv.env['MIDTRANS_CANCEL_BASE_URL']);
  // expect(env.geminiApiKey, dotenv.env['GEMINI_API_KEY']);
  // expect(env.firebaseWebApiKey, dotenv.env['FIREBASE_WEB_API_KEY']);
  // expect(env.firebaseWebAppId, dotenv.env['FIREBASE_WEB_APP_ID']);
  // expect(env.firebaseWebMessagingSenderId,
  //     dotenv.env['FIREBASE_WEB_MESSAGING_SENDER_ID']);
  // expect(env.firebaseWebProjectId, dotenv.env['FIREBASE_WEB_PROJECT_ID']);
  // expect(env.firebaseWebAuthDomain, dotenv.env['FIREBASE_WEB_AUTH_DOMAIN']);
  // expect(env.firebaseWebDatabaseUrl, dotenv.env['FIREBASE_WEB_DATABASE_URL']);
  // expect(
  //     env.firebaseWebStorageBucket, dotenv.env['FIREBASE_WEB_STORAGE_BUCKET']);
  // expect(env.firebaseWebAppMeasurementId,
  //     dotenv.env['FIREBASE_WEB_APP_MEASUREMENT_ID']);
  // expect(env.firebaseAndroidApiKey, dotenv.env['FIREBASE_ANDROID_API_KEY']);
  // expect(env.firebaseAndroidAppId, dotenv.env['FIREBASE_ANDROID_APP_ID']);
  // expect(env.firebaseAndroidMessagingSenderId,
  //     dotenv.env['FIREBASE_ANDROID_MESSAGING_SENDER_ID']);
  // expect(
  //     env.firebaseAndroidProjectId, dotenv.env['FIREBASE_ANDROID_PROJECT_ID']);
  // expect(env.firebaseAndroidDatabaseUrl,
  //     dotenv.env['FIREBASE_ANDROID_DATABASE_URL']);
  // expect(env.firebaseAndroidStorageBucket,
  //     dotenv.env['FIREBASE_ANDROID_STORAGE_BUCKET']);
  // expect(env.firebaseIosApiKey, dotenv.env['FIREBASE_IOS_API_KEY']);
  // expect(env.firebaseIosAppId, dotenv.env['FIREBASE_IOS_APP_ID']);
  // expect(env.firebaseIosMessagingSenderId,
  //     dotenv.env['FIREBASE_IOS_MESSAGING_SENDER_ID']);
  // expect(env.firebaseIosProjectId, dotenv.env['FIREBASE_IOS_PROJECT_ID']);
  // expect(env.firebaseIosDatabaseUrl, dotenv.env['FIREBASE_IOS_DATABASE_URL']);
  // expect(
  //     env.firebaseIosStorageBucket, dotenv.env['FIREBASE_IOS_STORAGE_BUCKET']);
  // expect(env.firebaseIosBundleId, dotenv.env['FIREBASE_IOS_BUNDLE_ID']);
  // expect(env.firebaseMacosApiKey, dotenv.env['FIREBASE_MACOS_API_KEY']);
  // expect(env.firebaseMacosAppId, dotenv.env['FIREBASE_MACOS_APP_ID']);
  // expect(env.firebaseMacosMessagingSenderId,
  //     dotenv.env['FIREBASE_MACOS_MESSAGING_SENDER_ID']);
  // expect(env.firebaseMacosProjectId, dotenv.env['FIREBASE_MACOS_PROJECT_ID']);
  // expect(
  //     env.firebaseMacosDatabaseUrl, dotenv.env['FIREBASE_MACOS_DATABASE_URL']);
  // expect(env.firebaseMacosStorageBucket,
  //     dotenv.env['FIREBASE_MACOS_STORAGE_BUCKET']);
  // expect(
  //     env.firebaseMacosIosBundleId, dotenv.env['FIREBASE_MACOS_IOS_BUNDLE_ID']);

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
