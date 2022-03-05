import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartButton extends StatelessWidget {

  final VoidCallback onTapAction;

  const StartButton({
    Key? key, required this.onTapAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: Get.locale.toString().substring(0,2) == 'es'
          ? Image.asset("assets/images/start_button.png")
        : Image.asset("assets/images/start_button.png"),
        onTap: onTapAction,
        borderRadius: const BorderRadius.all(Radius.circular(40)),
      ),
    );
  }
}