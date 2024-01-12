import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuroparenting/src/localization/app_localizations.dart';
import 'onboarding_base.dart';
import 'package:neuroparenting/src/reusable_func/localization_change.dart';
import 'package:neuroparenting/src/reusable_func/theme_change.dart';
import 'package:neuroparenting/src/pages/auth/start.dart';
import 'package:neuroparenting/src/reusable_comp/language_changer.dart';
import 'package:neuroparenting/src/reusable_comp/theme_changer.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;
  final PageController controller = PageController();

  // String? translate(BuildContext context, String key) {
  //   final localizations = AppLocalizations.of(context);
  //   if (localizations == null) {
  //     return null;
  //   }
  //   return localizations.translate(key);
  // }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> onboardingData = [
      {
        "title": AppLocalizations.of(context)!.translate('onboarding_title1') ??
            'problem',
        "description": AppLocalizations.of(context)!
                .translate('onboarding_description1') ??
            'problem',
        "imageLight": "assets/images/onboarding1_light.svg",
        "imageDark": "assets/images/onboarding1_dark.svg",
        "isSvg": "true",
      },
      {
        "title": AppLocalizations.of(context)!.translate('onboarding_title2') ??
            'problem',
        "description": AppLocalizations.of(context)!
                .translate('onboarding_description2') ??
            'problem',
        "imageLight": "assets/images/onboarding2_light.svg",
        "imageDark": "assets/images/onboarding2_dark.svg",
        "isSvg": "true",
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('NeuroParenting'),
        actions: const <Widget>[
          LanguageSwitcher(onPressed: localizationChange),
          ThemeSwitcher(onPressed: themeChange),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: PageView.builder(
                controller: controller,
                onPageChanged: (value) {
                  setState(
                    () {
                      currentPage = value;
                    },
                  );
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) => OnboardingContent(
                  title: onboardingData[index]["title"]!,
                  description: onboardingData[index]["description"]!,
                  imageLight: onboardingData[index]["imageLight"]!,
                  imageDark: onboardingData[index]["imageDark"]!,
                  isSvg:
                      onboardingData[index]["isSvg"] == "true" ? true : false,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  child: Text(
                    AppLocalizations.of(context)!
                            .translate('onboarding_button1') ??
                        'problem',
                  ),
                  onPressed: () {
                    Get.to(() => const StartPage());
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                    onboardingData.length,
                    (int index) {
                      return GestureDetector(
                        onTap: () {
                          controller.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Container(
                          width: 15.0,
                          height: 15.0,
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentPage == index
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.5),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  child: Text(AppLocalizations.of(context)!
                          .translate('onboarding_button2') ??
                      'problem'),
                  onPressed: () {
                    if (currentPage == onboardingData.length - 1) {
                      Get.offAll(() => const StartPage());
                    }
                    controller.nextPage(
                      // Index of the second page
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                ),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
