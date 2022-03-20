import 'package:bulls_n_cows_reloaded/presentation/pages/home_screen/slider_switch_widget.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/matrix_effect/matrix_effect_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../navigation/routes.dart';
import '../../../shared/constants.dart';

class BackPanelController extends GetxController {

  final SliderSwitch sliderSwitch = SliderSwitch();

  void togglePanelOnOff() async {
    HapticFeedback.lightImpact();
    if (appController.backPanelOn) {
      appController.playEffect('audio/button-40.wav');
      appController.backPanelOn = false;
      sliderSwitch.controller.closeDrawer();
      appController.quitApp();
    } else {
      appController.playEffect('audio/beep-21.wav');
      appController.backPanelOn = true;
      if(Get.isRegistered<MatrixEffectController>(tag: 'front_panel')) {
        Get.delete<MatrixEffectController>(tag: 'front_panel');
      }
    }
  }

  void toggleMuteOnOff() {
    HapticFeedback.lightImpact();
    if (appController.isMuted) {
      appController.isMuted = false;
    } else {
      appController.isMuted = true;
    }
  }

  void onProfileMenuPressed() {
    sliderSwitch.controller.closeDrawer();
    Get.toNamed(Routes.profile);
  }

  void onLogoutPressed() {

  }


}