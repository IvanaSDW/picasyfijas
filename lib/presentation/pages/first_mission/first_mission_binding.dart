import 'package:get/get.dart';

import 'first_mission_logic.dart';

class FirstMissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FirstMissionLogic());
  }
}
