import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:neuroparenting/src/db/settings/change_password_api.dart';
import 'package:neuroparenting/src/reusable_comp/language_changer.dart';
import 'package:neuroparenting/src/reusable_comp/theme_changer.dart';
import 'package:neuroparenting/src/reusable_func/localization_change.dart';
import 'package:neuroparenting/src/reusable_func/theme_change.dart';
import 'package:neuroparenting/src/theme/theme.dart';
import 'package:neuroparenting/src/homepage.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newRePasswordController = TextEditingController();
  bool isDarkMode = Get.isDarkMode,
      oldPasswordVisible = false,
      newPasswordVisible = false,
      newRePasswordVisible = false;

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
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text('Change Password',
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
                      ? 'assets/images/changepw1_dark.svg'
                      : 'assets/images/changepw1_light.svg',
                  width: width * 0.75,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: height * 0.25,
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
                            StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return TextFormField(
                                  controller: oldPasswordController,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    labelStyle: const TextStyle(
                                      color: Colors
                                          .black, // Change this to your desired color
                                    ),
                                    hintText: '********',
                                    labelText: 'Current Password',
                                    prefixIcon: const Icon(Icons.lock,
                                        color: Colors.black),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          oldPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.black),
                                      onPressed: () {
                                        // Update the state i.e. toggle the state of passwordVisible variable
                                        setState(() {
                                          oldPasswordVisible =
                                              !oldPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  obscureText: !oldPasswordVisible,
                                );
                              },
                            ),
                            StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return TextFormField(
                                  controller: newRePasswordController,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    labelStyle: const TextStyle(
                                      color: Colors
                                          .black, // Change this to your desired color
                                    ),
                                    hintText: '********',
                                    labelText: 'New Password',
                                    prefixIcon: const Icon(Icons.password,
                                        color: Colors.black),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          newPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.black),
                                      onPressed: () {
                                        // Update the state i.e. toggle the state of passwordVisible variable
                                        setState(() {
                                          newPasswordVisible =
                                              !newPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  obscureText: !newPasswordVisible,
                                );
                              },
                            ),
                            StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return TextFormField(
                                  controller: newPasswordController,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    labelStyle: const TextStyle(
                                      color: Colors
                                          .black, // Change this to your desired color
                                    ),
                                    hintText: '********',
                                    labelText: 'Re-enter New Password',
                                    prefixIcon: const Icon(Icons.restart_alt,
                                        color: Colors.black),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          newRePasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.black),
                                      onPressed: () {
                                        // Update the state i.e. toggle the state of passwordVisible variable
                                        setState(() {
                                          newRePasswordVisible =
                                              !newRePasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  obscureText: !newRePasswordVisible,
                                );
                              },
                            ),
                            SizedBox(
                              height: height * 0.1,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.grey,
                                elevation: 5,
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.mounted) {
                                  EasyLoading.show(status: 'Changing Password');
                                  final result = await ChangePasswordApi()
                                      .changePassword(
                                          oldPasswordController.text,
                                          newPasswordController.text);
                                  EasyLoading.dismiss();

                                  if (!context.mounted) return;
                                  if (result['status'] == 'SUCCESS_SIR') {
                                    AwesomeDialog(
                                      context: context,
                                      btnOkColor:
                                          ThemeClass().lightPrimaryColor,
                                      keyboardAware: true,
                                      dismissOnBackKeyPress: false,
                                      dialogType: DialogType.success,
                                      animType: AnimType.scale,
                                      transitionAnimationDuration:
                                          const Duration(milliseconds: 200),
                                      btnOkText: "Back",
                                      title: 'Email Changed',
                                      desc:
                                          'We\'ve changed your password, please proceed.',
                                      btnOkOnPress: () {
                                        Get.offAll(() => const HomePage());
                                      },
                                    ).show();
                                  } else if (result['status'] == 'NO_USER') {
                                    AwesomeDialog(
                                      context: context,
                                      btnOkColor:
                                          ThemeClass().lightPrimaryColor,
                                      keyboardAware: true,
                                      dismissOnBackKeyPress: false,
                                      dialogType: DialogType.error,
                                      animType: AnimType.scale,
                                      transitionAnimationDuration:
                                          const Duration(milliseconds: 200),
                                      btnOkText: "Back",
                                      title: 'Error Occured',
                                      desc:
                                          'There was an error changing your email, please relogin and try again.',
                                      btnOkOnPress: () {
                                        Get.offAll(() => const HomePage());
                                      },
                                    ).show();
                                  } else {
                                    AwesomeDialog(
                                      context: context,
                                      btnOkColor:
                                          ThemeClass().lightPrimaryColor,
                                      keyboardAware: true,
                                      dismissOnBackKeyPress: false,
                                      dialogType: DialogType.error,
                                      animType: AnimType.scale,
                                      transitionAnimationDuration:
                                          const Duration(milliseconds: 200),
                                      btnOkText: "Back",
                                      title: 'Error Occured',
                                      desc:
                                          'Please check your password or internet connection and try again.',
                                      btnOkOnPress: () {
                                        Get.offAll(() => const HomePage());
                                      },
                                    ).show();
                                  }
                                }
                              },
                              child: const Text('  Change Password  ',
                                  style: TextStyle(fontSize: 20)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
