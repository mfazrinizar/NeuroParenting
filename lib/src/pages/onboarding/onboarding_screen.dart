import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:neuroparenting/src/localization/app_localizations.dart';
import 'onboarding_base.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> onboardingData = [
      {
        "title": AppLocalizations.of(context)!.translate('onboarding_title1')!,
        "description":
            AppLocalizations.of(context)!.translate('onboarding_description1')!,
        "imageLight": "assets/images/onboarding1_light.svg",
        "imageDark": "assets/images/onboarding1_dark.svg",
        "isSvg": "true",
      },
      {
        "title": AppLocalizations.of(context)!.translate('onboarding_title2')!,
        "description":
            AppLocalizations.of(context)!.translate('onboarding_description2')!,
        "imageLight": "assets/images/onboarding2_light.svg",
        "imageDark": "assets/images/onboarding2_dark.svg",
        "isSvg": "true",
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('NeuroParenting'),
        actions: <Widget>[
          IconButton(
            icon: Get.locale == const Locale('en', '')
                ? SvgPicture.asset(
                    'assets/icons/english_lang.svg',
                    width: 35,
                    fit: BoxFit.fill,
                  ) // English flag SVG
                : SvgPicture.asset(
                    'assets/icons/indonesian_lang.svg',
                    width: 35,
                    fit: BoxFit.fill,
                  ), // Indonesian flag SVG
            onPressed: () {
              // switch language logic here
              if (Get.locale == const Locale('en', '')) {
                Get.updateLocale(const Locale('id', ''));
              } else {
                Get.updateLocale(const Locale('en', ''));
              }
            },
          ),
          Text(
            Get.locale == const Locale('en', '') ? 'EN' : 'ID',
            // Change this to your desired color
          ),
          IconButton(
            icon: const Icon(Icons.brightness_4),
            onPressed: () {
              if (Get.isDarkMode) {
                Get.changeTheme(ThemeData.light());
              } else {
                Get.changeTheme(ThemeData.dark());
              }
            },
          ),
        ],
      ),
      body: SafeArea(
          child: Column(children: [
        Expanded(
            child: PageView.builder(
          controller: controller,
          onPageChanged: (value) {
            setState(() {
              currentPage = value;
            });
          },
          itemCount: onboardingData.length,
          itemBuilder: (context, index) => OnboardingContent(
            title: onboardingData[index]["title"]!,
            description: onboardingData[index]["description"]!,
            imageLight: onboardingData[index]["imageLight"]!,
            imageDark: onboardingData[index]["imageDark"]!,
            isSvg: onboardingData[index]["isSvg"] == "true" ? true : false,
          ),
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
              child: const Text('Skip'),
              onPressed: () {
                // Skip button logic here...
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
              child: const Text('Next'),
              onPressed: () {
                // Next button logic here...
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
        const SizedBox(
          height: 20,
        )
      ])),
    );
  }
}
