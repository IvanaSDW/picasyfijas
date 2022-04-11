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
    return InkWell(
        onTap: () => controller.onPressed(),
        onTapDown: (details) => controller.onTapDown(),
        onTapCancel: () => controller.onTapCancel(),
        child: Obx(() {
          return controller.isDown
              ? Get.locale.toString().split('_').first.toLowerCase() == 'es'
              ? Image.asset('assets/images/btn_play_solo_es_tapped.png')
              : Image.asset('assets/images/btn_play_solo_en_tapped.png')
              : Get.locale.toString().split('_').first.toLowerCase() == 'es'
              ? Image.asset('assets/images/btn_play_solo_es_untapped.png')
              : Image.asset('assets/images/btn_play_solo_en_untapped.png');
        })
    );
  }
}


class SoloMatchButtonController extends GetxController {

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
    appController.playEffect('audio/door-close.wav');
    Get.toNamed(Routes.soloGame);
    isDown = false;
  }
}
