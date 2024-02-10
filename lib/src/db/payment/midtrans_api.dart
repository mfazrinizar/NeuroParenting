import 'package:flutter/material.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MidtransAPI {
  static MidtransSDK? _midtrans;

  static Future<void> initSDK(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString('locale') ?? 'en';

    _midtrans = await MidtransSDK.init(
      config: MidtransConfig(
        clientKey: dotenv.env['MIDTRANS_CLIENT_KEY'] ?? "",
        merchantBaseUrl: dotenv.env['MIDTRANS_MERCHANT_BASE_URL'] ?? "",
        language: languageCode,
        // colorTheme: ColorTheme(
        //   colorPrimary: Theme.of(context).colorScheme.secondary,
        //   colorPrimaryDark: Theme.of(context).colorScheme.secondary,
        //   colorSecondary: Theme.of(context).colorScheme.secondary,
        // ),
      ),
    );
    _midtrans?.setUIKitCustomSetting(
      skipCustomerDetailsPages: true,
    );
    _midtrans!.setTransactionFinishedCallback((result) {
      print(result.toJson());
    });
  }

  static void removeTransactionFinishedCallback() {
    _midtrans?.removeTransactionFinishedCallback();
  }

  static void startPaymentUiFlow() {
    _midtrans?.startPaymentUiFlow(
      token: dotenv.env['SNAP_TOKEN'],
    );
  }
}
