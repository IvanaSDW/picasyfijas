import 'package:bulls_n_cows_reloaded/presentation/pages/solo_game_screen/solo_game_logic.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/numeric_keyboard/numeric_keyboard_controller.dart';
import 'package:get/get.dart';

class SoloMatchBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(NumericKeyboardController());
    Get.put(SoloGameLogic());
  }

}