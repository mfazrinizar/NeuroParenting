import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:neuroparenting/src/db/auth/forgot_password_api.dart';
import 'package:neuroparenting/src/reusable_comp/language_changer.dart';
import 'package:neuroparenting/src/reusable_comp/theme_changer.dart';
import 'package:neuroparenting/src/reusable_func/form_validator.dart';
import 'package:neuroparenting/src/reusable_func/localization_change.dart';
import 'package:neuroparenting/src/reusable_func/theme_change.dart';
import 'package:neuroparenting/src/theme/theme.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'login.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  ForgotState createState() => ForgotState();
}

class ForgotState extends State<ForgotPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
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
          onPressed: () => Get.offAll(() => const LoginPage()),
        ),
        title: const Text('Forgot Password',
            style: TextStyle(color: Colors.white)),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.transparent
                  : Colors
                      .white, // Change this to your desired background color
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25), // Adjust the radius as needed
              ),
            ),
            child: const LanguageSwitcher(onPressed: localizationChange),
          ),
          Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.transparent
                  : Colors
                      .white, // Change this to your desired background color
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
                      ? 'assets/images/forgot1_dark.svg'
                      : 'assets/images/forgot1_light.svg',
                  width: width,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                  top: height * 0.35,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: ShapeDecoration(
                      color:
                          isDarkMode ? ThemeClass().darkRounded : Colors.white,
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
                              const Text('Please enter your email below:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  )),
                              TextFormField(
                                controller: emailController,
                                validator: FormValidator.validateEmail,
                                decoration: const InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Colors
                                        .black, // Change this to your desired color
                                  ),
                                  hintText: 'email@name.domain',
                                  labelText: 'Email',
                                  prefixIcon:
                                      Icon(Icons.email, color: Colors.black),
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
                                    EasyLoading.show(status: 'Processing...');
                                    ForgotPasswordApi loginApi =
                                        ForgotPasswordApi();
                                    Map<String, dynamic> result = await loginApi
                                        .resetPassword(emailController.text);
                                    EasyLoading.dismiss();
                                    if (!context.mounted) return;
                                    // Check the result
                                    if (result['status'] == 'success') {
                                      // If the login was successful, navigate to HomePage

                                      AwesomeDialog(
                                        dismissOnTouchOutside: false,
                                        context: context,
                                        keyboardAware: true,
                                        dismissOnBackKeyPress: false,
                                        dialogType: DialogType.success,
                                        animType: AnimType.scale,
                                        transitionAnimationDuration:
                                            const Duration(milliseconds: 200),
                                        btnOkText: "Login",
                                        btnCancelText: "Stay",
                                        title: 'Password Has Been Reset',
                                        desc: result['message'],
                                        btnOkOnPress: () {
                                          Get.offAll(() => const LoginPage());
                                        },
                                      ).show();
                                    } else {
                                      // If there was an error, show a message to the user
                                      AwesomeDialog(
                                        dismissOnTouchOutside: false,
                                        context: context,
                                        keyboardAware: true,
                                        dismissOnBackKeyPress: false,
                                        dialogType: DialogType.error,
                                        animType: AnimType.scale,
                                        transitionAnimationDuration:
                                            const Duration(milliseconds: 200),
                                        btnOkText: "Ok",
                                        title: 'Error Occured',
                                        desc: result['message'],
                                        btnOkOnPress: () {
                                          DismissType.btnOk;
                                        },
                                      ).show();
                                      // Get.snackbar('Error: ', result['message']);
                                    }
                                  }
                                },
                                child: const Text('   Reset   ',
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ]),
    );
  }
}
