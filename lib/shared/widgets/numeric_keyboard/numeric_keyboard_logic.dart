import 'package:bulls_n_cows_reloaded/model/four_digits.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:characters/characters.dart';
import 'package:get/get.dart';

class NumericKeyboardLogic extends GetxController {
  String numberTyped = "";
  final List<bool> lastNumbersEnabled = [
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true
  ];
  final List<int> screenDigitNumbers = [0, 0, 0, 0].obs;
  final List<bool> screenDigitEnabled = [false, false, false, false].obs;
  final List<bool> numberKeyEnabled =
      [true, true, true, true, true, true, true, true, true, true].obs;
  final RxBool bsKeyEnabled = false.obs;
  final RxBool enterKeyEnabled = false.obs;
  Rx<FourDigits> newGuess = FourDigits(digit2: 0, digit1: 0, digit3: 0, digit0: 0).obs;

  void numberKeyTapped(keyNumber) {
    numberTyped = numberTyped + keyNumber.toString();
    logger.i('Number so far: $numberTyped');
    parseEnabledKeys(numberTyped);
  }

  void bsKeyTapped() {
    numberTyped = numberTyped.substring(0, numberTyped.length - 1);
    parseEnabledKeys(numberTyped);
  }

  void resetKeyboard() {
    numberTyped = "";
    screenDigitNumbers.assignAll([0, 0, 0, 0]);
    screenDigitEnabled.assignAll([false, false, false, false]);
    numberKeyEnabled.assignAll(
        [true, true, true, true, true, true, true, true, true, true]);
    bsKeyEnabled.value = false;
    enterKeyEnabled.value = false;
  }

  void parseEnabledKeys(String numberTyped) {
    switch (numberTyped.length) {
      case 0:
        {
          resetKeyboard();
        }
        break;
      case 1:
      case 2:
      case 3:
        bsKeyEnabled.value = true;
        enterKeyEnabled.value = false;
        var charCount = 0;
        screenDigitNumbers.assignAll([0, 0, 0, 0]);
        screenDigitEnabled.assignAll([false, false, false, false]);
        numberKeyEnabled.assignAll(
            [true, true, true, true, true, true, true, true, true, true]);
        for (var element in numberTyped.characters) {
          logger.i('this char is: $element');
          screenDigitNumbers[charCount] = int.parse(element);
          screenDigitEnabled[charCount] = true;
          charCount++;
          numberKeyEnabled[int.parse(element)] = false;
        }
        logger.i('Screen cells enabled: $screenDigitEnabled');
        break;
      case 4:
        {
          bsKeyEnabled.value = true;
          enterKeyEnabled.value = true;
          var charCount = 0;
          screenDigitNumbers.assignAll([0, 0, 0, 0]);
          numberKeyEnabled.assignAll([
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false
          ]);
          for (var element in numberTyped.characters) {
            logger.i('this char is: $element');
            screenDigitNumbers[charCount] = int.parse(element);
            screenDigitEnabled[charCount] = true;
            charCount++;
            numberKeyEnabled[int.parse(element)] = false;
          }
        }
        break;
    }
  }

  void enterKeyTapped() {
    newGuess.value = FourDigits(
      digit0: stringToDigits(numberTyped)[0],
      digit1: stringToDigits(numberTyped)[1],
      digit2: stringToDigits(numberTyped)[2],
      digit3: stringToDigits(numberTyped)[3],
    );
    resetKeyboard();
  }

  List<int> stringToDigits(String numberTyped) {
    logger.i('number typed received: $numberTyped');
    var digits = <int>[];
    for (var element in numberTyped.characters) {
      digits.add(int.parse(element));
    }
    return digits;
  }
}
