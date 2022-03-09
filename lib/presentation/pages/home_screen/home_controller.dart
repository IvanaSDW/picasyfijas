import 'package:bulls_n_cows_reloaded/presentation/pages/home_screen/back_panel_controller.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/matrix_effect/matrix_effect_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {

  @override
  void onInit() {
    if (Get.isRegistered<MatrixEffectController>()) Get.delete<MatrixEffectController>();
    super.onInit();
  }

  void onAvatarTapped() {

  }

  void googleSignIn() async {
    logger.i('called');
    await authController
        .upgradeAnonymousToGoogle()
        .then((value) {
      logger.i('Successfully signed in with google');
    });
  }

  onBackPressed() {
    Get.find<BackPanelController>().togglePanelOnOff();
    return false;
  }
}
