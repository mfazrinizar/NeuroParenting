import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuroparenting/src/pages/gamification/pages/game_page.dart';
import 'package:neuroparenting/src/pages/gamification/theme_game.dart';

class AnimalTest extends StatelessWidget {
  AnimalTest({super.key});

  final player = AudioPlayer();

  // Function to generate a single card
  Widget generateCard(String letter) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          player.play(AssetSource('sound/animal-$letter.mp3'));
        },
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Image.asset('assets/animal/animal-$letter.png'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        title: Text(
          'Tebak hewan untuk Autisme',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: const Color.fromARGB(255, 255, 255, 255),
            onPressed: () {
              Get.offAll(const GamePage());
            }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            5, // Number of rows (from 'a' to 'z' is 26 letters, 2 letters per row)
            (index) => Row(
              children: [
                generateCard(
                    String.fromCharCode(97 + index * 2)), // ASCII of 'a' is 97
                generateCard(
                    String.fromCharCode(98 + index * 2)), // ASCII of 'b' is 98
              ],
            ),
          ),
        ),
      ),
    );
  }
}
