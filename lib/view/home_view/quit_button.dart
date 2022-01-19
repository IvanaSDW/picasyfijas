import 'package:flutter/material.dart';

class QuitButton extends StatelessWidget {

  final VoidCallback onTapAction;

  const QuitButton({Key? key, required this.onTapAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(40.0)),
      onTap: onTapAction,
      child: const Image(image: AssetImage('assets/images/quit_button.png'),),
    );
  }
}