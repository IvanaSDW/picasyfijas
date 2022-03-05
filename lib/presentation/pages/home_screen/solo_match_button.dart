import 'package:bulls_n_cows_reloaded/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/constants.dart';

class SoloMatchButton extends StatelessWidget {
  final SoloMatchButtonController controller = Get.put(
      SoloMatchButtonController());

  SoloMatchButton({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(120.0)),
          onTap: () => controller.onPressed(),
          onTapDown: (details) => controller.onTapDown(),
          onTapCancel: () => controller.onTapCancel(),
          child: controller.isDown
              ? Image.asset('assets/images/solo_match_button_pressed.png')
              : Image.asset('assets/images/solo_match_button.png')
      );
    });
  }
}


class SoloMatchButtonController extends GetxController {

  final _isDown = false.obs;

  set isDown(value) => _isDown.value = value;

  get isDown => _isDown.value;

  void onTapDown() {
    appController.playEffect('audio/button-16.wav');
    isDown = true;
  }

  void onTapCancel() {
    isDown = false;
  }

  void onPressed() {
    appController.playEffect('audio/door-close.wav');
    Get.toNamed(Routes.soloGame);
    isDown = false;
  }
}
