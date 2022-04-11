import 'package:bulls_n_cows_reloaded/presentation/pages/find_opponent_screen/find_opponent_controller.dart';
import 'package:get/get.dart';

class FindOpponentBindings extends Bindings {

  @override
  void dependencies() {
    Get.put(FindOpponentController());
  }

}