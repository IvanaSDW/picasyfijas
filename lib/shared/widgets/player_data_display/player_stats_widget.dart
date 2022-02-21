import 'package:auto_size_text/auto_size_text.dart';
import 'package:bulls_n_cows_reloaded/model/player_solo_stats.dart';
import 'package:bulls_n_cows_reloaded/shared/widgets/player_data_display/player_stats_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../text_styles.dart';

class PlayerStatsWidget extends StatelessWidget {
  PlayerStatsWidget({Key? key,}) : super(key: key);

  final PlayerStatsController controller = Get.put(
      PlayerStatsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      PlayerSoloStats? stats = controller.playerSoloStats;
      return Column(
        // Stats
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 13,
            child: AutoSizeText(
              'solo_mode'.tr + ' (${stats?.qtyMatches} games)',
              style: statsTitle,
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(flex: 13,
            child: Row(
              children: [
                Expanded(flex: 50,
                    child: AutoSizeText(
                      'time_average'.tr,
                      style: statsSubTitle,
                    )
                ),
                Expanded(flex: 50,
                    child: stats == null
                        ? const SpinKitThreeBounce(color: Colors.white, size: 14,)
                        : AutoSizeText(
                      StopWatchTimer.getDisplayTime(
                          stats.timeAverage.toInt(),
                          hours: false,
                          milliSecond: false
                      ),
                      style: statsText,
                    )
                ),
              ],
            ),
          ),
          Expanded(flex: 13,
            child: Row(
              children: [
                Expanded(flex: 50,
                    child: AutoSizeText(
                      'guesses_average'.tr,
                      style: statsSubTitle,
                      textAlign: TextAlign.start,
                    )
                ),
                Expanded(flex: 50,
                    child: stats == null
                        ? const SpinKitThreeBounce(color: Colors.white, size: 14,)
                        : AutoSizeText(
                      stats.guessesAverage.toStringAsFixed(2),
                      style: statsText,
                      textAlign: TextAlign.start,
                    )
                ),
              ],
            ),
          ),
          Expanded(flex: 13,
            child: Row(
              children: [
                Expanded(flex: 50,
                    child: AutoSizeText(
                      'world_ranking'.tr,
                      style: statsSubTitle,
                      textAlign: TextAlign.start,
                    )
                ),
                Expanded(flex: 50,
                    child: stats == null
                        ? const SpinKitThreeBounce(color: Colors.white, size: 14)
                        : AutoSizeText(
                      stats.soloWorldRanking.toString(),
                      style: statsText,
                      textAlign: TextAlign.start,
                    )
                ),
              ],
            ),
          ),
          const Spacer(flex: 5,),
          Expanded(
            flex: 13,
            child: AutoSizeText(
              'vs_mode'.tr,
              style: statsTitle,
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(flex: 13,
            child: Row(
              children: [
                Expanded(
                    flex: 50,
                    child: AutoSizeText(
                      'win_rate'.tr,
                      style: statsSubTitle,
                      textAlign: TextAlign.start,
                    )),
                Expanded(flex: 50,
                    child: AutoSizeText(
                      'requires_google'.tr,
                      style: statsText,
                      textAlign: TextAlign.start,
                    )
                ),
              ],
            ),
          ),
          Expanded(flex: 13,
            child: Row(
              children: [
                Expanded(flex: 50,
                    child: AutoSizeText(
                      'world_ranking'.tr,
                      style: statsSubTitle,
                      textAlign: TextAlign.start,
                    )
                ),
                Expanded(flex: 50,
                    child: AutoSizeText(
                      'requires_google'.tr,
                      style: statsText,
                      textAlign: TextAlign.start,
                    )
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
