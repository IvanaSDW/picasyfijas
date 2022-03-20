import 'package:auto_size_text/auto_size_text.dart';
import 'package:bulls_n_cows_reloaded/data/models/player_stats.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/player_data_display/player_stats_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../shared/text_styles.dart';

class PlayerStatsWidget extends StatelessWidget {
  PlayerStatsWidget({Key? key,}) : super(key: key);

  final PlayerStatsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      PlayerStats? stats = controller.playerStats;
      return Column(
        // Stats
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 13,
            child: AutoSizeText(
              'solo_mode'.tr + ' (${stats.soloGamesCount} games)',
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
                Expanded(flex: 25,
                    child: AutoSizeText(
                      stats.timeAverage == double.infinity
                          ? '---'
                          : StopWatchTimer.getDisplayTime(
                          stats.timeAverage.toInt(),
                          hours: false,
                          milliSecond: false
                      ),
                      style: statsText,
                    )
                ),
                Expanded(flex: 25,
                    child: AutoSizeText(
                      'Rank: ${stats.soloGamesCount == 0 ? "--" : stats.timeRank}',
                      style: statsSubTitle,
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
                Expanded(flex: 25,
                    child: AutoSizeText(
                      stats.guessesAverage == double.infinity
                          ? '---'
                          : stats.guessesAverage.toStringAsFixed(2),
                      style: statsText,
                      textAlign: TextAlign.start,
                    )
                ),
                Expanded(flex: 25,
                    child: AutoSizeText(
                      'Rank: ${stats.soloGamesCount == 0 ? "--" : stats.guessesRank}',
                      style: statsSubTitle,
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
                      stats.soloGamesCount == 0 ? "--" : stats.soloWorldRank.toString(),
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
              'vs_mode'.tr + ' (${stats.vsGamesCount} games)',
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
                      stats.vsWinRate == double.infinity
                          ? '---'
                          : (stats.vsWinRate*100).toStringAsFixed(1),
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
                      '  ' + 'rating'.tr,
                      style: statsSubTitle,
                      textAlign: TextAlign.start,
                    )
                ),
                Expanded(flex: 25,
                    child: AutoSizeText(
                      stats.rating.toString(),
                      style: statsText,
                      textAlign: TextAlign.start,
                    )
                ),
                Expanded(flex: 25,
                    child: AutoSizeText(
                      stats.vsGamesCount == 0 ? "--" : 'Rank: ' + stats.vsWorldRank.toString(),
                      style: statsSubTitle,
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
