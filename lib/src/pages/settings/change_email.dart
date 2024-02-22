import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:neuroparenting/src/db/settings/change_email_api.dart';
import 'package:neuroparenting/src/homepage.dart';
import 'package:neuroparenting/src/reusable_comp/language_changer.dart';
import 'package:neuroparenting/src/reusable_comp/theme_changer.dart';
import 'package:neuroparenting/src/reusable_func/localization_change.dart';
import 'package:neuroparenting/src/reusable_func/theme_change.dart';
import 'package:neuroparenting/src/theme/theme.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  ChangeEmailState createState() => ChangeEmailState();
}

class ChangeEmailState extends State<ChangeEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  bool isDarkMode = Get.isDarkMode;

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
          onPressed: () => Get.offAll(
            () => const HomePage(indexFromPrevious: 2),
          ),
        ),
        title:
            const Text('Change Email', style: TextStyle(color: Colors.white)),
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
            child: ThemeSwitcher(
              color: isDarkMode
                  ? const Color.fromARGB(255, 211, 227, 253)
                  : Colors.black,
              onPressed: () {
                setState(() {
                  themeChange();
                  isDarkMode = !isDarkMode;
                });
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  child: SvgPicture.asset(
                    isDarkMode
                        ? 'assets/images/changeemail1_dark.svg'
                        : 'assets/images/changeemail1_light.svg',
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
                              Text(
                                'Please enter your new email below:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode
                                      ? const Color.fromARGB(255, 211, 227, 253)
                                      : Colors.black,
                                ),
                              ),
                              TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: isDarkMode
                                        ? const Color.fromARGB(
                                            255, 211, 227, 253)
                                        : Colors
                                            .black, // Change this to your desired color
                                  ),
                                  hintText: 'email@email.com',
                                  labelText: 'New Email',
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: isDarkMode
                                        ? const Color.fromARGB(
                                            255, 211, 227, 253)
                                        : Colors.black,
                                  ),
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
                                    EasyLoading.show(
                                        status: 'Changing Email...');
                                    final result = await ChangeEmailAPI()
                                        .changeEmail(nameController.text);
                                    EasyLoading.dismiss();
                                    if (!context.mounted) return;
                                    if (result == 'SUCCESS_SIR') {
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
                                            'We\'ve changed your email, please proceed.',
                                        btnOkOnPress: () {
                                          Get.offAll(() => const HomePage(
                                                indexFromPrevious: 2,
                                              ));
                                        },
                                      ).show();
                                    } else if (result == 'ERROR') {
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
                                        title: 'Error',
                                        desc:
                                            'There was an error changing your email, please try again.',
                                        btnOkOnPress: () {
                                          Get.offAll(() => const HomePage(
                                                indexFromPrevious: 2,
                                              ));
                                        },
                                      ).show();
                                    } else if (result == 'NO_USER') {
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
                                        title: 'Error',
                                        desc:
                                            'You are not logged in, please relogin and try again.',
                                        btnOkOnPress: () {
                                          Get.offAll(() => const HomePage(
                                                indexFromPrevious: 2,
                                              ));
                                        },
                                      ).show();
                                    }
                                  }
                                },
                                child: Text('   Change   ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: isDarkMode
                                          ? const Color.fromARGB(
                                              255, 211, 227, 253)
                                          : Colors.white,
                                    )),
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
        ],
      ),
    );
  }
}
