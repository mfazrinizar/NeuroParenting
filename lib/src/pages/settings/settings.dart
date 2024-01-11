// settings.dart

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuroparenting/src/theme/theme.dart';

import '../onboarding/onboarding_screen.dart';

class SettingsPage extends StatefulWidget {
  final double height;
  final double width;
  final bool isDarkMode;
  final List<String> buttonTitles;
  final List<IconData> buttonIcons;
  final List<String> imgList;
  final List<String> urlList;
  final CarouselController controller;
  final Function launchUrl;
  final int current;

  const SettingsPage({
    super.key,
    required this.height,
    required this.width,
    required this.isDarkMode,
    required this.buttonTitles,
    required this.buttonIcons,
    required this.imgList,
    required this.urlList,
    required this.controller,
    required this.launchUrl,
    required this.current,
  });

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  int current = 0;
  bool isDarkMode = Get.isDarkMode;
  String userType = 'Parent'; // Psychologist
  final tilesData = [
    {
      'icon': Icons.person,
      'title': 'Change Name',
      'onTap': () {/* Handle change name */}
    },
    {
      'icon': Icons.lock,
      'title': 'Change Password',
      'onTap': () {/* Handle change password */}
    },
    {
      'icon': Icons.exit_to_app,
      'title': 'Exit App',
      'onTap': () {/* Handle exit app */}
    },
    {
      'icon': Icons.logout,
      'title': 'Logout',
      'onTap': () {
        Get.offAll(() => const OnboardingScreen());
      }
    },
  ];

  @override
  void initState() {
    super.initState();
    current = widget.current;
    isDarkMode = Get.isDarkMode;
  }

  @override
  Widget build(context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: widget.height * 0.01, width: widget.width * 0.01),
            // 1. User avatar
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: widget.height * 0.125,
              backgroundImage: const AssetImage('assets/icons/logo.png'),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: widget.height * 0.1,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? ThemeClass().darkRounded
                        : ThemeClass().lightPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera_alt,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                      size: widget.height * 0.05,
                    ),
                  ),
                ),
              ), // Replace with your image path
            ),
            // 2. Neurodivergent tags
            const Text('Dr. Raihan Wangsaff',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            (userType == 'Parent')
                ? // Replace userType with your actual user type variable
                Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: <String>['ADHD', 'DCD', 'Dyslexia', 'Others']
                        .map((String tag) => Chip(label: Text(tag)))
                        .toList(),
                  )
                : const Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: [Chip(label: Text('Psychologist'))],
                  ),
            if (userType == 'Parent')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.edit,
                        size: 24,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black),
                    label: Text(
                      'Edit Needs',
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16),
                    ),
                  )
                ],
              ),

            // 3. List tile button
            Column(
              children: tilesData.map(
                (tile) {
                  return _buildListTile(
                      tile['icon'] as IconData,
                      tile['title'] as String,
                      tile['onTap'] as void Function(),
                      context);
                },
              ).toList(),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildListTile(
    IconData icon, String title, VoidCallback onTap, BuildContext context) {
  bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
  return Padding(
    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
    child: Card(
      color: isDarkMode
          ? ThemeClass().darkRounded
          : ThemeClass().lightPrimaryColor,
      elevation: 5.0, // Adjust as needed
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(16)), // Adjust color and width as needed
      child: ListTile(
        leading: Icon(icon, color: isDarkMode ? Colors.black : Colors.white),
        title: Text(title,
            style: TextStyle(
                color: SettingsPageState().isDarkMode
                    ? Colors.black
                    : Colors.white)),
        onTap: onTap,
      ),
    ),
  );
}
