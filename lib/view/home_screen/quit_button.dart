import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuitButton extends StatelessWidget {

  final VoidCallback onTapAction;

  const QuitButton({Key? key, required this.onTapAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(40.0)),
      onTap: onTapAction,
      child: Get.locale.toString().substring(0, 2) == 'es'
          ? Image.asset('assets/images/quit_button_spanish.png')
          : Image.asset('assets/images/quit_button.png')
    );
  }
}