// under_construction.dart

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:neuroparenting/src/db/payment/midtrans_api.dart';
import 'package:neuroparenting/src/reusable_comp/language_changer.dart';
import 'package:neuroparenting/src/reusable_comp/theme_changer.dart';
import 'package:neuroparenting/src/reusable_func/form_validator.dart';
import 'package:neuroparenting/src/reusable_func/localization_change.dart';
import 'package:neuroparenting/src/reusable_func/theme_change.dart';
import 'package:neuroparenting/src/theme/theme.dart';
import 'package:neuroparenting/src/homepage.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  DonateState createState() => DonateState();
}

class DonateState extends State<DonatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController donationAmountController =
      TextEditingController();
  final TextEditingController donationMessageController =
      TextEditingController();
  bool isDarkMode = Get.isDarkMode;
  late TransactionResult transactionCallbackResult;

  @override
  void initState() {
    super.initState();
    MidtransAPI.initSDK(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: isDarkMode
          ? ThemeClass.darkTheme.scaffoldBackgroundColor
          : ThemeClass().lightPrimaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(
            color: Colors.white,
            onPressed: () => Get.offAll(() => const HomePage())),
        title: const Text('Donate', style: TextStyle(color: Colors.white)),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.transparent : Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
              ),
            ),
            child: const LanguageSwitcher(onPressed: localizationChange),
          ),
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.transparent : Colors.white,
            ),
            child: ThemeSwitcher(
              color: isDarkMode
                  ? const Color.fromARGB(255, 211, 227, 253)
                  : Colors.black,
              onPressed: () {
                setState(
                  () {
                    themeChange();
                    isDarkMode = !isDarkMode;
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: Stack(
            children: [
              Positioned(
                right: 0,
                child: SvgPicture.asset(
                  isDarkMode
                      ? 'assets/images/donate1_dark.svg'
                      : 'assets/images/donate1_light.svg',
                  width: width * 1,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: height * 0.33,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: ShapeDecoration(
                    color: isDarkMode ? ThemeClass().darkRounded : Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          topLeft: Radius.circular(50)),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.05,
                            ),
                            Text(
                              'Please Fill the Form',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode
                                    ? const Color.fromARGB(255, 211, 227, 253)
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              'Your donation means so much for our kids in need',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDarkMode
                                    ? const Color.fromARGB(255, 211, 227, 253)
                                    : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            TextFormField(
                              controller: donationAmountController,
                              keyboardType: TextInputType.number,
                              validator: FormValidator.validateText,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: isDarkMode
                                      ? const Color.fromARGB(255, 211, 227, 253)
                                      : Colors
                                          .black, // Change this to your desired color
                                ),
                                hintText: '10000 (in IDR)',
                                labelText: 'Donation Amount',
                                prefixIcon: Icon(Icons.favorite,
                                    color: isDarkMode
                                        ? const Color.fromARGB(
                                            255, 211, 227, 253)
                                        : Colors.black),
                              ),
                            ),
                            TextFormField(
                              controller: donationMessageController,
                              validator: FormValidator.validateText,
                              style: TextStyle(
                                  color: isDarkMode
                                      ? const Color.fromARGB(255, 211, 227, 253)
                                      : Colors.black),
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: isDarkMode
                                      ? const Color.fromARGB(255, 211, 227, 253)
                                      : Colors
                                          .black, // Change this to your desired color
                                ),
                                hintText: 'I want to donate...',
                                labelText: 'Donation Message',
                                prefixIcon: Icon(Icons.message,
                                    color: isDarkMode
                                        ? const Color.fromARGB(
                                            255, 211, 227, 253)
                                        : Colors.black),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.05,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.grey,
                                elevation: 5,
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final user =
                                      FirebaseAuth.instance.currentUser;

                                  if (user != null) {
                                    EasyLoading.show(
                                        status: 'Processing Payment...');

                                    String displayName = user.displayName ?? "";
                                    int spaceAtIndex = displayName.indexOf(' ');

                                    final token =
                                        await MidtransAPI.generatePaymentToken(
                                            itemName:
                                                "Donation for NeuroDivergent Kids",
                                            itemDescription:
                                                donationMessageController.text,
                                            priceTotal:
                                                int.parse(
                                                    donationAmountController
                                                        .text),
                                            firstName:
                                                displayName
                                                    .substring(0, spaceAtIndex),
                                            lastName: displayName
                                                .substring(spaceAtIndex + 1),
                                            email:
                                                user.email ?? "null@email.com",
                                            itemId: "donate",
                                            category: "donation");

                                    await MidtransAPI.startPaymentUiFlow(token);

                                    final result = await MidtransAPI
                                        .returnTransactionCallbackResult();

                                    final responseBody = result.toJson();

                                    if (!context.mounted) return;
                                    if (!responseBody[
                                        'isTransactionCanceled']) {
                                      AwesomeDialog(
                                        dismissOnTouchOutside: false,
                                        context: context,
                                        keyboardAware: true,
                                        dismissOnBackKeyPress: false,
                                        dialogType: DialogType.success,
                                        animType: AnimType.scale,
                                        transitionAnimationDuration:
                                            const Duration(milliseconds: 200),
                                        btnOkText: "Ok",
                                        title: 'Donation Success',
                                        desc:
                                            'Thank you for your donation. Your donation and your message has been received.',
                                        btnOkOnPress: () {
                                          DismissType.btnOk;
                                        },
                                      ).show();
                                    } else {
                                      AwesomeDialog(
                                        dismissOnTouchOutside: false,
                                        context: context,
                                        keyboardAware: true,
                                        dismissOnBackKeyPress: false,
                                        dialogType: DialogType.info,
                                        animType: AnimType.scale,
                                        transitionAnimationDuration:
                                            const Duration(milliseconds: 200),
                                        btnOkText: "Ok",
                                        title: 'Donation Canceled',
                                        desc:
                                            'You have canceled your donation or error occured.',
                                        btnOkOnPress: () {
                                          DismissType.btnOk;
                                        },
                                      ).show();
                                    }

                                    // await Future.delayed(
                                    //     const Duration(seconds: 2));
                                    MidtransAPI
                                        .removeTransactionFinishedCallback();
                                    responseBody.clear();

                                    EasyLoading.dismiss();
                                  }

                                  // TODO: Save payment to Firebase

                                  // Check the result
                                  // if (result['status'] == 'success') {
                                  //   // If the login was successful, navigate to HomePage
                                  //   Get.offAll(() => const HomePage());
                                  // } else {
                                  //   // If there was an error, show a message to the user
                                  //   if (!context.mounted) return;
                                  //   AwesomeDialog(
                                  //     dismissOnTouchOutside: false,
                                  //     context: context,
                                  //     keyboardAware: true,
                                  //     dismissOnBackKeyPress: false,
                                  //     dialogType: DialogType.error,
                                  //     animType: AnimType.scale,
                                  //     transitionAnimationDuration:
                                  //         const Duration(milliseconds: 200),
                                  //     btnOkText: "Ok",
                                  //     title: 'Error Occured',
                                  //     desc: result['message'],
                                  //     btnOkOnPress: () {
                                  //       DismissType.btnOk;
                                  //     },
                                  //   ).show();
                                  //   // Get.snackbar('Error: ', result['message']);
                                  // }
                                }
                              },
                              child: const Text('  Donate  ',
                                  style: TextStyle(fontSize: 20)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
