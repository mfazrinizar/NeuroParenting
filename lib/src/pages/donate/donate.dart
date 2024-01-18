// under_construction.dart

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: isDarkMode
          ? ThemeClass.darkTheme.colorScheme.background
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
            child: ThemeSwitcher(onPressed: () {
              setState(() {
                themeChange();
                isDarkMode = !isDarkMode;
              });
            }),
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
                            const Text('Please Fill the Form',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            const Text(
                              'Your donation means so much for our kids in need',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            TextFormField(
                              controller: donationAmountController,
                              keyboardType: TextInputType.number,
                              validator: FormValidator.validateText,
                              decoration: const InputDecoration(
                                labelStyle: TextStyle(
                                  color: Colors
                                      .black, // Change this to your desired color
                                ),
                                hintText: '10000 (in IDR)',
                                labelText: 'Donation Amount',
                                prefixIcon:
                                    Icon(Icons.favorite, color: Colors.black),
                              ),
                            ),
                            TextFormField(
                              controller: donationMessageController,
                              validator: FormValidator.validateText,
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                labelStyle: TextStyle(
                                  color: Colors
                                      .black, // Change this to your desired color
                                ),
                                hintText: 'I want to donate...',
                                labelText: 'Donation Message',
                                prefixIcon:
                                    Icon(Icons.message, color: Colors.black),
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
                                  // Call loginUser from LoginApi
                                  EasyLoading.show(
                                      status: 'Processing Payment...');

                                  await Future.delayed(
                                      const Duration(seconds: 2));
                                  if (!context.mounted) return;
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
                                    title: 'Thank You',
                                    desc:
                                        'Your donation and your message has been received.',
                                    btnOkOnPress: () {
                                      DismissType.btnOk;
                                    },
                                  ).show();
                                  EasyLoading.dismiss();

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
