import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VersusMatchButton extends StatelessWidget {
  final VersusMatchButtonController controller = Get.put(
      VersusMatchButtonController());

  VersusMatchButton({Key? key,})
      : super(key: key);

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
    appController.playEffect('audio/button-16.wav');
    isDown = true;
  }

  void onTapCancel() {
    isDown = false;
  }

  void onPressed() {
    // Get.toNamed('/VersusMatch');
    isDown = false;
  }
}
