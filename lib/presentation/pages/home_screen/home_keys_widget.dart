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
    return Stack(
      alignment: Alignment.center,
      children: [
        Hero(tag: 'home_pad',
            child: Image.asset('assets/images/key_pad_home.png')
        ),
        Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SoloMatchButton(),
                VersusMatchButton(),
              ],
            )
        ),
      ],
    );
  }
}

