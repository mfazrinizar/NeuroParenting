import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:neuroparenting/src/reusable_comp/language_changer.dart';
import 'package:neuroparenting/src/reusable_func/localization_change.dart';
import 'package:neuroparenting/src/reusable_func/theme_change.dart';
import 'package:neuroparenting/src/theme/theme.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'homebody.dart';
import 'package:neuroparenting/src/pages/forum/forum.dart';
import 'package:neuroparenting/src/pages/settings/settings.dart';

import 'reusable_comp/theme_changer.dart';

class HomePage extends StatefulWidget {
  final int? indexFromPrevious;

  const HomePage({super.key, this.indexFromPrevious});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool isDarkMode = Get.isDarkMode;
  final int _current = 0;
  int _currentTabIndex = 0;
  final CarouselController _controller = CarouselController();
  String? userType;

  @override
  void initState() {
    super.initState();
    isDarkMode = Get.isDarkMode;
    _currentTabIndex = widget.indexFromPrevious ?? 0;
    fetchUserType();
  }

  void fetchUserType() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          userType = docSnapshot.data()?['userType'];
        });
      }
    }
  }

  final buttonTitles = [
    'Donate',
    'Consult',
    'Games',
    'Course',
    'ChatBot',
    'Articles',
    'Campaign',
    'More'
  ];

  final buttonIcons = [
    Icons.favorite,
    Icons.help,
    Icons.games,
    Icons.book,
    Icons.chat_rounded,
    Icons.article,
    Icons.campaign,
    Icons.more
  ];

  final List<String> imgList = [
    'https://potomacpediatrics.com/wp-content/uploads/2022/04/bigstock-Wolrd-Autism-Awareness-Day-A-450281063-670x446.jpg', // Replace with your image urls
    'https://potomacpediatrics.com/wp-content/uploads/2022/04/bigstock-Wolrd-Autism-Awareness-Day-A-450281063-670x446.jpg',
    'https://potomacpediatrics.com/wp-content/uploads/2022/04/bigstock-Wolrd-Autism-Awareness-Day-A-450281063-670x446.jpg',
  ];

  final List<String> urlList = [
    'https://google.com', // Replace with your urls
    'https://google.com',
    'https://google.com',
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final List<Widget> children = [
      HomePageBody(
        height: height,
        width: width,
        isDarkMode: isDarkMode,
        buttonTitles: buttonTitles,
        buttonIcons: buttonIcons,
        imgList: imgList,
        urlList: urlList,
        controller: _controller,
        launchUrl: launchUrl,
        current: _current,
      ),
      ForumPage(
        height: height,
        width: width,
        isDarkMode: isDarkMode,
        buttonTitles: buttonTitles,
        buttonIcons: buttonIcons,
        imgList: imgList,
        urlList: urlList,
        controller: _controller,
        launchUrl: launchUrl,
        current: _current,
      ),
      SettingsPage(
        height: height,
        width: width,
        isDarkMode: isDarkMode,
        buttonTitles: buttonTitles,
        buttonIcons: buttonIcons,
        imgList: imgList,
        urlList: urlList,
        controller: _controller,
        launchUrl: launchUrl,
        current: _current,
      )
    ];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkMode
              ? ThemeClass().darkRounded
              : ThemeClass().lightPrimaryColor,
          elevation: 0,
          title: Text(
              _currentTabIndex == 0
                  ? 'Home'
                  : _currentTabIndex == 1
                      ? 'Forum'
                      : 'Settings',
              style:
                  TextStyle(color: isDarkMode ? Colors.black : Colors.white)),
          leading: IconButton(
              icon: isDarkMode
                  ? SvgPicture.asset('assets/icons/logo_black.svg')
                  : Image.asset('assets/icons/logo.png'),
              onPressed: () {
                // Get.offAll(() => const OnboardingScreen());
              }),
          actions: [
            LanguageSwitcher(
              onPressed: localizationChange,
              textColor: isDarkMode ? Colors.black : Colors.white,
            ),
            ThemeSwitcher(onPressed: () async {
              themeChange();

              setState(() {
                isDarkMode = !isDarkMode;
              });
            }),
            PopupMenuButton<String>(
              icon: Icon(Icons.notifications,
                  color: isDarkMode ? Colors.black : Colors.white),
              onSelected: (String result) {
                // Handle the selection
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Notification 1',
                  child: Text('No notifications'),
                ),
                // Add more PopupMenuItems for more notifications
              ],
            ),
            Builder(
              builder: (BuildContext context) {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null && user.photoURL != null) {
                  return ClipOval(
                    child: FadeInImage.assetNetwork(
                      image: user.photoURL!,
                      placeholder: 'assets/images/placeholder_loading.gif',
                      fit: BoxFit.cover,
                      width: 45,
                      height: 45,
                    ),
                  ); // display the user's profile picture
                } else {
                  return Icon(Icons.account_circle,
                      color: isDarkMode
                          ? Colors.black
                          : Colors
                              .white); // show a default icon if the user is not logged in or doesn't have a profile picture
                }
              },
            ),
          ],
        ),
        bottomNavigationBar: ConvexAppBar(
          color: isDarkMode ? Colors.black : Colors.white,
          backgroundColor: isDarkMode
              ? ThemeClass().darkRounded
              : ThemeClass().lightPrimaryColor,
          style: TabStyle.reactCircle,
          items: const [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.forum, title: 'Forum'),
            TabItem(icon: Icons.settings, title: 'Settings'),
          ],
          initialActiveIndex: _currentTabIndex, //Choose initial selection here
          onTap: onTabTapped,
        ),
        body: children[_currentTabIndex]);
  }
}
