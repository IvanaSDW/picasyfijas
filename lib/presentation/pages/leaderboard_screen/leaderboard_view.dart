import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../shared/text_styles.dart';
import '../../../shared/theme.dart';
import 'leaderboard_controller.dart';

class LeaderBoardView extends StatelessWidget {
  LeaderBoardView({Key? key}) : super(key: key);

  final LeaderboardController controller = Get.put(LeaderboardController());

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.black,
        child: FutureBuilder(
          future: controller.refreshLeaderboard(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
            ? const SpinKitDancingSquare(color: Colors.lightGreen,)
            : Column(
              children: [
                Expanded(flex: 26, // Podium
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: RadialGradient(
                              colors: [
                                originalColors.reverseTextBg!,
                                originalColors.keyOffColor!,
                              ]
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //Second player
                            Expanded(
                              flex: 33,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Expanded(flex: 12,
                                      child: SizedBox.shrink()
                                  ),
                                  Expanded(flex: 12,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: AutoSizeText(
                                        '2',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 18, color: originalColors.textColorLight),
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 41,
                                    child: Stack(alignment: Alignment.center,
                                      children: [
                                        Center(
                                          child: ClipOval(
                                            child: controller.leaderboard.isEmpty
                                                ? const SpinKitCircle(color: Colors.white,)
                                                : controller.leaderboard[1].photoUrl != null
                                                ? FadeInImage.assetNetwork(
                                              placeholder: 'assets/images/profile_avatar_bg.png',
                                              image:controller.leaderboard[1].photoUrl!, fit: BoxFit.contain,
                                            )
                                                : const SizedBox.shrink(),
                                          ),
                                        ),
                                        Positioned(top: 0.0, left: 12.0,
                                          child: SizedBox(
                                              width: 32,
                                              child: Image.asset(
                                                  'icons/flags/png/${controller.leaderboard[1].countryCode}.png',
                                                  package: 'country_icons')
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(flex: 15,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: controller.leaderboard.isEmpty
                                          ? const SpinKitWave(color: Colors.white, size: 12)
                                          : AutoSizeText(
                                        controller.leaderboard[1].rating.toString(),
                                        style: leaderBoardSecondRatingStyle,
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 10,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: controller.leaderboard.isEmpty
                                          ? const SpinKitWave(color: Colors.white, size: 14)
                                          : controller.leaderboard[1].name == null
                                          ? const SpinKitThreeBounce(
                                        color: Colors.white,
                                        size: 14,
                                      )
                                          : AutoSizeText(
                                        controller.leaderboard[1].name!.length > 10
                                            ? controller.leaderboard[1].name!.substring(0,10)
                                            : controller.leaderboard[1].name!,
                                        maxLines: 1,
                                        style: leaderPodiumNameStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const Expanded(flex: 10,
                                      child: SizedBox.shrink()
                                  ),
                                ],
                              ),
                            ),
                            //First player
                            Expanded(flex: 33,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(flex: 15,
                                      child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Image.asset('assets/images/crown.png', color: originalColors.accentColor2, fit: BoxFit.cover,)
                                      )
                                  ),
                                  Expanded(flex: 60,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Image.asset('assets/images/profile_avatar_bg.png'),
                                        ClipOval(
                                          child: controller.leaderboard.isEmpty
                                              ? const SpinKitCircle(color: Colors.white,)
                                              : controller.leaderboard.first.photoUrl != null
                                              ? FadeInImage.assetNetwork(
                                            placeholder: 'assets/images/profile_avatar_bg.png',
                                            image:controller.leaderboard.first.photoUrl!, fit: BoxFit.contain,
                                          )
                                              : const SizedBox.shrink(),
                                        ),
                                        Positioned(top: 0.0,
                                          child: SizedBox(
                                              width: 32,
                                              child: Image.asset(
                                                  'icons/flags/png/${controller.leaderboard.first.countryCode}.png',
                                                  package: 'country_icons')
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(flex: 15,
                                    child: controller.leaderboard.isEmpty
                                        ? const SpinKitWave(color: Colors.white, size: 12)
                                        : AutoSizeText(
                                      controller.leaderboard.first.rating.toString(),
                                      style: leaderBoardKingRatingStyle,
                                    ),
                                  ),
                                  Expanded(flex: 10,
                                    child: controller.leaderboard.isEmpty
                                        ? const SpinKitWave(color: Colors.white, size: 14)
                                        : controller.leaderboard.first.name == null
                                        ? const SpinKitThreeBounce(
                                      color: Colors.white,
                                      size: 14,
                                    )
                                        : AutoSizeText(
                                      controller.leaderboard.first.name!.length > 10
                                          ? controller.leaderboard.first.name!.substring(0,10)
                                          : controller.leaderboard.first.name!,
                                      maxLines: 1,
                                      style: leaderPodiumNameStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Third player
                            Expanded(
                              flex: 33,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Expanded(flex: 12,
                                      child: SizedBox.shrink()
                                  ),
                                  Expanded(flex: 12,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: AutoSizeText(
                                        '3',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 16, color: originalColors.textColorLight),
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 41,
                                    child: Stack(alignment: Alignment.center,
                                      children: [
                                        Center(
                                          child: ClipOval(
                                            child: controller.leaderboard.isEmpty
                                                ? const SpinKitCircle(color: Colors.white,)
                                                : controller.leaderboard[2].photoUrl != null
                                                ? FadeInImage.assetNetwork(
                                              placeholder: 'assets/images/profile_avatar_bg.png',
                                              image:controller.leaderboard[2].photoUrl!, fit: BoxFit.contain,
                                            )
                                                : const SizedBox.shrink(),
                                          ),
                                        ),
                                        Positioned(top: 0.0, right: 12.0,
                                          child: SizedBox(
                                              width: 32,
                                              child: Image.asset(
                                                  'icons/flags/png/${controller.leaderboard[2].countryCode}.png',
                                                  package: 'country_icons')
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(flex: 15,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: controller.leaderboard.isEmpty
                                          ? const SpinKitWave(color: Colors.white, size: 12)
                                          : AutoSizeText(
                                        controller.leaderboard[2].rating.toString(),
                                        style: leaderBoardSecondRatingStyle,
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 10,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: controller.leaderboard.isEmpty
                                          ? const SpinKitWave(color: Colors.white, size: 14)
                                          : controller.leaderboard[2].name == null
                                          ? const SpinKitThreeBounce(
                                        color: Colors.white,
                                        size: 14,
                                      )
                                          : AutoSizeText(
                                        controller.leaderboard[2].name!.length > 10
                                            ? controller.leaderboard[2].name!.substring(0,10)
                                            : controller.leaderboard[2].name!,
                                        maxLines: 1,
                                        style: leaderPodiumNameStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const Expanded(flex: 10,
                                      child: SizedBox.shrink()
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ),
                Expanded(flex: 4,
                  child: Container(
                    padding: const EdgeInsets.only(left: 8.0, right: 12.0, top: 3.0,),
                    color: originalColors.playerOneBackground,
                    child: Row(
                      children: [
                        Expanded(flex: 10,
                          child: InkWell(
                            child: Icon(Icons.arrow_back_ios, color: originalColors.accentColor2,),
                            onTap: () => Get.back(),
                          ),
                        ),
                        Expanded(flex: 80,
                          child: AutoSizeText(
                            'leaderboard_title'.tr,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: leaderboardTitleStyle,
                          ),
                        ),
                        const Spacer(flex: 10,),
                      ],
                    ),
                  ),
                ),
                Expanded(flex: controller.isBottomBannerAdLoaded ? 54 : 74, // Leaderboard listview
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/leaderboard_grid.png',
                          ),
                          fit: BoxFit.fill
                      ),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.only(top: 12, left: 12.0, right: 12.0, bottom: 12 ),
                        child: controller.leaderboard.isEmpty
                            ? const Center(
                          child: SpinKitCubeGrid(color: Colors.white,),
                        )
                            : ListView.builder(
                            itemCount: controller.leaderboard.length-3,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: LeaderboardItem(controller: controller, index: index,)
                              );
                            }
                        )
                    ),
                  ),
                ),
                // Ads area
                controller.isBottomBannerAdLoaded
                    ? Expanded(flex: 16,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF4E524E).withOpacity(0.2),
                              const Color(0xFF899288).withOpacity(0.2),
                              const Color(0xFFA9B8A8).withOpacity(0.2),
                              const Color(0xFFBACEB8).withOpacity(0.2),
                              const Color(0xFF939E92).withOpacity(0.2),
                              const Color(0xFF818B81).withOpacity(0.2),
                              const Color(0xFF5C615C).withOpacity(0.2),
                              const Color(0xFF424442).withOpacity(0.2),
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
                )
                    : const SizedBox.shrink(),
              ],
            );
          }
        )
    );
  }
}

class LeaderboardItem extends StatelessWidget {
  final LeaderboardController controller;
  final int index;

  const LeaderboardItem({Key? key, required this.controller, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: Row(
        children: [
          Expanded(flex: 7,
            child: AutoSizeText(
              '${index+4}. ',
              style: leaderboardItemStyle,
            ),
          ),
          Expanded(flex:16,
            child: controller.leaderboard[index+3].photoUrl == null
                ? Image.asset('assets/images/user_photo_bg.png')
                : FadeInImage.assetNetwork(
              image: controller.leaderboard[index+3].photoUrl!,
              placeholder: 'assets/images/user_photo_bg.png',
            ),
          ),
          const Spacer(flex: 5,),
          Expanded(
            flex: 49,
            child: AutoSizeText(
              controller.leaderboard[index+3].name!,
              style: leaderboardItemStyle,
            ),
          ),
          Expanded(flex: 5,
            child: Image.asset(
                'icons/flags/png/${controller.leaderboard[index+3].countryCode}.png',
                package: 'country_icons'),
          ),
          Expanded(
            flex: 18,
            child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(
                controller.leaderboard[index+3].rating!.toString(),
                style: defaultTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

}




