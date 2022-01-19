import 'package:bulls_n_cows_reloaded/view/first_run_view/instructions_widget.dart';
import 'package:flutter/material.dart';

class FirstRunScreen extends StatelessWidget {
  const FirstRunScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InstructionsWidget(onContinueTappedAction: (){})
    );
  }
}
