import 'package:auto_size_text/auto_size_text.dart';
import 'package:bulls_n_cows_reloaded/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/constants.dart';
import '../../../shared/text_styles.dart';
import '../../../shared/theme.dart';

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
          return Stack(
            alignment: Alignment.center,
            children: [
              controller.isDown
                  ? Image.asset('assets/images/play_button_tapped.png')
                  : Image.asset('assets/images/play_button_untapped.png'),
              Padding(
                padding: const EdgeInsets.only(
                    top: 12.0, left: 12.0, bottom: 12.0, right: 12.0),
                child: AutoSizeText(
                  'play_solo'.tr,
                  maxLines: 2,
                  style: playButtonTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 11.0, left: 11.0, bottom: 13.0, right: 13.0),
                child: AutoSizeText(
                  'play_solo'.tr,
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
