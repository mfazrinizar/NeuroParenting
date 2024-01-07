import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:neuroparenting/src/pages/onboarding/onboarding_screen.dart';
import 'package:neuroparenting/src/reusable_comp/language_changer.dart';
import 'package:neuroparenting/src/reusable_comp/theme_changer.dart';
import 'package:neuroparenting/src/reusable_func/localization_change.dart';
import 'package:neuroparenting/src/reusable_func/theme_change.dart';
import 'package:neuroparenting/src/theme/theme.dart';
import 'login.dart';
import 'register.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  StartPageState createState() => StartPageState();
}

class StartPageState extends State<StartPage> {
  final isDarkMode = RxBool(Get.isDarkMode);
  @override
  void initState() {
    isDarkMode.value = Get.isDarkMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          // Replace with your primary color
          backgroundColor: isDarkMode.value
              ? ThemeClass.darkTheme.colorScheme.background
              : ThemeClass().lightPrimaryColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('NeuroParenting',
                style: TextStyle(color: Colors.white)),
            leading: BackButton(
                color: Colors.white,
                onPressed: () => Get.offAll(() =>
                    const OnboardingScreen())), // Empty container to remove back button
            actions: [
              Container(
                decoration: BoxDecoration(
                  color: isDarkMode.value
                      ? Colors.transparent
                      : Colors
                          .white, // Change this to your desired background color
                  borderRadius: const BorderRadius.only(
                    bottomLeft:
                        Radius.circular(25), // Adjust the radius as needed
                  ),
                ),
                child: const LanguageSwitcher(onPressed: localizationChange),
              ),
              Container(
                decoration: BoxDecoration(
                  color: isDarkMode.value
                      ? Colors.transparent
                      : Colors
                          .white, // Change this to your desired background color
                ),
                child: ThemeSwitcher(onPressed: () {
                  setState(() {
                    themeChange();
                    isDarkMode.value = !isDarkMode.value;
                  });
                }),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context)
                          .size
                          .width, // make it cover the full width
                      height: MediaQuery.of(context).size.height * 0.60,
                      decoration: ShapeDecoration(
                        color: isDarkMode.value
                            ? ThemeClass().darkRounded
                            : Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(80)),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        SvgPicture.asset(
                          isDarkMode.value
                              ? 'assets/images/start1_dark.svg'
                              : 'assets/images/start1_light.svg',
                          height: MediaQuery.of(context).size.height * 0.45,
                          fit: BoxFit.fill,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shadowColor: Colors.grey, elevation: 5),
                          onPressed: () async =>
                              Get.offAll(() => const LoginPage()),
                          child: const Text('  Login  ',
                              style: TextStyle(fontSize: 20)),
                        ),
                        const SizedBox(height: 5),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shadowColor: Colors.grey,
                              elevation: 5,
                              backgroundColor: isDarkMode.value
                                  ? Colors.grey
                                  : Colors.white),
                          onPressed: () async =>
                              Get.offAll(() => const RegisterPage()),
                          child: Text('Register',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: isDarkMode.value
                                      ? Colors.white
                                      : ThemeClass().lightPrimaryColor)),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
