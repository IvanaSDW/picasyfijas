import 'package:bulls_n_cows_reloaded/view/home_screen/solo_match_button.dart';
import 'package:bulls_n_cows_reloaded/view/home_screen/vs_match_button.dart';
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
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/key_pad_home.png',),
              fit: BoxFit.contain
          ),
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

