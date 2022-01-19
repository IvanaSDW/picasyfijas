import 'package:bulls_n_cows_reloaded/model/four_digits.dart';
import 'package:bulls_n_cows_reloaded/model/digit_match_result.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';

class MatchMove {
  FourDigits? guess;
  DigitMatchResult? moveResult;
  int? timeStampMillis;

  MatchMove(
      {required this.guess,
      required this.moveResult,
      required this.timeStampMillis});

  MatchMove.empty();

  MatchMove.fromData(Map<String, dynamic> data)
      : guess = data[moveGuessFN],
        moveResult = data[moveResultFN],
        timeStampMillis = data[moveTimeStamp];

  Map<String, dynamic> toJson() => {
        moveGuessFN: guess!.toJson(),
        moveResultFN: moveResult!.toJson(),
        moveTimeStamp: timeStampMillis
      };
}
