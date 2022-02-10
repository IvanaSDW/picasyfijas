import 'package:auto_size_text/auto_size_text.dart';
import 'package:bulls_n_cows_reloaded/shared/widgets/player_data_display/player_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import 'player_data_controller.dart';

class PlayerDataDisplay extends StatelessWidget {
  final PlayerDataDisplayController controller = Get.put(
      PlayerDataDisplayController());

  PlayerDataDisplay({Key? key, required this.onAvatarTapped}) : super(key: key);

  final Function onAvatarTapped;

  @override
  Widget build(BuildContext context) {
    final TextStyle statsTitle =
    TextStyle(color: originalColors.accentColor2, fontFamily: 'Mainframe');
    final TextStyle statsSubTitle = TextStyle(
        color: originalColors.textColorLight, fontFamily: 'Mainframe');
    final TextStyle statsText =
    TextStyle(color: originalColors.textColor3, fontFamily: 'Mainframe');

    return Obx(() => Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                flex: 26,
                child: InkWell(
                    onTap: () => onAvatarTapped(),
                    child: const PlayerAvatar()
                )
            ),
            Expanded(
                flex: 4,
                child: Container(
                  width: 1,
                )),
            Expanded(
              flex: 70,
              child: Column(
                // Stats
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 13,
                    child: AutoSizeText(
                      'solo_mode'.tr,
                      style: statsTitle,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                    flex: 13,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 50,
                            child: AutoSizeText(
                              'time_average'.tr,
                              style: statsSubTitle,
                            )),
                        Expanded(
                            flex: 50,
                            child: AutoSizeText(
                              controller.ttmTimeAverage,
                              style: statsText,
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 13,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 50,
                            child: AutoSizeText(
                              'guesses_average'.tr,
                              style: statsSubTitle,
                              textAlign: TextAlign.start,
                            )),
                        Expanded(
                            flex: 50,
                            child: AutoSizeText(
                              controller.ttmGuessAverage,
                              style: statsText,
                              textAlign: TextAlign.start,
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 13,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 50,
                            child: AutoSizeText(
                              'world_ranking'.tr,
                              style: statsSubTitle,
                              textAlign: TextAlign.start,
                            )),
                        Expanded(
                            flex: 50,
                            child: AutoSizeText(
                              controller.ttmWorldRank,
                              style: statsText,
                              textAlign: TextAlign.start,
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: Container(
                        height: 1,
                      )),
                  Expanded(
                    flex: 13,
                    child: AutoSizeText(
                      'vs_mode'.tr,
                      style: statsTitle,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                    flex: 13,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 50,
                            child: AutoSizeText(
                              'win_rate'.tr,
                              style: statsSubTitle,
                              textAlign: TextAlign.start,
                            )),
                        Expanded(
                            flex: 50,
                            child: AutoSizeText(
                              controller.vmWinRate,
                              style: statsText,
                              textAlign: TextAlign.start,
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 13,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 50,
                            child: AutoSizeText(
                              'world_ranking'.tr,
                              style: statsSubTitle,
                              textAlign: TextAlign.start,
                            )),
                        Expanded(
                            flex: 50,
                            child: AutoSizeText(
                              controller.vmWorldRank,
                              style: statsText,
                              textAlign: TextAlign.start,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
    );
  }
}


