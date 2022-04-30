import 'package:auto_size_text/auto_size_text.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/versus_game_screen/versus_game_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../../shared/text_styles.dart';
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
            child: PlayerAvatar(player: logic.playerOneData!, isP1: true,),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ChronometerWidget(timerController: logic.p1Timer,),
            const SizedBox(height: 6.0,),
            logic.playerOneData!.rating == null
                ? const SpinKitThreeBounce(
              color: Colors.white,
              size: 14,
            )
                : AutoSizeText(
              logic.playerOneData!.isRated!
                  ? logic.playerOneData!.rating!.toString()
                  : logic.playerOneData!.rating!.toString() + '?',
              style: statsText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        SizedBox(
            width: 20,
            child: Image.asset('assets/images/instructions_header.png', fit: BoxFit.fitWidth,)
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChronometerWidget(timerController: logic.p2Timer,),
            const SizedBox(height: 6.0,),
            logic.playerOneData!.rating == null
                ? const SpinKitThreeBounce(
              color: Colors.white,
              size: 14,
            )
                : AutoSizeText(
              logic.playerTwoData!.isRated!
                  ? logic.playerTwoData!.rating!.toString()
                  : logic.playerTwoData!.rating!.toString() + '?',
              style: statsText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        SizedBox(
          width: 75,
          child: Hero(
              tag: 'p2Avatar',
              child: PlayerAvatar(player: logic.playerTwoData!, isP1: false,)
          ),
        ),
      ],
    );
  }
}