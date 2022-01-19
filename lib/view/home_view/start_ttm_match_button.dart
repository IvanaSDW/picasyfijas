import 'package:flutter/material.dart';

class StartTimeTrialMatchButton extends StatelessWidget {

  final VoidCallback onTapAction;

  const StartTimeTrialMatchButton({Key? key, required this.onTapAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(120.0)),
      onTap: onTapAction,
      child: const Image(image: AssetImage('assets/images/time_trial_button.png'),),
    );
  }
}