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
    return Obx(() {
      return InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(120)),
          onTap: () => controller.onPressed(),
          onTapDown: (details) => controller.onTapDown(),
          onTapCancel: () => controller.onTapCancel(),
          child: controller.isDown
              ? Image.asset('assets/images/versus_match_button_pressed.png')
              : Image.asset('assets/images/versus_match_button.png')
      );
    });
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
    logger.i('called, authState is: ${appController.authState}');
    isDown = false;
    if (appController.authState == AuthState.google) {
      Get.toNamed(Routes.findOpponent);
    } else {
      Get.defaultDialog(
        title: 'Requires Google sign in',
        middleText: 'Sign in with your google account to enable multiplayer mode.',
        textConfirm: 'Sign in',
        // textCancel: 'Back',
        backgroundColor: Colors.green.withOpacity(0.5),
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
