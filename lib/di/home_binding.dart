import 'package:bulls_n_cows_reloaded/data/backend_services/firebase_auth_service.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/player_data_display/player_stats_controller.dart';
import 'package:get/get.dart';

import '../presentation/pages/home_screen/home_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(FirebaseAuthService());
    Get.put(PlayerStatsController());
    Get.put(HomeController());
  }

}