import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:neuroparenting/src/pages/gamification/components/custom_container.dart';
import 'package:neuroparenting/src/pages/gamification/components/from_index_dc.dart';
import 'package:neuroparenting/src/pages/gamification/db.dart';

class DailyChallenge extends HookWidget {
  final User? user;
  const DailyChallenge({super.key, required this.user});

  Color? getOptionColor(int index, int selectedOption, int correctOption) {
    if (selectedOption == index) {
      if (correctOption == index) return Colors.greenAccent;
      if (correctOption == -1) return Colors.orangeAccent;
      return Colors.redAccent;
    } else {
      if (correctOption == index) return Colors.greenAccent;
      return Colors.lightBlue[50];
    }
  }

  Widget _startDailyChallenge(
      BuildContext context, int dayId, String currentDate) {
    String question = questionFromIndex(dayId + 1);
    List<dynamic> options = optionsFromIndex(dayId + 1);
    final selectedOption = useState(0);
    final displayOptions = useState(false);
    final submitted = useState(false);
    final answer = useState(-1);

    List<ListTile> opts = [];
    for (var i = 1; i <= options.length; i++) {
      opts.add(ListTile(
          tileColor: getOptionColor(i, selectedOption.value, answer.value),
          onTap: () => selectedOption.value = i,
          title: Column(children: [
            Text(
              options[i - 1],
              style:
                  GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const Divider(),
          ])));
    }
    return Column(
      children: [
        const SizedBox(height: 40),
        Text("Daily Challenge",
            style: GoogleFonts.nunito(
              fontSize: 20,
            )),
        const SizedBox(height: 10),
        const CircleAvatar(
            backgroundImage: AssetImage("images/user.png"), radius: 50),
        const SizedBox(height: 5),
        (dayId != -1)
            ? Container(
                width: MediaQuery.of(context).size.width - 20,
                decoration: BoxDecoration(
                    color: Colors.lightBlue[50],
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      question,
                      cursor: '',
                      speed: const Duration(milliseconds: 50),
                      textAlign: TextAlign.center,
                      textStyle: GoogleFonts.nunito(
                          fontSize: 20, fontWeight: FontWeight.w400),
                    )
                  ],
                  displayFullTextOnTap: true,
                  repeatForever: false,
                  stopPauseOnTap: true,
                  pause: const Duration(seconds: 2),
                  totalRepeatCount: 1,
                  onFinished: () {
                    displayOptions.value = true;
                  },
                ))
            : const SizedBox(height: 10),
        const SizedBox(height: 10),
        (displayOptions.value)
            ? Column(children: [
                ListBody(children: opts),
                (!submitted.value)
                    ? ElevatedButton(
                        onPressed: () {
                          submitted.value = true;
                          FirebaseFirestore.instance
                              .collection('daily_challenges')
                              .where('day_id', isEqualTo: dayId)
                              .get()
                              .then((matches) {
                            answer.value = matches.docs[0].get('answer');
                          });
                        },
                        child: const Text("Submit"))
                    : ElevatedButton(
                        onPressed: () async {
                          FirebaseFirestore.instance
                              .collection('users')
                              .where('name', isEqualTo: user?.email)
                              .get()
                              .then((matches) async {
                            int userTokens = matches.docs[0].get('tokens');
                            int inc = 5;
                            int mult = matches.docs[0].get('multiplier');
                            if (answer.value == selectedOption.value) inc = 10;
                            await DatabaseManager().updateUserTokens(
                                email: user?.email,
                                tokens: userTokens + inc * mult);
                          });
                          await DatabaseManager().updateUserCompletedDc(
                              email: user?.email, completedDc: dayId);
                          await DatabaseManager().updateUserLastDailyChallenge(
                              email: user?.email,
                              lastDailyChallenge: currentDate);
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
                        child: const Text("Finish"))
              ])
            : const SizedBox(height: 10)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final challengeCompleted = useState(false);
    final formattedCurrentDate = useState("");
    final dayId = useState(-1);
    useEffect(() {
      DateTime currentDate = DateTime.now();
      formattedCurrentDate.value = DateFormat.yMMMd().format(currentDate);
      FirebaseFirestore.instance
          .collection('users')
          .where('name', isEqualTo: user?.email)
          .get()
          .then((matches) async {
        String? lastDailyChallenge = matches.docs[0].get('last_challenge');
        if (lastDailyChallenge == null) {
          challengeCompleted.value = false;
          await DatabaseManager().updateUserLastDailyChallenge(
              email: user?.email,
              lastDailyChallenge: formattedCurrentDate.value);
        } else if (lastDailyChallenge == formattedCurrentDate.value) {
          challengeCompleted.value = true;
        } else {
          challengeCompleted.value = false;
          dayId.value = matches.docs[0].get('completed_dc') + 1;
        }
      });
      return null;
    }, []);
    return customContainer(
      Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(children: [
            (!challengeCompleted.value)
                ? _startDailyChallenge(
                    context, dayId.value, formattedCurrentDate.value)
                : Column(children: [
                    const SizedBox(height: 50),
                    Text("Daily Challenge Completed!",
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                        )),
                    Text("Come back tomorrow!",
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                        ))
                  ])
          ]),
        ),
      ),
    );
  }
}
