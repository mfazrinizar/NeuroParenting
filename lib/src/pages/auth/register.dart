import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neuroparenting/src/pages/auth/login.dart';
import 'package:neuroparenting/src/pages/auth/start.dart';
import 'package:neuroparenting/src/reusable_comp/language_changer.dart';
import 'package:neuroparenting/src/reusable_comp/theme_changer.dart';
import 'package:neuroparenting/src/reusable_func/form_validator.dart';
import 'package:neuroparenting/src/reusable_func/localization_change.dart';
import 'package:neuroparenting/src/reusable_func/theme_change.dart';
import 'package:neuroparenting/src/theme/theme.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:neuroparenting/src/reusable_func/file_picking.dart';

import '../../db/auth/register_api.dart';
import 'parent_selection.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
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
  final filePicking = FilePicking();

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
                            onTap: () async {
                              final action = await showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Choose an action'),
                                  content: const Text(
                                      'Pick an image from the gallery or take a new photo?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Gallery'),
                                      child: const Text('Gallery'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Camera'),
                                      child: const Text('Camera'),
                                    ),
                                  ],
                                ),
                              );

                              ImageSource source;
                              if (action == 'Gallery') {
                                source = ImageSource.gallery;
                              } else if (action == 'Camera') {
                                source = ImageSource.camera;
                              } else {
                                // The user cancelled the dialog
                                return;
                              }

                              final pickedImage =
                                  await filePicking.pickImage(source);
                              if (pickedImage != null) {
                                setState(() {
                                  profileImage = pickedImage;
                                });
                              }
                            },
                            // This method opens the file picker
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
                                      child: const Icon(Icons.camera_alt,
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
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: nameController,
                                  validator: FormValidator.validateName,
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
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return TextFormField(
                                      controller: passwordController,
                                      validator: FormValidator.validatePassword,
                                      style:
                                          const TextStyle(color: Colors.black),
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
                                              passwordVisible =
                                                  !passwordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                      obscureText: !passwordVisible,
                                    );
                                  },
                                ),
                                StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return TextFormField(
                                      controller: rePasswordController,
                                      validator: (value) =>
                                          FormValidator.validateRePassword(
                                              passwordController.text,
                                              rePasswordController.text),
                                      style:
                                          const TextStyle(color: Colors.black),
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
                                              rePasswordVisible =
                                                  !rePasswordVisible;
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
                                    if (_formKey.currentState!.validate()) {
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
                                        btnOkColor:
                                            ThemeClass().lightPrimaryColor,
                                        title: 'Is the data correct?',
                                        // padding: const EdgeInsets.all(5.0),
                                        desc:
                                            'Make sure you have selected the correct user type (psychologist or user).',
                                        btnCancelOnPress: () {},
                                        btnOkOnPress: () async {
                                          if (profileImage != null) {
                                            if (isSelected[1]) {
                                              Get.offAll(
                                                () => ParentSelectionPage(
                                                  profileImage: profileImage!,
                                                  nameOfUser:
                                                      nameController.text,
                                                  userEmail:
                                                      emailController.text,
                                                  userPassword:
                                                      passwordController.text,
                                                ),
                                              );
                                            } else {
                                              // EasyLoading.show(
                                              //     status: 'Checking email...');
                                              // QuerySnapshot query =
                                              //     await FirebaseFirestore.instance
                                              //         .collection('users')
                                              //         .where('email',
                                              //             isEqualTo:
                                              //                 emailController.text)
                                              //         .get();
                                              // EasyLoading.dismiss();

                                              // if (query.docs.isEmpty) {
                                              EasyLoading.show(
                                                  status: 'Registering...');
                                              String userCode =
                                                  await RegisterApi()
                                                      .registerUser(
                                                profilePictureImage:
                                                    profileImage!,
                                                userType: choices[isSelected
                                                        .indexWhere((item) =>
                                                            item == true)]
                                                    .trim(),
                                                nameOfUser: nameController.text,
                                                userEmail: emailController.text,
                                                userPassword:
                                                    passwordController.text,
                                              );

                                              EasyLoading.dismiss();

                                              if (!context.mounted) return;
                                              if (userCode ==
                                                  'SUCCESSFUL_SIR') {
                                                _showVerificationDialog(
                                                    context);
                                              } else if (userCode ==
                                                  'email-already-in-use') {
                                                _showErrorDialog(context,
                                                    'The email address is already registered.');
                                              } else if (userCode ==
                                                  'invalid-email') {
                                                _showErrorDialog(context,
                                                    'The email address is invalid. Kindly check again and retry.');
                                              } else if (userCode ==
                                                  'operation-not-allowed') {
                                                _showErrorDialog(context,
                                                    'Something went wrong in server-side. Please contact developer.');
                                              } else if (userCode ==
                                                  'weak-password') {
                                                _showErrorDialog(context,
                                                    'Your password is considered weak. Kindly check again and retry.');
                                              } else {
                                                _showErrorDialog(context,
                                                    'Something went wrong, please check your internet or contact developer.');
                                              }
                                              // } else {
                                              //   if (!context.mounted) return;
                                              //   _showErrorDialog(context,
                                              //       'This email is already registered.');
                                              // }
                                            }
                                          } else {
                                            _showErrorDialog(context,
                                                'Please upload/fill all the forms before clicking Register button.');
                                          }
                                        },
                                      ).show();
                                    }
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

void _showVerificationDialog(BuildContext context) {
  AwesomeDialog(
    dismissOnTouchOutside: false,
    context: context,
    keyboardAware: true,
    dismissOnBackKeyPress: false,
    dialogType: DialogType.info,
    animType: AnimType.scale,
    transitionAnimationDuration: const Duration(milliseconds: 200),
    btnOkText: "Login",
    title: 'Verify Your Email',
    desc:
        'Please check your email, then click the verification link to finish the registration process and be able to login your account.',
    btnOkOnPress: () {
      Get.offAll(() => const LoginPage());
    },
  ).show();
}

void _showErrorDialog(BuildContext context, String errorMessage) {
  AwesomeDialog(
    dismissOnTouchOutside: false,
    context: context,
    keyboardAware: true,
    dismissOnBackKeyPress: false,
    dialogType: DialogType.error,
    animType: AnimType.scale,
    transitionAnimationDuration: const Duration(milliseconds: 200),
    btnOkText: "Ok",
    title: 'Error Occured',
    desc: errorMessage,
    btnOkOnPress: () {
      DismissType.btnOk;
    },
  ).show();
}
