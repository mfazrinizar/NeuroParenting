import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:neuroparenting/src/pages/auth/login.dart';
import 'package:neuroparenting/src/reusable_comp/language_changer.dart';
import 'package:neuroparenting/src/reusable_comp/theme_changer.dart';
import 'package:neuroparenting/src/reusable_func/localization_change.dart';
import 'package:neuroparenting/src/reusable_func/theme_change.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ParentSelectionPage extends StatefulWidget {
  const ParentSelectionPage({super.key});

  @override
  ParentSelectionState createState() => ParentSelectionState();
}

class ParentSelectionState extends State<ParentSelectionPage> {
  bool isDarkMode = Get.isDarkMode,
      passwordVisible = false,
      rePasswordVisible = false;
  List<String> allTags = ['ADHD', 'Dyslexia', 'DCD', 'Others'];
  List<String> selectedTags = [];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          const LanguageSwitcher(onPressed: localizationChange),
          ThemeSwitcher(onPressed: () {
            setState(() {
              themeChange();
              isDarkMode = !isDarkMode;
            });
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
            height: height,
            child: Column(children: [
              SvgPicture.asset(
                isDarkMode
                    ? 'assets/images/parent1_dark.svg'
                    : 'assets/images/parent1_light.svg',
                width: width,
                fit: BoxFit.fill,
              ),
              SizedBox(height: height * 0.04),
              const Text('Please select your child\'s special need(s):',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: height * 0.02),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlue, width: 3),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: selectedTags.isEmpty
                    ? const Center(child: Text('Please select a need...'))
                    : Wrap(
                        spacing: 8.0, // gap between adjacent chips
                        runSpacing: 4.0, // gap between lines
                        children: selectedTags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      allTags.add(tag);
                                      selectedTags.remove(tag);
                                    });
                                  },
                                  child: const Icon(Icons.close,
                                      size: 18, color: Colors.white),
                                ),
                                const SizedBox(width: 4.0),
                                Text(tag,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.topCenter,
                  color: Colors.transparent,
                  child: Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: allTags.map((tag) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedTags.add(tag);
                            allTags.remove(tag);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.add,
                                  size: 18, color: Colors.white),
                              const SizedBox(width: 4.0),
                              Text(tag,
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shadowColor: Colors.grey, elevation: 5),
                onPressed: () {
                  AwesomeDialog(
                    dismissOnTouchOutside: false,
                    context: context,
                    keyboardAware: true,
                    dismissOnBackKeyPress: false,
                    dialogType: DialogType.info,
                    animType: AnimType.scale,
                    transitionAnimationDuration: const Duration(
                        milliseconds: 200), // Duration(milliseconds: 300),
                    btnOkText: "Login",
                    title: 'Verify Your Email',
                    desc:
                        'Please check your email, then click the verification link to finish the registration process and be able to login your account.',
                    btnOkOnPress: () {
                      Get.offAll(() => const LoginPage());
                    },
                  ).show();
                },
                child: const Text('  Finish  ', style: TextStyle(fontSize: 20)),
              ),
              const Spacer(),
            ])),
      ),
    );
  }
}
