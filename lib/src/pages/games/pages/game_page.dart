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
  bool isClicked = false;
  final searchController = TextEditingController();

  final List<Map<String, dynamic>> gamePages = [
    {
      "name": "Matching Games",
      "tag": "Dyslexia",
      "image": 'assets/images/autism1.png',
      "page": const NST(),
      "bgColor": const Color.fromARGB(255, 206, 236, 254),
      "textColor": const Color.fromARGB(255, 61, 92, 255),
    },
    {
      "name": "Phonetic Games",
      "tag": "Dyslexia",
      "image": 'assets/images/dyslexia1.png',
      "page": const PhonetikList(),
      "bgColor": const Color.fromARGB(255, 206, 236, 254),
      "textColor": const Color.fromARGB(255, 61, 92, 255),
    },
    {
      "name": "Audio and Visual Therapy",
      "tag": "Dyslexia",
      "image": 'assets/images/animal_test.png',
      "page": const AnimalTest(),
      "bgColor": const Color.fromARGB(255, 206, 236, 254),
      "textColor": const Color.fromARGB(255, 61, 92, 255),
    },
    // {
    //   "name": "Matching Games2",
    //   "tag": "DCD",
    //   "image": 'assets/images/autism1.png',
    //   "page": const NST(),
    //   "bgColor": const Color.fromARGB(255, 254, 239, 220),
    //   "textColor": const Color.fromARGB(255, 251, 177, 90),
    // },
    // {
    //   "name": "Phonetic Games2",
    //   "tag": "Autism",
    //   "image": 'assets/images/dyslexia1.png',
    //   "page": const PhonetikList(),
    //   "bgColor": const Color.fromARGB(255, 218, 238, 231),
    //   "textColor": const Color.fromARGB(255, 95, 228, 180),
    // },
    // {
    //   "name": "Audio and Visual Therapy2",
    //   "tag": "ADHD",
    //   "image": 'assets/images/animal_test.png',
    //   "page": const AnimalTest(),
    //   "bgColor": const Color.fromARGB(255, 255, 228, 241),
    //   "textColor": const Color.fromARGB(255, 255, 128, 189),
    // },
    // {
    //   "name": "Matching Games3",
    //   "tag": "ASD",
    //   "image": 'assets/images/autism1.png',
    //   "page": const NST(),
    //   "bgColor": const Color.fromARGB(255, 239, 224, 255),
    //   "textColor": const Color.fromARGB(255, 144, 101, 190),
    // },
    // {
    //   "name": "Phonetic Games3",
    //   "tag": "ASD",
    //   "image": 'assets/images/dyslexia1.png',
    //   "page": const PhonetikList(),
    //   "bgColor": const Color.fromARGB(255, 239, 224, 255),
    //   "textColor": const Color.fromARGB(255, 144, 101, 190),
    // },
    // {
    //   "name": "Audio and Visual Therapy3",
    //   "tag": "ADHD",
    //   "image": 'assets/images/animal_test.png',
    //   "page": const AnimalTest(),
    //   "bgColor": const Color.fromARGB(255, 255, 228, 241),
    //   "textColor": const Color.fromARGB(255, 255, 128, 189),
    // },
  ];

  final List<Map<String, dynamic>> tagFilters = [
    {
      "tag": "Dyslexia   ",
      "bgColor": const Color.fromARGB(255, 206, 236, 254),
      "bgText": const Color.fromARGB(255, 241, 249, 253),
      "textColor": const Color.fromARGB(255, 61, 92, 255),
      "image": ""
    },
    {
      "tag": "ASD   ",
      "bgColor": const Color.fromARGB(255, 239, 224, 255),
      "bgText": const Color.fromARGB(255, 255, 243, 255),
      "textColor": const Color.fromARGB(255, 144, 101, 190),
      "image": ""
    },
    {
      "tag": "DCD   ",
      "bgColor": const Color.fromARGB(255, 254, 239, 220),
      "bgText": const Color.fromARGB(255, 255, 255, 236),
      "textColor": const Color.fromARGB(255, 251, 177, 90),
      "image": ""
    },
    {
      "tag": "ADHD   ",
      "bgColor": const Color.fromARGB(255, 255, 228, 241),
      "bgText": const Color.fromARGB(255, 254, 242, 255),
      "textColor": const Color.fromARGB(255, 255, 128, 189),
      "image": ""
    },
    {
      "tag": "Autism   ",
      "bgColor": const Color.fromARGB(255, 218, 238, 231),
      "bgText": const Color.fromARGB(255, 240, 255, 253),
      "textColor": const Color.fromARGB(255, 37, 223, 155),
      "image": ""
    },
  ];

  List<Map<String, dynamic>> foundGames = [];

  @override
  void initState() {
    foundGames = gamePages;
    super.initState();
  }

  void filterGame(String input) {
    List<Map<String, dynamic>> resultGames = [];
    // for (var gamePage in gamePages) {
    //   bool shouldInclude = gamePage["name"].toString().toLowerCase().contains(
    //             searchController.text.toLowerCase(),
    //           ) ||
    //       gamePage["tag"].toString().toLowerCase().contains(
    //             searchController.text.toLowerCase(),
    //           );

    //   if (shouldInclude) {
    //     resultGames.add(gamePage);
    //   }

    //   setState(() {
    //     foundGames = resultGames;
    //   });
    // }

    if (input.contains("   ")) {
      isClicked = true;
    } else {
      isClicked = false;
    }

    if (input.isEmpty) {
      resultGames = gamePages;
    } else {
      resultGames = gamePages
          .where((game) =>
              game["name"]
                  .toString()
                  .toLowerCase()
                  .contains(input.toLowerCase().trim()) ||
              game["tag"]
                  .toString()
                  .toLowerCase()
                  .contains(input.toLowerCase().trim()))
          .toList();
    }

    setState(() {
      foundGames = resultGames;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? ThemeClass().darkRounded
            : ThemeClass().lightPrimaryColor,
        title: Text(
          'Games',
          style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color.fromARGB(255, 211, 227, 253)
                  : Colors.white),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromARGB(255, 211, 227, 253)
                : Colors.white,
            onPressed: () {
              Get.offAll(const HomePage(
                indexFromPrevious: 0,
              ));
            }),
        actions: [
          LanguageSwitcher(
            onPressed: localizationChange,
            textColor: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromARGB(255, 211, 227, 253)
                : Colors.white,
          ),
          ThemeSwitcher(onPressed: () async {
            themeChange();
            setState(() {
              isDarkMode = !isDarkMode;
            });
          }),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.notifications,
              color: isDarkMode
                  ? const Color.fromARGB(255, 211, 227, 253)
                  : Colors.white,
            ),
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
                return Icon(
                  Icons.account_circle,
                  color: isDarkMode
                      ? const Color.fromARGB(255, 211, 227, 253)
                      : Colors.white,
                ); // show a default icon if the user is not logged in or doesn't have a profile picture
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? ThemeClass().darkRounded
                      : ThemeClass().lightPrimaryColor),
              child: Stack(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            color: isDarkMode
                                ? const Color.fromARGB(255, 211, 227, 253)
                                : Colors.black,
                          ),
                          controller: searchController,
                          onChanged: (value) => filterGame(value),
                          keyboardType: TextInputType.visiblePassword,
                          scrollPadding: const EdgeInsets.all(100),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color.fromARGB(255, 3, 21, 37)
                                    : const Color.fromARGB(255, 240, 240, 245),
                            prefixIcon: Icon(
                              Icons.search,
                              color: isDarkMode
                                  ? const Color.fromARGB(255, 211, 227, 253)
                                  : Colors.black,
                            ),
                            hintText: 'Search for Games...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? const Color.fromARGB(255, 211, 227, 253)
                                    : Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: isDarkMode
                                      ? const Color.fromARGB(255, 211, 227, 253)
                                      : Colors.blueAccent,
                                  width: 2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //line under is not scroll bar so ignore this?
            // RawScrollbar(
            //   // crossAxisMargin: 100,
            //   padding: const EdgeInsets.only(left: 20, right: 20),
            //   interactive: true,
            //   thumbColor: const Color.fromARGB(255, 39, 9, 223),
            //   thumbVisibility: true,
            //   // trackColor: const Color.fromARGB(255, 211, 227, 253),
            //   // trackVisibility: true,
            //   // isAlwaysShown: true, //always show scrollbar
            //   thickness: 7, //width of scrollbar
            //   radius: const Radius.circular(10), //corner radius of scrollbar
            //   scrollbarOrientation:
            //       ScrollbarOrientation.bottom, //which side to show scrollbar
            //   child:
            // ),

            // Expanded(
            //   child:
            SingleChildScrollView(
              scrollDirection: axisDirectionToAxis(AxisDirection.right),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(1),
                    height: 100,
                    width: 390,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: tagFilters.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () => !isClicked
                                  ? filterGame(
                                      tagFilters[index]["tag"].toString())
                                  : filterGame(""),
                              child: Container(
                                alignment: Alignment.bottomRight,
                                constraints: const BoxConstraints(
                                    minWidth: 180,
                                    maxWidth: 180,
                                    minHeight: 100,
                                    maxHeight: 100),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  color: tagFilters[index]["bgColor"],
                                ),
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        color: tagFilters[index]["bgText"],
                                      ),
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        tagFilters[index]["tag"],
                                        style: TextStyle(
                                          color: tagFilters[index]["textColor"],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 45,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            // ),
            const SizedBox(
              height: 7,
            ),

            Container(
              padding: const EdgeInsets.all(1),
              height: 500,
              width: 400,
              // Expanded(
              child: ListView.builder(
                // scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: foundGames.length,
                // itemCount: 5,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          // builder: (context) =>const NST()));
                          builder: (context) => foundGames[index]["page"]));
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(7),
                          width: getRelativeWidth(0.90),
                          height: getRelativeHeight(0.20),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: !isDarkMode
                                    ? Colors.grey.withOpacity(0.3)
                                    : Colors.blueGrey.withOpacity(0.15),
                                spreadRadius: 1.5,
                                blurRadius: 4,
                                offset: Offset.fromDirection(
                                    1, 5), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15),
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? ThemeClass().darkRounded
                                    : const Color.fromARGB(255, 240, 240, 245),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: getRelativeWidth(0.03)),
                            // child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        foundGames[index]["name"],
                                        // "Matching Games",
                                        style: GoogleFonts.nunito(
                                          color: isDarkMode
                                              ? const Color.fromARGB(
                                                  255, 211, 227, 253)
                                              : const Color.fromARGB(
                                                  255, 124, 124, 124),
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
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Chip(
                                              backgroundColor: foundGames[index]
                                                  ["bgColor"],
                                              label: Text(
                                                foundGames[index]["tag"],
                                                // "Dyslexia",
                                                style: GoogleFonts.nunito(
                                                  color: foundGames[index]
                                                      ["textColor"],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              side: BorderSide(
                                                  color: foundGames[index]
                                                      ["bgColor"]),
                                            ),
                                          ),
                                          Image.asset(
                                            foundGames[index]["image"],
                                            // 'assets/images/autism1.png',
                                            height: 98,
                                            width: 98,
                                          )
                                        ],
                                      ),
                                    ),
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
                  );
                },
              ),
            )

            //doesnt scroll
            // SingleChildScrollView(
            //   child: ListView.builder(
            //     // scrollDirection: Axis.vertical,
            //     // physics: const AlwaysScrollableScrollPhysics(),
            //     shrinkWrap: true,
            //     itemCount: gamePages.length,
            //     // itemCount: 5,
            //     itemBuilder: (context, index) {
            //       return GestureDetector(
            //         onTap: () {
            //           Navigator.of(context).push(MaterialPageRoute(
            //               // builder: (context) =>const NST()));
            //               builder: (context) => gamePages[index]["page"]));
            //         },
            //         child: Stack(
            //           alignment: Alignment.center,
            //           children: [
            //             Container(
            //               margin: const EdgeInsets.all(7),
            //               width: getRelativeWidth(0.90),
            //               height: getRelativeHeight(0.20),
            //               decoration: BoxDecoration(
            //                 boxShadow: [
            //                   BoxShadow(
            //                     color: !isDarkMode
            //                         ? Colors.grey.withOpacity(0.3)
            //                         : Colors.blueGrey.withOpacity(0.15),
            //                     spreadRadius: 1.5,
            //                     blurRadius: 4,
            //                     offset: Offset.fromDirection(
            //                         1, 5), // changes position of shadow
            //                   ),
            //                 ],
            //                 borderRadius: BorderRadius.circular(15),
            //                 color:
            //                     Theme.of(context).brightness == Brightness.dark
            //                         ? ThemeClass().darkRounded
            //                         : const Color.fromARGB(255, 240, 240, 245),
            //               ),
            //               child: Padding(
            //                 padding: EdgeInsets.symmetric(
            //                     horizontal: getRelativeWidth(0.03)),
            //                 // child: Container(
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Flexible(
            //                       child: Column(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         mainAxisAlignment: MainAxisAlignment.center,
            //                         children: [
            //                           Text(
            //                             gamePages[index]["name"],
            //                             // "Matching Games",
            //                             style: GoogleFonts.nunito(
            //                               color: isDarkMode
            //                                   ? const Color.fromARGB(
            //                                       255, 211, 227, 253)
            //                                   : const Color.fromARGB(
            //                                       255, 124, 124, 124),
            //                               fontWeight: FontWeight.bold,
            //                               fontSize: 18,
            //                             ),
            //                           ),
            //                           SizedBox(height: getRelativeHeight(0.02)),
            //                         ],
            //                       ),
            //                     ),
            //                     Stack(
            //                       alignment: Alignment.center,
            //                       children: [
            //                         Container(
            //                           padding: const EdgeInsets.all(5),
            //                           child: Column(
            //                             children: [
            //                               Align(
            //                                 alignment: Alignment.topRight,
            //                                 child: Chip(
            //                                   backgroundColor:
            //                                       const Color.fromARGB(
            //                                           255, 218, 238, 231),
            //                                   label: Text(
            //                                     gamePages[index]["tag"],
            //                                     // "Dyslexia",
            //                                     style: GoogleFonts.nunito(
            //                                       color: const Color.fromARGB(
            //                                           255, 95, 228, 180),
            //                                       fontWeight: FontWeight.bold,
            //                                       fontSize: 13,
            //                                     ),
            //                                   ),
            //                                   side: const BorderSide(
            //                                       color: Color.fromARGB(
            //                                           255, 218, 238, 231)),
            //                                 ),
            //                               ),
            //                               Image.asset(
            //                                 gamePages[index]["image"],
            //                                 // 'assets/images/autism1.png',
            //                                 height: 98,
            //                                 width: 98,
            //                               )
            //                             ],
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                     // SizedBox(width: getRelativeWidth(0.012)),
            //                   ],
            //                 ),
            //                 // ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       );
            //     },
            //   ),
            // ),

            // const SizedBox(
            //   height: 15,
            // ),
            // GestureDetector(
            //   onTap: () {
            //     Navigator.of(context)
            //         .push(MaterialPageRoute(builder: (context) => const NST()));
            //   },
            //   child: Stack(
            //     alignment: Alignment.center,
            //     children: [
            //       Container(
            //         width: getRelativeWidth(0.90),
            //         height: getRelativeHeight(0.20),
            //         decoration: BoxDecoration(
            //           boxShadow: [
            //             BoxShadow(
            //               color: !isDarkMode
            //                   ? Colors.grey.withOpacity(0.3)
            //                   : Colors.blueGrey.withOpacity(0.15),
            //               spreadRadius: 1.5,
            //               blurRadius: 4,
            //               offset: Offset.fromDirection(
            //                   1, 5), // changes position of shadow
            //             ),
            //           ],
            //           borderRadius: BorderRadius.circular(15),
            //           color: Theme.of(context).brightness == Brightness.dark
            //               ? ThemeClass().darkRounded
            //               : const Color.fromARGB(255, 240, 240, 245),
            //         ),
            //         child: Padding(
            //           padding: EdgeInsets.symmetric(
            //               horizontal: getRelativeWidth(0.03)),
            //           // child: Container(
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Flexible(
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     Text(
            //                       // "Permainan Pra Membaca cocok gambar NST untuk Disleksia",
            //                       "Matching Games",
            //                       style: GoogleFonts.nunito(
            //                         color: isDarkMode
            //                             ? const Color.fromARGB(
            //                                 255, 211, 227, 253)
            //                             : const Color.fromARGB(
            //                                 255, 124, 124, 124),
            //                         fontWeight: FontWeight.bold,
            //                         fontSize: 18,
            //                       ),
            //                     ),
            //                     SizedBox(height: getRelativeHeight(0.02)),
            //                   ],
            //                 ),
            //               ),
            //               Stack(
            //                 alignment: Alignment.center,
            //                 children: [
            //                   Container(
            //                     padding: const EdgeInsets.all(5),
            //                     child: Column(
            //                       children: [
            //                         Align(
            //                           alignment: Alignment.topRight,
            //                           child: Chip(
            //                             backgroundColor: const Color.fromARGB(
            //                                 255, 218, 238, 231),
            //                             label: Text(
            //                               "Dyslexia",
            //                               style: GoogleFonts.nunito(
            //                                 color: const Color.fromARGB(
            //                                     255, 95, 228, 180),
            //                                 fontWeight: FontWeight.bold,
            //                                 fontSize: 13,
            //                               ),
            //                             ),
            //                             side: const BorderSide(
            //                                 color: Color.fromARGB(
            //                                     255, 218, 238, 231)),
            //                           ),
            //                         ),
            //                         Image.asset(
            //                           'assets/images/autism1.png',
            //                           height: 98,
            //                           width: 98,
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //               // SizedBox(width: getRelativeWidth(0.012)),
            //             ],
            //           ),
            //           // ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(
            //   height: 15,
            // ),
            // GestureDetector(
            //   onTap: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => const PhonetikList()));
            //   },
            //   child: Stack(
            //     alignment: Alignment.center,
            //     children: [
            //       Container(
            //         width: getRelativeWidth(0.90),
            //         height: getRelativeHeight(0.20),
            //         decoration: BoxDecoration(
            //           boxShadow: [
            //             BoxShadow(
            //               color: !isDarkMode
            //                   ? Colors.grey.withOpacity(0.3)
            //                   : Colors.blueGrey.withOpacity(0.15),
            //               spreadRadius: 1.5,
            //               blurRadius: 4,
            //               offset: Offset.fromDirection(
            //                   1, 5), // changes position of shadow
            //             ),
            //           ],
            //           borderRadius: BorderRadius.circular(15),
            //           color: Theme.of(context).brightness == Brightness.dark
            //               ? ThemeClass().darkRounded
            //               : const Color.fromARGB(255, 240, 240, 245),
            //         ),
            //         child: Padding(
            //           padding: EdgeInsets.symmetric(
            //               horizontal: getRelativeWidth(0.03)),
            //           // child: Container(
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Flexible(
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     Text(
            //                       // "Terapi Bermain untuk penyandang Dislexia",
            //                       "Phonetic Games",
            //                       style: GoogleFonts.nunito(
            //                         color: isDarkMode
            //                             ? const Color.fromARGB(
            //                                 255, 211, 227, 253)
            //                             : const Color.fromARGB(
            //                                 255, 124, 124, 124),
            //                         fontWeight: FontWeight.bold,
            //                         fontSize: 18,
            //                       ),
            //                     ),
            //                     SizedBox(height: getRelativeHeight(0.02)),
            //                   ],
            //                 ),
            //               ),
            //               Stack(
            //                 alignment: Alignment.center,
            //                 children: [
            //                   Container(
            //                     padding: const EdgeInsets.all(5),
            //                     child: Column(
            //                       children: [
            //                         Align(
            //                           alignment: Alignment.topRight,
            //                           child: Chip(
            //                             backgroundColor: const Color.fromARGB(
            //                                 255, 218, 238, 231),
            //                             label: Text(
            //                               "Dyslexia",
            //                               style: GoogleFonts.nunito(
            //                                 color: const Color.fromARGB(
            //                                     255, 95, 228, 180),
            //                                 fontWeight: FontWeight.bold,
            //                                 fontSize: 13,
            //                               ),
            //                             ),
            //                             side: const BorderSide(
            //                                 color: Color.fromARGB(
            //                                     255, 218, 238, 231)),
            //                           ),
            //                         ),
            //                         Image.asset(
            //                           'assets/images/dyslexia1.png',
            //                           height: 98,
            //                           width: 98,
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //               // SizedBox(width: getRelativeWidth(0.012)),
            //             ],
            //           ),
            //           // ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(
            //   height: 15,
            // ),
            // GestureDetector(
            //   onTap: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => const AnimalTest()));
            //   },
            //   child: Stack(
            //     alignment: Alignment.center,
            //     children: [
            //       Container(
            //         width: getRelativeWidth(0.90),
            //         height: getRelativeHeight(0.20),
            //         decoration: BoxDecoration(
            //           boxShadow: [
            //             BoxShadow(
            //               color: !isDarkMode
            //                   ? Colors.grey.withOpacity(0.3)
            //                   : Colors.blueGrey.withOpacity(0.15),
            //               spreadRadius: 1.5,
            //               blurRadius: 4,
            //               offset: Offset.fromDirection(
            //                   1, 5), // changes position of shadow
            //             ),
            //           ],
            //           borderRadius: BorderRadius.circular(15),
            //           color: Theme.of(context).brightness == Brightness.dark
            //               ? ThemeClass().darkRounded
            //               : const Color.fromARGB(255, 240, 240, 245),
            //         ),
            //         child: Padding(
            //           padding: EdgeInsets.symmetric(
            //               horizontal: getRelativeWidth(0.03)),
            //           // child: Container(
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Flexible(
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     Text(
            //                       // "Terapi Audio dan Visual untuk penyandang Autisme",
            //                       "Audio and Visual Therapy",
            //                       style: GoogleFonts.nunito(
            //                         color: isDarkMode
            //                             ? const Color.fromARGB(
            //                                 255, 211, 227, 253)
            //                             : const Color.fromARGB(
            //                                 255, 124, 124, 124),
            //                         fontWeight: FontWeight.bold,
            //                         fontSize: 18,
            //                       ),
            //                     ),
            //                     SizedBox(height: getRelativeHeight(0.02)),
            //                   ],
            //                 ),
            //               ),
            //               Stack(
            //                 alignment: Alignment.center,
            //                 children: [
            //                   Container(
            //                     padding: const EdgeInsets.all(5),
            //                     child: Column(
            //                       children: [
            //                         Align(
            //                           alignment: Alignment.topRight,
            //                           child: Chip(
            //                             backgroundColor: const Color.fromARGB(
            //                                 255, 218, 238, 231),
            //                             label: Text(
            //                               "Dyslexia",
            //                               style: GoogleFonts.nunito(
            //                                 color: const Color.fromARGB(
            //                                     255, 95, 228, 180),
            //                                 fontWeight: FontWeight.bold,
            //                                 fontSize: 13,
            //                               ),
            //                             ),
            //                             side: const BorderSide(
            //                                 color: Color.fromARGB(
            //                                     255, 218, 238, 231)),
            //                           ),
            //                         ),
            //                         Image.asset(
            //                           'assets/images/animal_test.png',
            //                           height: 98,
            //                           width: 98,
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //               // SizedBox(width: getRelativeWidth(0.012)),
            //             ],
            //           ),
            //         ),
            //         // ),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(
            //   height: 15,
            // ),
          ],
        ),
      ),
    );
  }
}
