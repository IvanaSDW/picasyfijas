import 'package:auto_size_text/auto_size_text.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/player_data_display/player_stats_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:bulls_n_cows_reloaded/shared/text_styles.dart';
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
          return Stack(
            alignment: Alignment.center,
            children: [
              controller.isDown
                  ? Image.asset('assets/images/play_button_tapped.png')
                  : Image.asset('assets/images/play_button_untapped.png'),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0),
                child: AutoSizeText(
                  'play_versus'.tr,
                  maxLines: 2,
                  style: playButtonTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 11.0, left: 11.0, bottom: 13.0, right: 13.0),
                child: AutoSizeText(
                  'play_versus'.tr,
                  maxLines: 2,
                  style: playButtonTextLayer1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
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
