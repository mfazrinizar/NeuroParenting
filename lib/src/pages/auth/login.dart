import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:neuroparenting/src/db/auth/login_api.dart';
import 'package:neuroparenting/src/pages/auth/start.dart';
import 'package:neuroparenting/src/reusable_comp/language_changer.dart';
import 'package:neuroparenting/src/reusable_comp/theme_changer.dart';
import 'package:neuroparenting/src/reusable_func/form_validator.dart';
import 'package:neuroparenting/src/reusable_func/localization_change.dart';
import 'package:neuroparenting/src/reusable_func/theme_change.dart';
import 'package:neuroparenting/src/theme/theme.dart';
import 'package:neuroparenting/src/homepage.dart';
import 'forgot_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isDarkMode = Get.isDarkMode, passwordVisible = false;

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
            onPressed: () => Get.offAll(const StartPage())),
        title: const Text('Login', style: TextStyle(color: Colors.white)),
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
                      ? 'assets/images/login1_dark.svg'
                      : 'assets/images/login1_light.svg',
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
                            StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return TextFormField(
                                  controller: passwordController,
                                  validator: FormValidator.validatePassword,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    labelStyle: const TextStyle(
                                      color: Colors
                                          .black, // Change this to your desired color
                                    ),
                                    hintText: '********',
                                    labelText: 'Password',
                                    prefixIcon: const Icon(Icons.lock,
                                        color: Colors.black),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.black),
                                      onPressed: () {
                                        // Update the state i.e. toggle the state of passwordVisible variable
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  obscureText: !passwordVisible,
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
                                if (_formKey.currentState!.validate()) {
                                  // Call loginUser from LoginApi
                                  LoginApi loginApi = LoginApi();
                                  Map<String, dynamic> result =
                                      await loginApi.loginUser(
                                    userEmail: emailController.text,
                                    userPassword: passwordController.text,
                                  );

                                  // Check the result
                                  if (result['status'] == 'success') {
                                    // If the login was successful, navigate to HomePage
                                    Get.offAll(() => const HomePage());
                                  } else {
                                    // If there was an error, show a message to the user
                                    if (!context.mounted) return;
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
                              child: const Text('  Login  ',
                                  style: TextStyle(fontSize: 20)),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Get.offAll(() => const ForgotPage()),
                              child: const Text('Forgot password?'),
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
