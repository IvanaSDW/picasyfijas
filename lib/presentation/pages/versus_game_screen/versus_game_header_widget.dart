import 'package:bulls_n_cows_reloaded/presentation/pages/versus_game_screen/versus_game_logic.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../widgets/chronometer_widget/chronometer_view.dart';
import '../../widgets/player_data_display/player_avatar.dart';

class VersusGameHeaderWidget extends StatelessWidget {
  VersusGameHeaderWidget({
    Key? key,}) : super(key: key);

  final VersusGameLogic logic = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 75,
          child: Hero(
              tag: 'avatar',
              child: PlayerAvatar(player: logic.playerOneData!),
          ),
        ),
        Center(child: ChronometerWidget(timerController: logic.p1Timer,)),
        SizedBox(
            width: 20,
            child: Image.asset('assets/images/instructions_header.png', fit: BoxFit.fitWidth,)
        ),
        Center(child: ChronometerWidget(timerController: logic.p2Timer,)),
        SizedBox(
          width: 75,
          child: Hero(
              tag: 'p2Avatar',
              child: PlayerAvatar(player: logic.playerTwoData!,)
          ),
        ),
      ],
    );
  }
}