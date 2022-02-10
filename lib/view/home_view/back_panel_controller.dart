import 'package:bulls_n_cows_reloaded/view/home_view/slider_switch_widget.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../shared/constants.dart';

class BackPanelController extends GetxController {

  final SliderSwitch sliderSwitch = SliderSwitch();

  void togglePanelOnOff() async {
    HapticFeedback.lightImpact();
    if (appController.backPanelOn) {
      appController.playEffect('button-36.wav');
      appController.backPanelOn = false;
      sliderSwitch.controller.closeDrawer();
    } else {
      appController.playEffect('beep-21.wav');
      // playEffect('button-35.wav');
      appController.backPanelOn = true;
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


}