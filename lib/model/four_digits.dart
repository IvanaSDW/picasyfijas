


import 'package:bulls_n_cows_reloaded/shared/constants.dart';

class FourDigits {
  int digit0;
  int digit1;
  int digit2;
  int digit3;

  FourDigits(this.digit0, this.digit1, this.digit2, this.digit3);

  Map<String, dynamic> toJson() =>
      {moveDigitsFN: {digit0, digit1, digit2, digit3}};

  factory FourDigits.fromData(Map<String, dynamic> data) =>
      FourDigits(data['digits'][0], data['digits'][1], data['digits'][2], data['digits'][3]);
}

