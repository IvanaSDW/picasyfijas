import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../shared/constants.dart';

class PanelLogoWidget extends StatelessWidget {
  const PanelLogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Image(
        image: Get.locale.toString().substring(0, 2) == 'es'
            ? appController.backPanelOn
            ? const AssetImage('assets/images/logo_spanish_on.png',)
            : const AssetImage('assets/images/logo_spanish_off.png',)
            : appController.backPanelOn
            ? const AssetImage('assets/images/logo_english_on.png',)
            : const AssetImage('assets/images/logo_english_off.png',),
      );
    });
  }
}