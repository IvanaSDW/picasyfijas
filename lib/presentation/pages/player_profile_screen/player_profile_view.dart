import 'package:auto_size_text/auto_size_text.dart';
import 'package:bulls_n_cows_reloaded/data/models/player_stats.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/player_profile_screen/player_profile_controller.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/player_data_display/player_stats_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/chronometer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../shared/constants.dart';
import '../../../shared/text_styles.dart';
import '../../../shared/theme.dart';

class PlayerProfileView extends StatelessWidget {
  PlayerProfileView({Key? key}) : super(key: key);

  final PlayerProfileController controller = Get.put(PlayerProfileController());
  final PlayerStats stats = Get.find<PlayerStatsController>().playerStats;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Obx(() {
        return Column(
          children: [
            Expanded(flex: 25, // Avatar
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset('assets/images/profile_avatar_bg.png'),
                        ClipOval(
                          child: appController.currentPlayer.photoUrl != null
                              ? FadeInImage.assetNetwork(
                            placeholder: 'assets/images/profile_avatar_bg.png',
                            image: appController.currentPlayer.photoUrl!, fit: BoxFit.contain,
                          )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    appController.currentPlayer.name == null
                        ? const SpinKitThreeBounce(
                      color: Colors.white,
                      size: 14,
                    )
                        : AutoSizeText(
                      appController.currentPlayer.name!,
                      maxLines: 2,
                      style: profilePlayerStatsSubTitleKeyStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10,),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          'Rating: ',
                          style: playerProfileAccentTitle,
                        ),
                        AutoSizeText(
                          stats.rating.toString(),
                          style: profilePlayerWhiteTextStyle,
                        ),
                      ],
                    ),
                  ],
                )
            ),
            Expanded(flex: 55, // Stats
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/profile_grid.png',
                          ),
                          fit: BoxFit.fill
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24, left: 12.0, right: 12.0, bottom: 12 ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              AutoSizeText(
                                'email_'.tr,
                                style: profilePlayerDataKeyStyle,
                              ),
                              Text('=> ', style: profilePlayerDataKeyStyle,),
                              Expanded(
                                  child: AutoSizeText(
                                    appController.currentPlayer.email ?? '--',
                                    maxLines: 1,
                                    style: profilePlayerDataValueStyle,
                                  )
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              AutoSizeText(
                                'country_'.tr,
                                style: profilePlayerDataKeyStyle,
                              ),
                              Text('=> ', style: profilePlayerDataKeyStyle,),
                              Flexible(
                                  child: controller.country == null
                                      ? const SpinKitThreeBounce(color: Colors.white, size: 20,)
                                      : AutoSizeText(
                                    controller.country!.name! + ' ',
                                    maxLines: 1,
                                    style: profilePlayerDataValueStyle,
                                  )
                              ),
                              Flexible(
                                  child: SizedBox(
                                      width: 32,
                                      child: Image.asset(
                                          'icons/flags/png/${appController.currentPlayer.countryCode}.png',
                                          package: 'country_icons')
                                  )
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              AutoSizeText(
                                'member_since_'.tr,
                                style: profilePlayerDataKeyStyle,
                              ),
                              Text('=> ', style: profilePlayerDataKeyStyle,),
                              Flexible(
                                  child: AutoSizeText(
                                    '' + (Get.locale.toString().split('_').first == 'es'
                                        ? monthsSpa[appController.currentPlayer.createdAt!.month - 1]
                                        : monthsEng[appController.currentPlayer.createdAt!.month - 1]) + ' ' +
                                        appController.currentPlayer.createdAt!.day.toString() + ', ' +
                                        appController.currentPlayer.createdAt!.year.toString(),
                                    maxLines: 1,
                                    style: profilePlayerDataValueStyle,
                                  )
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              AutoSizeText(
                                'total_games_'.tr,
                                style: profilePlayerDataKeyStyle,
                              ),
                              Text('=> ', style: profilePlayerDataKeyStyle,),
                              Flexible(
                                  child: AutoSizeText(
                                    (stats.vsGamesCount + stats.soloGamesCount).toString(),
                                    maxLines: 1,
                                    style: profilePlayerDataValueStyle,
                                  )
                              ),
                            ],
                          ),
                          const SizedBox(height: 6,),
                          Row(
                            children: [
                              AutoSizeText(
                                'solo_mode'.tr + ' ',
                                style: playerProfileAccentTitle,
                              ),
                              const Text('=> ', style: profilePlayerWhiteTextStyle,),
                              AutoSizeText(
                                stats.soloGamesCount.toString() + '_games'.tr,
                                style: profilePlayerWhiteTextStyle,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              AutoSizeText(
                                'time_average'.tr + ': ',
                                style: profilePlayerWhiteTextStyle,
                              ),
                              AutoSizeText(
                                stats.timeAverage == double.infinity
                                    ? '--' : Chronometer.getDisplayTime(stats.timeAverage.toDouble().toInt(), hours: false, milliSecond: false),
                                style: profilePlayerWhiteTextStyle,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              AutoSizeText(
                                'guesses_average'.tr + ': ',
                                style: profilePlayerWhiteTextStyle,
                              ),
                              AutoSizeText(
                                stats.guessesAverage.toStringAsFixed(1),
                                style: profilePlayerWhiteTextStyle,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              AutoSizeText(
                                'world_ranking'.tr + ': ',
                                style: profilePlayerWhiteTextStyle,
                              ),
                              AutoSizeText(
                                stats.soloWorldRank.toString(),
                                style: profilePlayerWhiteTextStyle,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6,),
                          Row(
                            children: [
                              AutoSizeText(
                                'vs_mode'.tr + ' ',
                                style: playerProfileAccentTitle,
                              ),
                              const Text('=> ', style: profilePlayerWhiteTextStyle,),
                              AutoSizeText(
                                '${stats.vsGamesCount}' + '_games'.tr,
                                style: profilePlayerWhiteTextStyle,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              AutoSizeText(
                                '  ' + 'won:_'.tr,
                                style: profilePlayerWhiteTextStyle,
                              ),
                              AutoSizeText(
                                stats.vsGamesWon.toString() + ', ',
                                style: profilePlayerWhiteTextStyle,
                              ),
                              AutoSizeText(
                                'draw:_'.tr,
                                style: profilePlayerWhiteTextStyle,
                              ),
                              AutoSizeText(
                                stats.vsGamesDraw.toString() + ', ',
                                style: profilePlayerWhiteTextStyle,
                              ),
                              AutoSizeText(
                                'lost:_'.tr,
                                style: profilePlayerWhiteTextStyle,
                              ),
                              AutoSizeText(
                                stats.vsGamesLost.toString(),
                                style: profilePlayerWhiteTextStyle,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              AutoSizeText(
                                'win_rate'.tr + ': ',
                                style: profilePlayerWhiteTextStyle,
                              ),
                              AutoSizeText(
                                (stats.vsWinRate *100).toStringAsFixed(1) + '%',
                                style: profilePlayerWhiteTextStyle,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              AutoSizeText(
                                'world_ranking'.tr + ': ',
                                style: profilePlayerWhiteTextStyle,
                              ),
                              AutoSizeText(
                                stats.vsWorldRank.toString(),
                                style: profilePlayerWhiteTextStyle,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              AutoSizeText(
                                '__percentile:_'.tr,
                                style: profilePlayerWhiteTextStyle,
                              ),
                              AutoSizeText(
                                (stats.vsPercentile*100).toStringAsFixed(1),
                                style: profilePlayerWhiteTextStyle,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6.0,),
                          // const Expanded(child: SizedBox.shrink(),),
                        ],
                      ),
                    ),
                  ),
                  Positioned(right: 10.0, top: 3.0,
                    child: InkWell(
                      child: Row(
                        children: [
                          Get.find<PlayerStatsController>().isSyncing
                              ? const SizedBox(height: 18, width: 18, child: SpinKitDualRing(color: Colors.white, size: 18,))
                              : Icon(Icons.sync_outlined, color: appController.needUpdateVsStats.value || appController.needUpdateSoloStats.value
                              ? Colors.white : originalColors.screenColor,),
                          const SizedBox(width: 6,),
                          Text('refresh_stats'.tr,
                            style: TextStyle(color: appController.needUpdateVsStats.value || appController.needUpdateSoloStats.value
                                ? originalColors.keyOnColor : originalColors.screenColor),),
                        ],
                      ),
                      onTap: () async {await Get.find<PlayerStatsController>().refreshStats(auth.currentUser!.uid);},
                    ),
                  ),
                ],
              ),
            ),
            Expanded(flex: 20,
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF4E524E),
                          Color(0xFF899288),
                          Color(0xFFA9B8A8),
                          Color(0xFFBACEB8),
                          Color(0xFF939E92),
                          Color(0xFF818B81),
                          Color(0xFF5C615C),
                          Color(0xFF424442),
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: AdWidget(ad: controller.bottomBannerAd),
                  ),
                )
            ),
          ],
        );
      }),
    );
  }
}