import 'package:bulls_n_cows_reloaded/presentation/widgets/player_data_display/player_stats_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../navigation/routes.dart';
import '../../../shared/theme.dart';

class VersusMatchButton extends StatelessWidget {
  final VersusMatchButtonController controller = Get.put(
      VersusMatchButtonController());

  VersusMatchButton({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => controller.onPressed(),
        onTapDown: (details) => controller.onTapDown(),
        onTapCancel: () => controller.onTapCancel(),
        child: Obx(() {
          return controller.isDown
              ? Get.locale.toString().split('_').first.toLowerCase() == 'es'
              ? Image.asset('assets/images/btn_play_vs_es_tapped.png')
              : Image.asset('assets/images/btn_play_vs_en_tapped.png')
              : Get.locale.toString().split('_').first.toLowerCase() == 'es'
              ? Image.asset('assets/images/btn_play_vs_es_untapped.png')
              : Image.asset('assets/images/btn_play_vs_en_untapped.png');
        })
    );
  }
}


class VersusMatchButtonController extends GetxController {

  final _isDown = false.obs;

  set isDown(value) => _isDown.value = value;

  get isDown => _isDown.value;

  void onTapDown() {
    appController.playEffect('audio/beep-21.wav');
    isDown = true;
  }

  void onTapCancel() {
    isDown = false;
  }

  void onPressed() {
    isDown = false;

    if (!appController.currentPlayer.isVsUnlocked!) {
      Get.defaultDialog(
        title: 'versus_mode_locked'.tr,
        middleText: '''
        ${'to_unlock_need'.tr}
        -> ${'at_least_min_games'.tr}
        -> ${'time_average_below_max'.tr}
        ''',
        textConfirm: 'OK',
        backgroundColor: Colors.green.withOpacity(0.6),
        buttonColor: originalColors.accentColor2,
        cancelTextColor: originalColors.reverseTextColor,
        confirmTextColor: originalColors.textColorLight,
        onConfirm: () {
          Get.back();
        },
      );
    } else if (appController.authState == AuthState.google) {
      Get.find<PlayerStatsController>().refreshStats(auth.currentUser!.uid);
      Get.toNamed(Routes.findOpponent);
    } else {
      Get.defaultDialog(
        title: 'Requires Google sign in',
        middleText: 'Sign in with your google account to enable multiplayer mode.',
        textConfirm: 'Sign in',
        backgroundColor: Colors.green.withOpacity(0.6),
        buttonColor: originalColors.accentColor2,
        cancelTextColor: originalColors.reverseTextColor,
        confirmTextColor: originalColors.textColorLight,
        onConfirm: () {
          Get.back();
          authController.upgradeAnonymousToGoogle();
        },
      );
    }
  }
}
