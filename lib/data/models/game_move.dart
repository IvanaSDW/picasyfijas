import 'package:bulls_n_cows_reloaded/data/models/four_digits.dart';
import 'package:bulls_n_cows_reloaded/data/models/digit_match_result.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';

class GameMove {
  FourDigits guess;
  DigitMatchResult moveResult;
  int timeStampMillis;

  GameMove({
    required this.guess,
    required this.moveResult,
    required this.timeStampMillis
  });

  factory GameMove.dummy() =>
      GameMove(
          guess: FourDigits(digit0: 0, digit1: 0, digit2: 0, digit3: 0),
          moveResult: DigitMatchResult(bulls: 0, cows: 0),
          timeStampMillis: 0
      );

  GameMove.fromData(Map<String, dynamic> data)
      : guess = FourDigits.fromData(data[moveGuessFN]),
        moveResult = DigitMatchResult.fromData(data[moveResultFN]),
        timeStampMillis = data[moveTimeStamp];

  Map<String, dynamic> toJson() => {
    moveGuessFN: guess.toJson(),
    moveResultFN: moveResult.toJson(),
    moveTimeStamp: timeStampMillis
  };
}
