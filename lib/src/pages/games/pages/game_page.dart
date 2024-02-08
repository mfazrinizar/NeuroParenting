import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuroparenting/src/homepage.dart';
import 'package:neuroparenting/src/pages/games/animal_test/animal_test.dart';
import 'package:neuroparenting/src/pages/games/auth.dart';
import 'package:neuroparenting/src/pages/games/pages/nst.dart';
import 'package:neuroparenting/src/pages/games/phonetic%20list/phonetic_list.dart';
import 'package:neuroparenting/src/pages/games/size_config.dart';
import 'package:neuroparenting/src/reusable_comp/language_changer.dart';
import 'package:neuroparenting/src/reusable_comp/theme_changer.dart';
import 'package:neuroparenting/src/reusable_func/localization_change.dart';
import 'package:neuroparenting/src/reusable_func/theme_change.dart';
import 'package:neuroparenting/src/theme/theme.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  @override
  GamePageState createState() => GamePageState();
}

final User? user = Auth().currentUser;

class GamePageState extends State<GamePage> {
  bool isDarkMode = Get.isDarkMode;
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? ThemeClass().darkRounded
            : ThemeClass().lightPrimaryColor,
        title: const Text(
          'Games',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: const Color.fromARGB(255, 255, 255, 255),
            onPressed: () {
              Get.offAll(const HomePage(
                indexFromPrevious: 0,
              ));
            }),
        actions: [
          LanguageSwitcher(
            onPressed: localizationChange,
            textColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        scrollPadding: const EdgeInsets.all(100),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                          prefixIcon: const Icon(
                            Icons.search,
                          ),
                          hintText: 'Search for Games...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.lightBlue,
                                width: 2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const NST()));
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: getRelativeWidth(0.90),
                    height: getRelativeHeight(0.20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.green),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getRelativeWidth(0.03)),
                      // child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  // "Permainan Pra Membaca cocok gambar NST untuk Disleksia",
                                  "Matching Games for Dyslexia",
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: getRelativeHeight(0.02)),
                              ],
                            ),
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'assets/images/autism1.png',
                                height: 300,
                                width: 100,
                              )
                            ],
                          ),
                          // SizedBox(width: getRelativeWidth(0.012)),
                        ],
                      ),
                      // ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PhonetikList()));
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: getRelativeWidth(0.90),
                    height: getRelativeHeight(0.20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(255, 12, 91, 156)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getRelativeWidth(0.03)),
                      // child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  // "Terapi Bermain untuk penyandang Dislexia",
                                  "Therapy Games for Dyslexia",
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: getRelativeHeight(0.02)),
                              ],
                            ),
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'assets/images/dyslexia1.png',
                                height: 300,
                                width: 100,
                              )
                            ],
                          ),
                          SizedBox(width: getRelativeWidth(0.012)),
                        ],
                      ),
                      // ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AnimalTest()));
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: getRelativeWidth(0.90),
                    height: getRelativeHeight(0.20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(255, 174, 18, 93)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getRelativeWidth(0.03)),
                      // child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  // "Terapi Audio dan Visual untuk penyandang Autisme",
                                  "Audio and Visual Therapy for Dyslexia",
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: getRelativeHeight(0.02)),
                              ],
                            ),
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'assets/images/animal_test.png',
                                height: 300,
                                width: 100,
                              )
                            ],
                          ),
                          SizedBox(width: getRelativeWidth(0.012)),
                        ],
                      ),
                    ),
                    // ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
