import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuroparenting/src/pages/gamification/animal_test/animal_test.dart';
import 'package:neuroparenting/src/pages/gamification/auth.dart';
import 'package:neuroparenting/src/pages/gamification/pages/nst.dart';
import 'package:neuroparenting/src/pages/gamification/phonetic%20list/phonetic_list.dart';
import 'package:neuroparenting/src/pages/gamification/size_config.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  @override
  _GamePageState createState() => _GamePageState();
}

final User? user = Auth().currentUser;

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 65, 115, 202),
        title: const Text(
          'Games',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: const Color.fromARGB(255, 255, 255, 255),
            onPressed: () {
              Get.offAll(const GamePage());
            }),
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
                                  "Permainan Pra Membaca cocok gambar NST untuk Disleksia",
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
                                  "Terapi Bermain untuk penyandang Dislexia",
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
                                  "Terapi Audio dan Visual untuk penyandang Autisme",
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
