import 'package:neuroparenting/src/pages/gamification/storylines/txt/dailychallenge_txt.dart';

String questionFromIndex(int index) {
  String question = "";
  switch (index) {
    case 1:
      question = dailyChallengeQuestion1;
      break;
    case 2:
      question = dailyChallengeQuestion2;
      break;
    case 3:
      question = dailyChallengeQuestion3;
      break;
    case 4:
      question = dailyChallengeQuestion4;
      break;
    default:
      question = dailyChallengeQuestion1;
  }
  return question;
}

List<String> optionsFromIndex(int index) {
  List<String> options = [];
  switch (index) {
    case 1:
      options = dailyChallengeOptions1;
      break;
    case 2:
      options = dailyChallengeOptions2;
      break;
    case 3:
      options = dailyChallengeOptions3;
      break;
    case 4:
      options = dailyChallengeOptions4;
      break;
    default:
      options = dailyChallengeOptions1;
  }
  return options;
}
