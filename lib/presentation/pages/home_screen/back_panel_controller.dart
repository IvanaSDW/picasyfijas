import 'package:bulls_n_cows_reloaded/presentation/pages/home_screen/slider_switch_widget.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/matrix_effect/matrix_effect_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share_plus/share_plus.dart';

import '../../../navigation/routes.dart';
import '../../../shared/constants.dart';

class BackPanelController extends GetxController {

  final SliderSwitch sliderSwitch = SliderSwitch();

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

  void onLeaderboardMenuPressed() {
    sliderSwitch.controller.closeDrawer();
    Get.toNamed(Routes.leaderboard);
  }

  void onLogoutPressed() {

  }

  void onShare() {
    Share.share(
        'share_message'.tr + appController.playStoreDynamicLink!,
      subject: 'share_subject'.tr
    );
    sliderSwitch.controller.closeDrawer();
  }

  void onRate() {
    LaunchReview.launch();
    sliderSwitch.controller.closeDrawer();
  }


}