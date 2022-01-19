import 'package:flutter/material.dart';

class StartVsModeMatchButton extends StatelessWidget {
  final VoidCallback onTapAction;

  const StartVsModeMatchButton({Key? key, required this.onTapAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(120)),
      onTap: onTapAction,
      child: const Image(
        image: AssetImage('assets/images/vs_mode_button.png'),
      ),
    );
  }
}
