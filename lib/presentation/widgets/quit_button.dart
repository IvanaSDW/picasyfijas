import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContinueButton extends StatelessWidget {

  final VoidCallback onTapAction;

  const ContinueButton({
    Key? key, required this.onTapAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: Get.locale.toString().substring(0,2) == 'es'
          ? Image.asset("assets/images/quit_button_spanish.png")
        : Image.asset("assets/images/quit_Button.png"),
        onTap: onTapAction,
        borderRadius: const BorderRadius.all(Radius.circular(40)),
      ),
    );
  }
}