

import 'package:bulls_n_cows_reloaded/shared/constants.dart';

class DigitMatchResult {
  int bulls;
  int cows;

  DigitMatchResult({required this.bulls, required this.cows});

  DigitMatchResult.fromData(Map<String, dynamic> data)
      : bulls = data[resultBullsFN],
        cows = data[resultCowsFN];

  Map<String, dynamic> toJson() => {resultBullsFN : bulls, resultCowsFN : cows};
}