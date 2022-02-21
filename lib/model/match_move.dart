import 'package:bulls_n_cows_reloaded/model/four_digits.dart';
import 'package:bulls_n_cows_reloaded/model/digit_match_result.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';

class MatchMove {
  FourDigits guess;
  DigitMatchResult moveResult;
  int timeStampMillis;

  MatchMove({
    required this.guess,
    required this.moveResult,
    required this.timeStampMillis
  });

  factory MatchMove.fake() =>
      MatchMove(
          guess: FourDigits(digit0: 0, digit1: 0, digit2: 0, digit3: 0),
          moveResult: DigitMatchResult(bulls: 0, cows: 0),
          timeStampMillis: 0
      );

  MatchMove.fromData(Map<String, dynamic> data)
      : guess = FourDigits.fromData(data[moveGuessFN]),
        moveResult = DigitMatchResult.fromData(data[moveResultFN]),
        timeStampMillis = data[moveTimeStamp];

  Map<String, dynamic> toJson() => {
    moveGuessFN: guess.toJson(),
    moveResultFN: moveResult.toJson(),
    moveTimeStamp: timeStampMillis
  };
}
