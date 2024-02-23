import 'dart:async';

// import 'package:flutter/foundation.dart'; // kDebugMode for sandbox/production key selection
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:neuroparenting/src/encrypted/env.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class MidtransAPI {
  static final env = Env.create();
  static MidtransSDK? _midtrans;
  static Map<String, dynamic>? responseBody;
  static TransactionResult? transactionCallbackResult;

  static Future<String> generatePaymentToken({
    required String itemDescription,
    required int priceTotal,
    required String firstName,
    required String lastName,
    required String email,
    required String itemId,
    required String category,
    required String itemName,
  }) async {
    const isProduction = kDebugMode ? false : true;
    const uniqueId = Uuid();
    String orderId =
        "neuropay-${category.toLowerCase()}-${uniqueId.v4().substring(0, 8)}";

    final response = await http.post(
      Uri.parse(env.midtransMerchantBaseUrl),
      headers: <String, String>{
        'Is-Production': isProduction.toString(),
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'transaction_details': {
          'order_id': orderId,
          'gross_amount': priceTotal,
        },
        'item_details': [
          {
            'id': itemId,
            'category': category,
            'price': priceTotal,
            'quantity': 1,
            'name': itemName,
            'brand': itemDescription,
          },
        ],
        'customer_details': [
          {
            'email': email,
            'first_name': firstName,
            'last_name': lastName,
          },
        ],
      }),
    );

    // if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON.
    return jsonDecode(response.body)['token'];
    // } else {
    //   // If the server did not return a 200 OK response,
    //   // then throw an exception.
    //   throw Exception('Failed to generate token');
    // }
  }

  static Future<void> cancelTransaction(String orderOrTransactionId) async {
    final response = await http.post(
      Uri.parse(env.midtransCancelBaseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'order_id': orderOrTransactionId,
      }),
    );

    // print(jsonDecode(response.body));

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel transaction');
    }
  }

  static Future<void> initSDK(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString('locale') ?? 'en';
    if (!context.mounted) return;
    _midtrans = await MidtransSDK.init(
      config: MidtransConfig(
        clientKey: kDebugMode
            ? env.midtransClientKeySandbox
            : env
                .midtransClientKeyProduction, // waiting for Midtrans review to gain production access
        merchantBaseUrl: env.midtransMerchantBaseUrl,
        language: languageCode,
      ),
    );
    _midtrans?.setUIKitCustomSetting(
      skipCustomerDetailsPages: true,
    );
  }

  static void removeTransactionFinishedCallback() {
    _midtrans?.removeTransactionFinishedCallback();
  }

  static Future<TransactionResult> returnTransactionCallbackResult() {
    final completer = Completer<TransactionResult>();

    _midtrans!.setTransactionFinishedCallback((result) {
      transactionCallbackResult = result;
      if (!completer.isCompleted) {
        completer.complete(transactionCallbackResult);
      }
    });

    return completer.future;
  }

  static Future<void> startPaymentUiFlow(String token) async {
    await _midtrans?.startPaymentUiFlow(token: token);
  }
}

// transactionStatus: null, pending, success