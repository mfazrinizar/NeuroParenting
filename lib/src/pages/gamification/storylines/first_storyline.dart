import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuroparenting/src/pages/gamification/components/base_storyline.dart';
import 'package:neuroparenting/src/pages/gamification/components/from_index.dart';
import 'package:neuroparenting/src/pages/gamification/db.dart';
import 'package:neuroparenting/src/pages/gamification/theme_game.dart';

class FirstStoryLine extends HookWidget {
  final User? user;
  const FirstStoryLine({super.key, required this.user});

  Color? getOptionColor(int index, int selectedOption, int correctOption) {
    if (selectedOption == index) {
      if (correctOption == index) return Colors.greenAccent;
      if (correctOption == -1) return Colors.orangeAccent;
      return Colors.redAccent;
    } else {
      if (correctOption == index) return Colors.greenAccent;
      return const Color.fromARGB(255, 230, 230, 230);
    }
  }

  @override
  Widget build(BuildContext context) {
    return baseWidget(context, "First Story Line", _body(context), user);
  }

  Widget _body(BuildContext context) {
    late FlutterTts tts = FlutterTts();
    final displayOptions = useState(false);
    final startStory = useState(false);
    final displayText = useState("Start");
    final selectedOption = useState(-1);
    final questionIndex = useState(1);
    final correctOption = useState(-1);
    final submitted = useState(false);
    final displayReply = useState(false);
    final displayQuestion = useState(false);
    tts.setSpeechRate(0.6);

    final parsableText = questionFromIndex(1, questionIndex.value);
    final text = parsableText
        .map((paragraph) => TypewriterAnimatedText(
              paragraph,
              cursor: '',
              speed: const Duration(milliseconds: 75),
              textAlign: TextAlign.center,
              textStyle:
                  GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w400),
            ))
        .toList();
    List<ListTile> options = [];
    List<String> parsableOptions = optionsFromIndex(1, questionIndex.value);
    for (var i = 1; i <= parsableOptions.length; i++) {
      options.add(ListTile(
          tileColor:
              getOptionColor(i, selectedOption.value, correctOption.value),
          onTap: () => selectedOption.value = i,
          title: Column(children: [
            Text(
              parsableOptions[i - 1],
              style:
                  GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const Divider(
              height: 10,
              thickness: 3,
              endIndent: 0,
              color: Colors.white,
            ),
          ])));
    }
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(right: 100),
        child: Text("Claudio: The Dyslexic Turtle",
            style:
                GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700)),
      ),
      const SizedBox(height: 70),
      Image.asset(
        "assets/images/autismgame.png",
        height: 300,
      ),
      const SizedBox(height: 5),
      (displayQuestion.value)
          ? Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: const Color.fromARGB(255, 242, 242, 242),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: AnimatedTextKit(
                animatedTexts: text,
                repeatForever: false,
                pause: const Duration(seconds: 5),
                totalRepeatCount: 1,
                onFinished: () {
                  displayOptions.value = true;
                  displayText.value = "Restart";
                },
                onNextBeforePause: (idx, b) async {
                  await tts.speak(parsableText[idx]);
                },
                onNext: (idx, b) async {
                  await tts.awaitSpeakCompletion(true);
                },
              ),
            )
          : const SizedBox(height: 10),
      (displayOptions.value)
          ? Column(children: [
              (displayReply.value)
                  ? Container(
                      width: MediaQuery.of(context).size.width - 20,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                          color: const Color.fromARGB(255, 242, 242, 242),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                                cursor: '',
                                speed: const Duration(milliseconds: 75),
                                textAlign: TextAlign.center,
                                textStyle: GoogleFonts.nunito(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                                replyFromIndex(1, selectedOption.value,
                                    correctOption.value, questionIndex.value))
                          ],
                          repeatForever: false,
                          totalRepeatCount: 1,
                          pause: const Duration(seconds: 5),
                          onFinished: () {
                            submitted.value = true;
                          },
                          onNextBeforePause: (idx, b) async {
                            await tts.speak(replyFromIndex(
                                1,
                                selectedOption.value,
                                correctOption.value,
                                questionIndex.value));
                          },
                          onNext: (idx, b) async {
                            await tts.awaitSpeakCompletion(true);
                          }),
                    )
                  : const SizedBox(height: 10),
              Column(children: [
                ListBody(children: options),
              ]),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                (!submitted.value)
                    ? SizedBox(
                        height: 60,
                        width: 200,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                  255, 118, 117, 117), // Background color
                            ),
                            onPressed: () {
                              startStory.value = false;
                              displayText.value = "Start";
                              displayOptions.value = false;
                              selectedOption.value = -1;
                              correctOption.value = -1;
                              displayReply.value = false;
                              displayQuestion.value = false;
                              submitted.value = false;
                            },
                            child: Text(displayText.value,
                                style: GoogleFonts.nunito(
                                    backgroundColor: Colors.transparent,
                                    textStyle: GoogleFonts.nunito(
                                      fontSize: 20,
                                    )))),
                      )
                    : const SizedBox(height: 0, width: 0),
                (!submitted.value)
                    ? SizedBox(
                        height: 60,
                        width: 200,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: greenColor, // Background color
                            ),
                            onPressed: () {
                              if (selectedOption.value != -1) {
                                FirebaseFirestore.instance
                                    .collection('questions')
                                    .where('qid',
                                        isEqualTo: int.parse(
                                            "1${questionIndex.value}"))
                                    .get()
                                    .then((value) {
                                  correctOption.value =
                                      value.docs[0].get("answer");
                                  int inc = 1;
                                  if (correctOption.value ==
                                      selectedOption.value) {
                                    inc = 5;
                                  }
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .where('name', isEqualTo: user?.email)
                                      .get()
                                      .then((value) async {
                                    int multiplier =
                                        value.docs[0].get('multiplier');
                                    await DatabaseManager().updateUserTokens(
                                        email: user?.email,
                                        tokens: value.docs[0].get('tokens') +
                                            inc * multiplier);
                                  });
                                  displayReply.value = true;
                                  displayQuestion.value = false;
                                  submitted.value = true;
                                });
                              }
                            },
                            child: Text("Submit",
                                style: GoogleFonts.nunito(
                                    backgroundColor: Colors.transparent,
                                    textStyle: GoogleFonts.nunito(
                                      fontSize: 20,
                                    )))),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkBlueColor, // Background color
                        ),
                        onPressed: () {
                          questionIndex.value++;
                          if (questionIndex.value <= 4) {
                            displayOptions.value = false;
                            selectedOption.value = -1;
                            correctOption.value = -1;
                            displayReply.value = false;
                            displayQuestion.value = true;
                            submitted.value = false;
                          } else if (questionIndex.value == 5) {
                            displayReply.value = false;
                            displayQuestion.value = true;
                          } else {
                            FirebaseFirestore.instance
                                .collection('users')
                                .where('name', isEqualTo: user?.email)
                                .get()
                                .then((matches) {
                              int completed = matches.docs[0].get('completed');
                              DatabaseManager()
                                  .updateUserModules(
                                      email: user?.email,
                                      modules: completed + 1)
                                  .then((_) {
                                if (completed + 1 == 2) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Congratulations!"),
                                          content: const SingleChildScrollView(
                                              child: Text(
                                                  "You have unlocked your token multiplier for the day!")),
                                          actions: <Widget>[
                                            SizedBox(
                                              height: 50,
                                              width: 200,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        darkBlueColor, // Background color
                                                  ),
                                                  child: const Text("Ok"),
                                                  onPressed: () {
                                                    DatabaseManager()
                                                        .updateUserMultiplier(
                                                            email: user?.email,
                                                            multiplier: 2)
                                                        .then((_) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pop();
                                                    });
                                                  }),
                                            )
                                          ],
                                        );
                                      });
                                } else {
                                  Navigator.of(context).pop();
                                }
                              });
                            });
                          }
                        },
                        child: Text(
                            (questionIndex.value + 1 <= 5) ? "Next" : "Finish",
                            style: GoogleFonts.nunito(
                                backgroundColor: Colors.transparent))),
              ]),
            ])
          : const SizedBox(height: 0, width: 0),
      const SizedBox(height: 20),
      (!startStory.value)
          ? Column(children: [
              Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: MediaQuery.of(context).size.height / 4,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: const Color.fromARGB(255, 242, 242, 242),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Text(
                      "\nDiagnosis dengan autisme dan kesulitan serta hal positif yang dialami sepanjang hidupnya. Kami belajar bagaimana orang dengan autisme terpengaruh dari cerita ini.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w400, fontSize: 20))),
              const SizedBox(height: 20),
              SizedBox(
                  height: 50,
                  width: 300,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkBlueColor, // Background color
                      ),
                      onPressed: () {
                        startStory.value = true;
                        displayQuestion.value = true;
                      },
                      child: Text(
                        "Mulai",
                        style: GoogleFonts.nunito(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ))),
            ])
          : const SizedBox(height: 0, width: 0),
    ]);
  }
}
