import 'package:bulls_n_cows_reloaded/data/models/four_digits.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:characters/characters.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NumericKeyboardController extends GetxController {
  String numberTyped = "";
  final List<bool> lastNumbersEnabled = [
    true, true, true,
    true, true, true,
    true, true, true,
    true,
  ];
  final List<int> screenDigitNumbers = [8, 8, 8, 8].obs;
  final List<bool> screenDigitEnabled = [false, false, false, false].obs;
  final List<bool> numberKeyEnabled =
      [true, true, true, true, true, true, true, true, true, true].obs;
  final RxBool bsKeyEnabled = false.obs;
  final RxBool enterKeyEnabled = false.obs;

  void Function(FourDigits newInput)? _onNewInput;

  void onNewInput(Function(FourDigits newInput) callback) {
    _onNewInput = callback;
  }


  void numberKeyTapped(keyNumber) {
    numberTyped = numberTyped + keyNumber.toString();
    parseEnabledKeys(numberTyped);
  }

  void bsKeyTapped() {
    HapticFeedback.lightImpact();
    numberTyped = numberTyped.substring(0, numberTyped.length - 1);
    parseEnabledKeys(numberTyped);
  }

  void resetKeyboard() {
    numberTyped = "";
    screenDigitNumbers.assignAll([8, 8, 8, 8]);
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
        screenDigitNumbers.assignAll([8, 8, 8, 8]);
        screenDigitEnabled.assignAll([false, false, false, false]);
        numberKeyEnabled.assignAll(
            [true, true, true, true, true, true, true, true, true, true]);
        for (var element in numberTyped.characters) {
          screenDigitNumbers[charCount] = int.parse(element);
          screenDigitEnabled[charCount] = true;
          charCount++;
          numberKeyEnabled[int.parse(element)] = false;
        }
        break;
      case 4:
        {
          bsKeyEnabled.value = true;
          enterKeyEnabled.value = true;
          var charCount = 0;
          screenDigitNumbers.assignAll([8, 8, 8, 8]);
          numberKeyEnabled.assignAll([
            false, false, false,
            false, false, false,
            false, false, false,
            false
          ]);
          for (var element in numberTyped.characters) {
            screenDigitNumbers[charCount] = int.parse(element);
            screenDigitEnabled[charCount] = true;
            charCount++;
            numberKeyEnabled[int.parse(element)] = false;
          }
        }
        break;
    }
  }

  void onEnterTapped() {
    appController.playEffect('audio/beep-21.wav');
    if (_onNewInput != null) _onNewInput!(stringToFourDigits(numberTyped));
    resetKeyboard();
  }

  FourDigits stringToFourDigits(String numberTyped) {
    int digit0, digit1, digit2, digit3;
    digit0 = int.parse(numberTyped.substring(0, 1));
    digit1 = int.parse(numberTyped.substring(1, 2));
    digit2 = int.parse(numberTyped.substring(2, 3));
    digit3 = int.parse(numberTyped.substring(3, 4));
    return FourDigits(digit0: digit0, digit1: digit1, digit2: digit2, digit3: digit3);
  }
}
