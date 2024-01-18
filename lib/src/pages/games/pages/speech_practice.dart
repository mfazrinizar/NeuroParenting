import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuroparenting/src/pages/games/components/custom_container.dart';

class SpeechPractice extends StatefulWidget {
  final User? user;
  const SpeechPractice({Key? key, required this.user}) : super(key: key);

  @override
  State<SpeechPractice> createState() => _SpeechPracticeState();
}

enum TtsState { playing, stopped }

class _SpeechPracticeState extends State<SpeechPractice> {
  late FlutterTts _flutterTts;
  String? _tts;
  TtsState _ttsState = TtsState.stopped;

  @override
  void initState() {
    super.initState();
    initTts();
  }

  @override
  void dispose() {
    super.dispose();
    _flutterTts.stop();
  }

  initTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts.awaitSpeakCompletion(true);

    // Konfigurasi bahasa Indonesia
    await _flutterTts.setLanguage('id-ID');

    _flutterTts.setStartHandler(() {
      setState(() {
        _ttsState = TtsState.playing;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        _ttsState = TtsState.stopped;
      });
    });

    _flutterTts.setCancelHandler(() {
      setState(() {
        _ttsState = TtsState.stopped;
      });
    });

    _flutterTts.setErrorHandler((message) {
      setState(() {
        _ttsState = TtsState.stopped;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return customContainer(
      Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Text(
                  "Text-To-Speech",
                  style: GoogleFonts.nunito(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[50],
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      input(),
                      button(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget input() => Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(25.0),
        child: TextField(
          onChanged: (String value) {
            setState(() {
              _tts = value;
            });
          },
        ),
      );

  Widget button() {
    if (_ttsState == TtsState.stopped) {
      return TextButton(
        onPressed: speak,
        child: const Text('Play'),
      );
    } else {
      return TextButton(
        onPressed: stop,
        child: const Text('Stop'),
      );
    }
  }

  Future speak() async {
    await _flutterTts.setVolume(1);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1);

    if (_tts != null) {
      if (_tts!.isNotEmpty) {
        await _flutterTts.speak(_tts!);
      }
    }
  }

  Future stop() async {
    var result = await _flutterTts.stop();
    if (result == 1) {
      setState(() {
        _ttsState = TtsState.stopped;
      });
    }
  }
}
