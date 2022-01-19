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
          ? Image.asset("assets/images/button_continue_spanish.png")
        : Image.asset("assets/images/button_continue.png"),
        onTap: onTapAction,
        borderRadius: const BorderRadius.all(Radius.circular(40)),
      ),
    );
  }
}