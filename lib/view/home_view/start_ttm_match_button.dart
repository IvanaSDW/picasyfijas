import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class StartTimeTrialMatchButton extends StatelessWidget {

  final VoidCallback onTapAction;

  const StartTimeTrialMatchButton({Key? key, required this.onTapAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(120.0)),
      onTap: onTapAction,
      child: Get.locale.toString().substring(0, 2) == 'es'
          ? Image.asset('assets/images/ttm_button_spanish.png')
          : Image.asset('assets/images/time_trial_button.png')
    );
  }
}