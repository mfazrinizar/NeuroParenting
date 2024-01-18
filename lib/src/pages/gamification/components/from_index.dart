import 'package:neuroparenting/src/pages/gamification/storylines/txt/story1_txt.dart';
import 'package:neuroparenting/src/pages/gamification/storylines/txt/story2_txt.dart';

List<String> questionFromIndex(int story, int index) {
  List<String> question;
  if (story == 1) {
    switch (index) {
      case 1:
        question = story1Question1;
        break;
      case 2:
        question = story1Question2;
        break;
      case 3:
        question = story1Question3;
        break;
      case 4:
        question = story1Question4;
        break;
      default:
        question = story1Outro;
    }
  } else {
    switch (index) {
      case 1:
        question = story2Question1;
        break;
      case 2:
        question = story2Question2;
        break;
      case 3:
        question = story2Question3;
        break;
      case 4:
        question = story2Question4;
        break;
      default:
        question = story2Outro;
    }
  }
  return question;
}

List<String> optionsFromIndex(int story, int index) {
  List<String> options;
  if (story == 1) {
    switch (index) {
      case 1:
        options = story1Options1;
        break;
      case 2:
        options = story1Options2;
        break;
      case 3:
        options = story1Options3;
        break;
      case 4:
        options = story1Options4;
        break;
      default:
        options = story1Options1;
    }
  } else {
    switch (index) {
      case 1:
        options = story2Options1;
        break;
      case 2:
        options = story2Options2;
        break;
      case 3:
        options = story2Options3;
        break;
      case 4:
        options = story2Options4;
        break;
      default:
        options = story2Options1;
    }
  }
  return options;
}

String replyFromIndex(
    int story, int selectedOption, int correctOption, int index) {
  String reply = "";
  if (story == 1) {
    if (selectedOption == correctOption) {
      switch (index) {
        case 1:
          reply = story1Question1Correct;
          break;
        case 2:
          reply = story1Question2Correct;
          break;
        case 3:
          reply = story1Question3Correct;
          break;
        case 4:
          reply = story1Question4Correct;
          break;
        default:
          reply = story1Question1Correct;
      }
    } else {
      switch (index) {
        case 1:
          reply = story1Question1Wrong;
          break;
        case 2:
          reply = story1Question2Wrong;
          break;
        case 3:
          reply = story1Question3Wrong;
          break;
        case 4:
          reply = story1Question4Wrong;
          break;
        default:
          reply = story1Question1Wrong;
      }
    }
  } else {
    if (selectedOption == correctOption) {
      switch (index) {
        case 1:
          reply = story2Question1Correct;
          break;
        case 2:
          reply = story2Question2Correct;
          break;
        case 3:
          reply = story2Question3Correct;
          break;
        case 4:
          reply = story2Question4Correct;
          break;
        default:
          reply = story2Question2Correct;
      }
    } else {
      switch (index) {
        case 1:
          reply = story2Question1Wrong;
          break;
        case 2:
          reply = story2Question2Wrong;
          break;
        case 3:
          reply = story2Question3Wrong;
          break;
        case 4:
          reply = story2Question4Wrong;
          break;
        default:
          reply = story2Question1Wrong;
      }
    }
  }
  return reply;
}
