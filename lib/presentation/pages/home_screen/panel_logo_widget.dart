import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PanelLogoWidget extends StatelessWidget {
  const PanelLogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      image: Get.locale.toString().substring(0, 2) == 'es'
          ? const AssetImage('assets/images/panel_logo_spa.png',)
          : const AssetImage('assets/images/panel_logo_eng.png',),
    );

  }
}