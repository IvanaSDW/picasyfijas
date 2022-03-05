import 'package:bulls_n_cows_reloaded/presentation/pages/solo_game_screen/solo_game_logic.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/stop_watch_widget/chronometer_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../shared/theme.dart';

class SoloMatchHeader extends StatelessWidget {
  const SoloMatchHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/instructions_header.png"),
          fit: BoxFit.contain,
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(flex:65,
            child: Text('solo_mode'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Mainframe',
                color: originalColors.reverseTextColor,
              ),
            ),
          ),
          Expanded(flex: 35,
              child: ChronometerWidget(timerController: Get.find<SoloGameLogic>().timer,)
          ),
        ],
      ),
    );
  }
}