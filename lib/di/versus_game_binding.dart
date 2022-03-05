import 'package:bulls_n_cows_reloaded/presentation/controllers/numeric_keyboard_controller.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/versus_game_screen/versus_game_logic.dart';
import 'package:get/get.dart';

class VersusGameBindings extends Bindings {

  @override
  void dependencies() {
    Get.put(NumericKeyboardController());
    Get.put(VersusGameLogic());
  }

}