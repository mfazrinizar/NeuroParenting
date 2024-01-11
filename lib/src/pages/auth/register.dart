import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:neuroparenting/src/pages/auth/login.dart';
import 'package:neuroparenting/src/pages/auth/start.dart';
import 'package:neuroparenting/src/reusable_comp/language_changer.dart';
import 'package:neuroparenting/src/reusable_comp/theme_changer.dart';
import 'package:neuroparenting/src/reusable_func/localization_change.dart';
import 'package:neuroparenting/src/reusable_func/theme_change.dart';
import 'package:neuroparenting/src/theme/theme.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'parent_selection.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<RegisterPage> {
  File? profileImage;
  int currentPage = 0;
  final PageController controller = PageController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  bool isDarkMode = Get.isDarkMode,
      passwordVisible = false,
      rePasswordVisible = false;
  final List<String> choices = ['  Psychologist  ', '  Parent  '];
  final List<bool> isSelected = [true, false];

  Future<void> selectProfileImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      profileImage = File(result.files.single.path!);
      setState(() {});
    } else {
      // User canceled the picker
    }
  }

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
            onPressed: () => Get.offAll(() => const StartPage())),
        title: const Text('Register', style: TextStyle(color: Colors.white)),
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
                      ? 'assets/images/register1_dark.svg'
                      : 'assets/images/register1_light.svg',
                  width: width,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: height * 0.20,
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
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.01,
                          ),
                          GestureDetector(
                            onTap:
                                selectProfileImage, // This method opens the file picker
                            child: ClipOval(
                              child: profileImage != null
                                  ? Image.file(
                                      profileImage!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: Colors.grey,
                                      width: 100,
                                      height: 100,
                                      child: Icon(Icons.camera_alt,
                                          color: Colors.white),
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          // const Text('Select User Type:',
                          //     style: TextStyle(
                          //         fontSize: 20,
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.black)),
                          ToggleButtons(
                            isSelected: isSelected,
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < isSelected.length; i++) {
                                  isSelected[i] = i == index;
                                }
                              });
                            },
                            color: Colors.black, // Text color when not selected
                            selectedColor:
                                Colors.white, // Text color when selected
                            fillColor: isDarkMode
                                ? ThemeClass().darkPrimaryColor
                                : ThemeClass()
                                    .lightPrimaryColor, // Background color when selected
                            borderWidth: 2, // Border width
                            borderColor: isDarkMode
                                ? Colors.white
                                : Colors
                                    .black, // Border color when not selected
                            selectedBorderColor: isDarkMode
                                ? ThemeClass().darkPrimaryColor
                                : ThemeClass()
                                    .lightPrimaryColor, // Border color when selected
                            borderRadius:
                                BorderRadius.circular(20), // Border radius
                            highlightColor: Colors.blue.withOpacity(0.3),
                            children: choices.map((choice) {
                              int index =
                                  choices.indexWhere((item) => item == choice);
                              return Text(choice,
                                  style: TextStyle(
                                      fontWeight: isSelected[index]
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 20));
                            }).toList(), // Highlight color when pressed
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors
                                    .black, // Change this to your desired color
                              ),
                              hintText: 'Raihan Wangsaff',
                              labelText: 'Name',
                              prefixIcon:
                                  Icon(Icons.people, color: Colors.black),
                            ),
                          ),
                          TextFormField(
                            controller: emailController,
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
                          StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return TextFormField(
                                controller: rePasswordController,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  labelStyle: const TextStyle(
                                    color: Colors
                                        .black, // Change this to your desired color
                                  ),
                                  hintText: '********',
                                  labelText: 'Re-enter Password',
                                  prefixIcon: const Icon(Icons.password,
                                      color: Colors.black),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                        // Based on passwordVisible state choose the icon
                                        rePasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.black),
                                    onPressed: () {
                                      // Update the state i.e. toggle the state of passwordVisible variable
                                      setState(() {
                                        rePasswordVisible = !rePasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                obscureText: !rePasswordVisible,
                              );
                            },
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.grey,
                              elevation: 5,
                            ),
                            onPressed: () {
                              AwesomeDialog(
                                context: context,
                                keyboardAware: true,
                                dismissOnBackKeyPress: false,
                                dialogType: DialogType.question,
                                animType: AnimType.scale,
                                transitionAnimationDuration: const Duration(
                                    milliseconds:
                                        200), // Duration(milliseconds: 300),
                                btnCancelText: "Cancel",
                                btnOkText: "Confirm",
                                btnOkColor: ThemeClass().lightPrimaryColor,
                                title: 'Is the data correct?',
                                // padding: const EdgeInsets.all(5.0),
                                desc:
                                    'Make sure you have selected the correct user type (psychologist or user).',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {
                                  isSelected[1]
                                      ? Get.offAll(
                                          () => const ParentSelectionPage())
                                      : AwesomeDialog(
                                          dismissOnTouchOutside: false,
                                          context: context,
                                          keyboardAware: true,
                                          dismissOnBackKeyPress: false,
                                          dialogType: DialogType.info,
                                          animType: AnimType.scale,
                                          transitionAnimationDuration:
                                              const Duration(
                                                  milliseconds:
                                                      200), // Duration(milliseconds: 300),
                                          btnOkText: "Login",
                                          title: 'Verify Your Email',
                                          desc:
                                              'Please check your email, then click the verification link to finish the registration process and be able to login your account.',
                                          btnOkOnPress: () {
                                            Get.offAll(() => const LoginPage());
                                          },
                                        ).show();
                                },
                              ).show();
                            },
                            child: const Text('  Register  ',
                                style: TextStyle(fontSize: 20)),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                        ],
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
