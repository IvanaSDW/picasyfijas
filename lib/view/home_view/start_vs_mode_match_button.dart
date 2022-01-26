import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartVsModeMatchButton extends StatelessWidget {
  final VoidCallback onTapAction;

  const StartVsModeMatchButton({Key? key, required this.onTapAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(120)),
      onTap: onTapAction,
      child: Get.locale.toString().substring(0, 2) == 'es'
          ? Image.asset('assets/images/vsm_button_spanish.png')
          : Image.asset('assets/images/vs_mode_button.png')
      );
  }
}
