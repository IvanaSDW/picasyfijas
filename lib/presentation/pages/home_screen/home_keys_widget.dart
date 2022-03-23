import 'package:bulls_n_cows_reloaded/presentation/pages/home_screen/solo_match_button.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/home_screen/vs_match_button.dart';
import 'package:flutter/cupertino.dart';
import 'home_controller.dart';

class HomeKeysWidget extends StatelessWidget {
  const HomeKeysWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/key_pad_home.png',)
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SoloMatchButton(),
            VersusMatchButton(),
          ],
        )
    );
  }
}

