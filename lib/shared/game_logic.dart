import 'dart:math';

import 'package:bulls_n_cows_reloaded/data/models/digit_match_result.dart';
import 'package:bulls_n_cows_reloaded/data/models/four_digits.dart';
import 'package:bulls_n_cows_reloaded/data/models/solo_game.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';

DigitMatchResult getMatchResult(FourDigits secret, FourDigits guess) {
  var bulls = 0;
  var cows = 0;

  List<int> guessDigits = [
    guess.digit0,
    guess.digit1,
    guess.digit2,
    guess.digit3,
  ];

  var secretDigits = [
    secret.digit0,
    secret.digit1,
    secret.digit2,
    secret.digit3,
  ];

  for (var digit in guessDigits) {
    for (var element in secretDigits) {
      if (digit == element) {
        if (guessDigits.indexOf(digit) == secretDigits.indexOf(element)) {
          bulls++;
        } else {
          cows++;
        }
      }
    }
  }
  return DigitMatchResult(bulls: bulls, cows: cows);
}

FourDigits generateSecretNum() {
  Random random = Random();
  List<int> digits = <int>[];
  do {
    int newDigit = random.nextInt(10);
    bool isOk = true;
    for (int value in digits) {
      if (newDigit == value) isOk = false;
    }
    if (isOk) digits.add(newDigit);
  } while (digits.length <= 3);
  logger.i('Number generated: $digits');
  return FourDigits(digit0: digits[0], digit1: digits[1], digit2: digits[2], digit3: digits[3]);
}

Map<String, int> ttmStats(List<SoloGame> matches) {
  int matchQty = matches.length;
  int accumulatedTime = 0;
  int accumulatedMoves = 0;
  for (var element in matches) {
    accumulatedTime += element.moves.last.timeStampMillis;
    accumulatedMoves += element.moves.length;
  }
  int averageTime = accumulatedTime ~/ matchQty;
  int averageMoves = accumulatedMoves ~/ matchQty;
  return {
    'matches': matchQty,
    'average_time': averageTime,
    'average_moves': averageMoves
  };
}
