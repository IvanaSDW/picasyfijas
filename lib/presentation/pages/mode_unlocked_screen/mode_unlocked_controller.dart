import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:get/get.dart';

class ModeUnlockedController {

  final RxBool _showUnlocked = false.obs;
  bool get showUnlocked => _showUnlocked.value;
  set showUnlocked(bool value) => _showUnlocked.value = value;

  final RxBool _showLittleText2 = false.obs;
  bool get showLittleText2 => _showLittleText2.value;
  set showLittleText2(bool value) => _showLittleText2.value = value;

  final RxBool _showLittleText1 = false.obs;
  bool get showLittleText1 => _showLittleText1.value;
  set showLittleText1(bool value) => _showLittleText1.value = value;

  final RxBool _showButtonContinue = false.obs;
  bool get showButtonContinue => _showButtonContinue.value;
  set showButtonContinue(bool value) => _showButtonContinue.value = value;

  void showUnlockedWithEffect() {
    appController.playEffect('audio/button-14.wav');
    showUnlocked = true;
  }

  void showLittleText1WithEffect() {
    appController.playEffect('audio/typewriter_short.wav');
    showLittleText1 = true;
  }

  void showLittleText2WithEffect() {
    appController.playEffect('audio/typewriter_short.wav');
    showLittleText2 = true;
  }

  void onContinueTapped() {
    Get.back();
  }
}