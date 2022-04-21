import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../data/models/player.dart';
import '../../../shared/chronometer.dart';
import '../../../shared/constants.dart';
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
            future: controller.refreshVsLeaderboard(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? const SpinKitDancingSquare(color: Colors.lightGreen,)
                  : Obx(() {
                return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: controller.showVersus //Versus Mode
                        ? Column(
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
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: [
                                    //Second player
                                    Expanded(flex: 33,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          const Expanded(flex: 12,
                                              child: SizedBox.shrink()
                                          ),
                                          Expanded(flex: 12,
                                            child: Align(
                                              alignment: Alignment
                                                  .bottomCenter,
                                              child: AutoSizeText(
                                                '2',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 18,
                                                    color: originalColors
                                                        .textColorLight),
                                              ),
                                            ),
                                          ),
                                          Expanded(flex: 41,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Center(
                                                  child: ClipOval(
                                                    child: controller.vsLeaderboard.isEmpty
                                                        ? const SpinKitCircle(color: Colors.white,)
                                                        : controller.vsLeaderboard[1].photoUrl != null
                                                        ? FadeInImage.assetNetwork(
                                                      placeholder: 'assets/images/user_photo_bg.png',
                                                      image: controller.vsLeaderboard[1].addedAvatarsUrls != null
                                                          ? controller.vsLeaderboard[1].addedAvatarsUrls!.isNotEmpty
                                                          ? controller.vsLeaderboard[1].addedAvatarsUrls!.last
                                                          : appController.hasInterNetConnection.value
                                                          ? controller.vsLeaderboard[1].photoUrl!.replaceAll("s96-c", "s192-c")
                                                          : controller.vsLeaderboard[1].photoUrl!
                                                          : appController.hasInterNetConnection.value
                                                          ? controller.vsLeaderboard[1].photoUrl!.replaceAll("s96-c", "s192-c")
                                                          : controller.vsLeaderboard[1].photoUrl!, fit: BoxFit.cover,
                                                    )
                                                        : const Image(
                                                        image: AssetImage('assets/images/user_photo_bg.png')
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0.0, left: 12.0,
                                                  child: SizedBox(
                                                      width: 32,
                                                      child: Image.asset(
                                                          'icons/flags/png/${controller
                                                              .vsLeaderboard[1]
                                                              .countryCode}.png',
                                                          package: 'country_icons')
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(flex: 15,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: controller.vsLeaderboard
                                                  .isEmpty
                                                  ? const SpinKitWave(
                                                  color: Colors.white,
                                                  size: 12)
                                                  : AutoSizeText(
                                                controller.vsLeaderboard[1]
                                                    .rating
                                                    .toString(),
                                                style: leaderBoardSecondRatingStyle,
                                              ),
                                            ),
                                          ),
                                          Expanded(flex: 10,
                                            child: Align(
                                              alignment: Alignment
                                                  .bottomCenter,
                                              child: controller.vsLeaderboard
                                                  .isEmpty
                                                  ? const SpinKitWave(
                                                  color: Colors.white,
                                                  size: 14)
                                                  : controller
                                                  .vsLeaderboard[1]
                                                  .name == null
                                                  ? const SpinKitThreeBounce(
                                                color: Colors.white,
                                                size: 14,
                                              )
                                                  : AutoSizeText(
                                                controller.vsLeaderboard[1].nickName != null
                                                    ? controller.vsLeaderboard[1].nickName!
                                                    : controller.vsLeaderboard[1].name!.length > 10
                                                    ? controller.vsLeaderboard[1].name!.substring(0, 10)
                                                    : controller.vsLeaderboard[1].name!,
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
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          Expanded(flex: 15,
                                              child: Align(
                                                  alignment: Alignment
                                                      .bottomCenter,
                                                  child: Image.asset(
                                                    'assets/images/crown.png',
                                                    color: originalColors
                                                        .accentColor2,
                                                    fit: BoxFit.cover,)
                                              )
                                          ),
                                          Expanded(flex: 60,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                // Image.asset('assets/images/profile_avatar_bg.png'),
                                                ClipOval(
                                                  child: controller.vsLeaderboard.isEmpty
                                                      ? const SpinKitCircle(color: Colors.white,)
                                                      : controller.vsLeaderboard.first.photoUrl != null
                                                      ? FadeInImage.assetNetwork(
                                                    placeholder: 'assets/images/user_photo_bg.png',
                                                    image: controller.vsLeaderboard.first.addedAvatarsUrls != null
                                                        ? controller.vsLeaderboard.first.addedAvatarsUrls!.isNotEmpty
                                                        ? controller.vsLeaderboard.first.addedAvatarsUrls!.last
                                                        : appController.hasInterNetConnection.value
                                                        ? controller.vsLeaderboard.first.photoUrl!.replaceAll("s96-c", "s192-c")
                                                        : controller.vsLeaderboard.first.photoUrl!
                                                        : appController.hasInterNetConnection.value
                                                        ? controller.vsLeaderboard.first.photoUrl!.replaceAll("s96-c", "s192-c")
                                                        : controller.vsLeaderboard.first.photoUrl!, fit: BoxFit.cover,
                                                  )
                                                      : const Image(
                                                      image: AssetImage('assets/images/user_photo_bg.png')
                                                  ),
                                                ),
                                                Positioned(top: 0.0,
                                                  child: SizedBox(
                                                      width: 32,
                                                      child: Image.asset(
                                                          'icons/flags/png/${controller
                                                              .vsLeaderboard
                                                              .first
                                                              .countryCode}.png',
                                                          package: 'country_icons')
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(flex: 15,
                                            child: controller.vsLeaderboard
                                                .isEmpty
                                                ? const SpinKitWave(
                                                color: Colors.white, size: 12)
                                                : AutoSizeText(
                                              controller.vsLeaderboard.first
                                                  .rating.toString(),
                                              style: leaderBoardKingRatingStyle,
                                            ),
                                          ),
                                          Expanded(flex: 10,
                                            child: controller.vsLeaderboard
                                                .isEmpty
                                                ? const SpinKitWave(
                                                color: Colors.white, size: 14)
                                                : controller.vsLeaderboard
                                                .first
                                                .name == null
                                                ? const SpinKitThreeBounce(
                                              color: Colors.white,
                                              size: 14,
                                            )
                                                : AutoSizeText(
                                              controller.vsLeaderboard.first.nickName != null
                                                  ? controller.vsLeaderboard.first.nickName!
                                                  : controller.vsLeaderboard.first.name!.length > 10
                                                  ? controller.vsLeaderboard.first.name!.substring(0, 10)
                                                  : controller.vsLeaderboard.first.name!,
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
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          const Expanded(flex: 12,
                                              child: SizedBox.shrink()
                                          ),
                                          Expanded(flex: 12,
                                            child: Align(
                                              alignment: Alignment
                                                  .bottomCenter,
                                              child: AutoSizeText(
                                                '3',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 16,
                                                    color: originalColors
                                                        .textColorLight),
                                              ),
                                            ),
                                          ),
                                          Expanded(flex: 41,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Center(
                                                  child: ClipOval(
                                                    child: controller.vsLeaderboard.isEmpty
                                                        ? const SpinKitCircle(color: Colors.white,)
                                                        : controller.vsLeaderboard[2].photoUrl != null
                                                        ? FadeInImage.assetNetwork(
                                                      placeholder: 'assets/images/user_photo_bg.png',
                                                      image: controller.vsLeaderboard[2].addedAvatarsUrls != null
                                                          ? controller.vsLeaderboard[2].addedAvatarsUrls!.isNotEmpty
                                                          ? controller.vsLeaderboard[2].addedAvatarsUrls!.last
                                                          : appController.hasInterNetConnection.value
                                                          ? controller.vsLeaderboard[2].photoUrl!.replaceAll("s96-c", "s192-c")
                                                          : controller.vsLeaderboard[2].photoUrl!
                                                          : appController.hasInterNetConnection.value
                                                          ? controller.vsLeaderboard[2].photoUrl!.replaceAll("s96-c", "s192-c")
                                                          : controller.vsLeaderboard[2].photoUrl!, fit: BoxFit.cover,
                                                    )
                                                        : const Image(
                                                        image: AssetImage('assets/images/user_photo_bg.png')
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0.0, right: 12.0,
                                                  child: SizedBox(
                                                      width: 32,
                                                      child: Image.asset(
                                                          'icons/flags/png/${controller
                                                              .vsLeaderboard[2]
                                                              .countryCode}.png',
                                                          package: 'country_icons')
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(flex: 15,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: controller.vsLeaderboard
                                                  .isEmpty
                                                  ? const SpinKitWave(
                                                  color: Colors.white,
                                                  size: 12)
                                                  : AutoSizeText(
                                                controller.vsLeaderboard[2]
                                                    .rating
                                                    .toString(),
                                                style: leaderBoardSecondRatingStyle,
                                              ),
                                            ),
                                          ),
                                          Expanded(flex: 10,
                                            child: Align(
                                              alignment: Alignment
                                                  .bottomCenter,
                                              child: controller.vsLeaderboard
                                                  .isEmpty
                                                  ? const SpinKitWave(
                                                  color: Colors.white,
                                                  size: 14)
                                                  : controller
                                                  .vsLeaderboard[2]
                                                  .name == null
                                                  ? const SpinKitThreeBounce(
                                                color: Colors.white,
                                                size: 14,
                                              )
                                                  : AutoSizeText(
                                                controller.vsLeaderboard[2].nickName != null
                                                    ? controller.vsLeaderboard[2].nickName!
                                                    : controller.vsLeaderboard[2].name!.length > 10
                                                    ? controller.vsLeaderboard[2].name!.substring(0, 10)
                                                    : controller.vsLeaderboard[2].name!,
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
                        Expanded(flex: 6,
                          child: Hero(tag: 'tabBar',
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(flex: 42,
                                  child: InkWell(
                                    onTap: () => controller.showVersus = true,
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: controller.showVersus
                                          ? originalColors
                                          .playerOneBackground
                                          : originalColors
                                          .playerTwoBackground,
                                      child: AutoSizeText(
                                        'vs_mode'.tr,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: leaderboardTitleStyle,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(flex: 42,
                                  child: InkWell(
                                    onTap: () =>
                                    controller.showVersus = false,
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: controller.showVersus
                                          ? originalColors
                                          .playerTwoBackground
                                          : originalColors
                                          .playerOneBackground,
                                      child: AutoSizeText(
                                        'solo_mode'.tr,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: leaderboardTitleStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(flex: controller.isBottomBannerAdLoaded ? 52 : 72,
                          // Leaderboard listview
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/leaderboard_grid.png',
                                  ),
                                  fit: BoxFit.fill
                              ),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 12,
                                    left: 12.0,
                                    right: 12.0,
                                    bottom: 12),
                                child: controller.vsLeaderboard.isEmpty
                                    ? const Center(
                                  child: SpinKitCubeGrid(
                                    color: Colors.white,),
                                )
                                    : ListView.builder(
                                    itemCount: controller.vsLeaderboard
                                        .length -
                                        3,
                                    itemBuilder: (BuildContext context,
                                        int index) {
                                      return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: VersusLeaderboardItem(
                                            leaderboard: controller.vsLeaderboard,
                                            index: index,)
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
                                      const Color(0xFF4E524E).withOpacity(
                                          0.2),
                                      const Color(0xFF899288).withOpacity(
                                          0.2),
                                      const Color(0xFFA9B8A8).withOpacity(
                                          0.2),
                                      const Color(0xFFBACEB8).withOpacity(
                                          0.2),
                                      const Color(0xFF939E92).withOpacity(
                                          0.2),
                                      const Color(0xFF818B81).withOpacity(
                                          0.2),
                                      const Color(0xFF5C615C).withOpacity(
                                          0.2),
                                      const Color(0xFF424442).withOpacity(
                                          0.2),
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: AdWidget(
                                    ad: controller.bottomBannerAd),
                              ),
                            )
                        )
                            : const SizedBox.shrink(),
                      ],
                    )
                    // Solo mode
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
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: [
                                    //Second player
                                    Expanded(flex: 33,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          const Expanded(flex: 12,
                                              child: SizedBox.shrink()
                                          ),
                                          Expanded(flex: 12,
                                            child: Align(
                                              alignment: Alignment
                                                  .bottomCenter,
                                              child: AutoSizeText(
                                                '2',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 18,
                                                    color: originalColors
                                                        .textColorLight),
                                              ),
                                            ),
                                          ),
                                          Expanded(flex: 41,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Center(
                                                  child: ClipOval(
                                                    child: controller.soloLeaderboard.isEmpty
                                                        ? const SpinKitCircle(color: Colors.white,)
                                                        : controller.soloLeaderboard[1].photoUrl != null
                                                        ? FadeInImage.assetNetwork(
                                                      placeholder: 'assets/images/user_photo_bg.png',
                                                      image: controller.soloLeaderboard[1].addedAvatarsUrls != null
                                                          ? controller.soloLeaderboard[1].addedAvatarsUrls!.isNotEmpty
                                                          ? controller.soloLeaderboard[1].addedAvatarsUrls!.last
                                                          : appController.hasInterNetConnection.value
                                                          ? controller.soloLeaderboard[1].photoUrl!.replaceAll("s96-c", "s192-c")
                                                          : controller.soloLeaderboard[1].photoUrl!
                                                          : appController.hasInterNetConnection.value
                                                          ? controller.soloLeaderboard[1].photoUrl!.replaceAll("s96-c", "s192-c")
                                                          : controller.soloLeaderboard[1].photoUrl!, fit: BoxFit.cover,
                                                    )
                                                        : const Image(
                                                        image: AssetImage('assets/images/user_photo_bg.png')
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0.0, left: 12.0,
                                                  child: SizedBox(
                                                      width: 32,
                                                      child: Image.asset(
                                                          'icons/flags/png/${controller
                                                              .soloLeaderboard[1]
                                                              .countryCode}.png',
                                                          package: 'country_icons')
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(flex: 8,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: controller.soloLeaderboard
                                                  .isEmpty
                                                  ? const SpinKitWave(
                                                  color: Colors.white,
                                                  size: 12)
                                                  : AutoSizeText(
                                                Chronometer.getDisplayTime(controller.soloLeaderboard[1]
                                                    .soloTimeAverage!.toInt(),
                                                  hours: false,
                                                  milliSecond: false,
                                                ),
                                                style: soloLeaderBoardSecondRatingStyle,
                                              ),
                                            ),
                                          ),
                                          const Spacer(flex: 1,),
                                          Expanded(flex: 8,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: controller.soloLeaderboard
                                                  .isEmpty
                                                  ? const SpinKitWave(
                                                  color: Colors.white,
                                                  size: 12)
                                                  : AutoSizeText(
                                                controller.soloLeaderboard[1].soloGuessesAverage!.toStringAsFixed(1),
                                                style: soloLeaderBoardSecondRatingStyle,
                                              ),
                                            ),
                                          ),
                                          const Spacer(flex: 1,),
                                          Expanded(flex: 9,
                                            child: Align(
                                              alignment: Alignment
                                                  .bottomCenter,
                                              child: controller.soloLeaderboard
                                                  .isEmpty
                                                  ? const SpinKitWave(
                                                  color: Colors.white,
                                                  size: 14)
                                                  : controller
                                                  .soloLeaderboard[1]
                                                  .name == null
                                                  ? const SpinKitThreeBounce(
                                                color: Colors.white,
                                                size: 14,
                                              )
                                                  : AutoSizeText(
                                                controller.soloLeaderboard[1].nickName != null
                                                    ? controller.soloLeaderboard[1].nickName!
                                                    : controller.soloLeaderboard[1].name!.length > 10
                                                    ? controller.soloLeaderboard[1].name!.substring(0, 10)
                                                    : controller.soloLeaderboard[1].name!,
                                                maxLines: 1,
                                                style: leaderPodiumNameStyle,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          const Expanded(flex: 8,
                                              child: SizedBox.shrink()
                                          ),
                                        ],
                                      ),
                                    ),
                                    //First player
                                    Expanded(flex: 33,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          Expanded(flex: 15,
                                              child: Align(
                                                  alignment: Alignment
                                                      .bottomCenter,
                                                  child: Image.asset(
                                                    'assets/images/crown.png',
                                                    color: originalColors
                                                        .accentColor2,
                                                    fit: BoxFit.cover,)
                                              )
                                          ),
                                          Expanded(flex: 60,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                // Image.asset('assets/images/profile_avatar_bg.png'),
                                                ClipOval(
                                                  child: controller.soloLeaderboard.isEmpty
                                                      ? const SpinKitCircle(color: Colors.white,)
                                                      : controller.soloLeaderboard.first.photoUrl != null
                                                      ? FadeInImage.assetNetwork(
                                                    placeholder: 'assets/images/user_photo_bg.png',
                                                    image: controller.soloLeaderboard.first.addedAvatarsUrls != null
                                                        ? controller.soloLeaderboard.first.addedAvatarsUrls!.isNotEmpty
                                                        ? controller.soloLeaderboard.first.addedAvatarsUrls!.last
                                                        : appController.hasInterNetConnection.value
                                                        ? controller.soloLeaderboard.first.photoUrl!.replaceAll("s96-c", "s192-c")
                                                        : controller.soloLeaderboard.first.photoUrl!
                                                        : appController.hasInterNetConnection.value
                                                        ? controller.soloLeaderboard.first.photoUrl!.replaceAll("s96-c", "s192-c")
                                                        : controller.soloLeaderboard.first.photoUrl!, fit: BoxFit.cover,
                                                  )
                                                      : const Image(
                                                      image: AssetImage('assets/images/user_photo_bg.png')
                                                  ),
                                                ),
                                                Positioned(top: 0.0,
                                                  child: SizedBox(
                                                      width: 32,
                                                      child: Image.asset(
                                                          'icons/flags/png/${controller
                                                              .soloLeaderboard
                                                              .first
                                                              .countryCode}.png',
                                                          package: 'country_icons')
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(flex: 8,
                                            child: controller.soloLeaderboard
                                                .isEmpty
                                                ? const SpinKitWave(
                                                color: Colors.white, size: 12)
                                                : AutoSizeText(
                                              Chronometer.getDisplayTime(controller.soloLeaderboard.first.soloTimeAverage!.toInt(),
                                                hours: false,
                                                milliSecond: false,
                                              ),
                                              style: soloLeaderBoardSecondRatingStyle,
                                            ),
                                          ),
                                          const Spacer(flex: 1,),
                                          Expanded(flex: 8,
                                            child: controller.soloLeaderboard
                                                .isEmpty
                                                ? const SpinKitWave(
                                                color: Colors.white, size: 12)
                                                : AutoSizeText(
                                              controller.soloLeaderboard.first.soloGuessesAverage!.toStringAsFixed(1),
                                              style: soloLeaderBoardSecondRatingStyle,
                                            ),
                                          ),
                                          const Spacer(flex: 1,),
                                          Expanded(flex: 9,
                                            child: controller.soloLeaderboard
                                                .isEmpty
                                                ? const SpinKitWave(
                                                color: Colors.white, size: 14)
                                                : controller.soloLeaderboard
                                                .first
                                                .name == null
                                                ? const SpinKitThreeBounce(
                                              color: Colors.white,
                                              size: 14,
                                            )
                                                : AutoSizeText(
                                              controller.soloLeaderboard.first.nickName != null
                                                  ? controller.soloLeaderboard.first.nickName!
                                                  : controller.soloLeaderboard.first.name!.length > 10
                                                  ? controller.soloLeaderboard.first.name!.substring(0, 10)
                                                  : controller.soloLeaderboard.first.name!,
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
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          const Expanded(flex: 12,
                                              child: SizedBox.shrink()
                                          ),
                                          Expanded(flex: 12,
                                            child: Align(
                                              alignment: Alignment
                                                  .bottomCenter,
                                              child: AutoSizeText(
                                                '3',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 18,
                                                    color: originalColors
                                                        .textColorLight),
                                              ),
                                            ),
                                          ),
                                          Expanded(flex: 41,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Center(
                                                  child: ClipOval(
                                                    child: controller.soloLeaderboard.isEmpty
                                                        ? const SpinKitCircle(color: Colors.white,)
                                                        : controller.soloLeaderboard[2].photoUrl != null
                                                        ? FadeInImage.assetNetwork(
                                                      placeholder: 'assets/images/user_photo_bg.png',
                                                      image: controller.soloLeaderboard[2].addedAvatarsUrls != null
                                                          ? controller.soloLeaderboard[2].addedAvatarsUrls!.isNotEmpty
                                                          ? controller.soloLeaderboard[2].addedAvatarsUrls!.last
                                                          : appController.hasInterNetConnection.value
                                                          ? controller.soloLeaderboard[2].photoUrl!.replaceAll("s96-c", "s192-c")
                                                          : controller.soloLeaderboard[2].photoUrl!
                                                          : appController.hasInterNetConnection.value
                                                          ? controller.soloLeaderboard[2].photoUrl!.replaceAll("s96-c", "s192-c")
                                                          : controller.soloLeaderboard[2].photoUrl!, fit: BoxFit.cover,
                                                    )
                                                        : const Image(
                                                        image: AssetImage('assets/images/user_photo_bg.png')
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0.0, right: 12.0,
                                                  child: SizedBox(
                                                      width: 32,
                                                      child: Image.asset(
                                                          'icons/flags/png/${controller
                                                              .soloLeaderboard[2]
                                                              .countryCode}.png',
                                                          package: 'country_icons')
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(flex: 8,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: controller.soloLeaderboard
                                                  .isEmpty
                                                  ? const SpinKitWave(
                                                  color: Colors.white,
                                                  size: 12)
                                                  : AutoSizeText(
                                                Chronometer.getDisplayTime(controller.soloLeaderboard[2]
                                                    .soloTimeAverage!.toInt(),
                                                  hours: false,
                                                  milliSecond: false,
                                                ),
                                                style: soloLeaderBoardSecondRatingStyle,
                                              ),
                                            ),
                                          ),
                                          const Spacer(flex: 1,),
                                          Expanded(flex: 8,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: controller.soloLeaderboard
                                                  .isEmpty
                                                  ? const SpinKitWave(
                                                  color: Colors.white,
                                                  size: 12)
                                                  : AutoSizeText(
                                                controller.soloLeaderboard[2].soloGuessesAverage!.toStringAsFixed(1),
                                                style: soloLeaderBoardSecondRatingStyle,
                                              ),
                                            ),
                                          ),
                                          const Spacer(flex: 1,),
                                          Expanded(flex: 9,
                                            child: Align(
                                              alignment: Alignment
                                                  .bottomCenter,
                                              child: controller.soloLeaderboard
                                                  .isEmpty
                                                  ? const SpinKitWave(
                                                  color: Colors.white,
                                                  size: 14)
                                                  : controller
                                                  .soloLeaderboard[2]
                                                  .name == null
                                                  ? const SpinKitThreeBounce(
                                                color: Colors.white,
                                                size: 14,
                                              )
                                                  : AutoSizeText(
                                                controller.soloLeaderboard[2].nickName != null
                                                    ? controller.soloLeaderboard[2].nickName!
                                                    : controller.soloLeaderboard[2].name!.length > 10
                                                    ? controller.soloLeaderboard[2].name!.substring(0, 10)
                                                    : controller.soloLeaderboard[2].name!,
                                                maxLines: 1,
                                                style: leaderPodiumNameStyle,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          const Expanded(flex: 8,
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
                        Expanded(flex: 6,
                          child: Hero(tag: 'tabBar',
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(flex: 42,
                                  child: InkWell(
                                    onTap: () => controller.showVersus = true,
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: controller.showVersus
                                          ? originalColors
                                          .playerOneBackground
                                          : originalColors
                                          .playerTwoBackground,
                                      child: AutoSizeText(
                                        'vs_mode'.tr,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: leaderboardTitleStyle,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(flex: 42,
                                  child: InkWell(
                                    onTap: () =>
                                    controller.showVersus = false,
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: controller.showVersus
                                          ? originalColors
                                          .playerTwoBackground
                                          : originalColors
                                          .playerOneBackground,
                                      child: AutoSizeText(
                                        'solo_mode'.tr,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: leaderboardTitleStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: controller.isBottomBannerAdLoaded ? 52 : 72,
                          // Leaderboard listview
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/leaderboard_grid.png',
                                  ),
                                  fit: BoxFit.fill
                              ),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 12,
                                    left: 12.0,
                                    right: 12.0,
                                    bottom: 12),
                                child: controller.soloLeaderboard.isEmpty
                                    ? const Center(
                                  child: SpinKitCubeGrid(
                                    color: Colors.white,),
                                )
                                    : ListView.builder(
                                    itemCount: controller.soloLeaderboard
                                        .length -
                                        3,
                                    itemBuilder: (BuildContext context,
                                        int index) {
                                      return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SoloLeaderboardItem(
                                            leaderboard: controller.soloLeaderboard,
                                            index: index,)
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
                                      const Color(0xFF4E524E).withOpacity(
                                          0.2),
                                      const Color(0xFF899288).withOpacity(
                                          0.2),
                                      const Color(0xFFA9B8A8).withOpacity(
                                          0.2),
                                      const Color(0xFFBACEB8).withOpacity(
                                          0.2),
                                      const Color(0xFF939E92).withOpacity(
                                          0.2),
                                      const Color(0xFF818B81).withOpacity(
                                          0.2),
                                      const Color(0xFF5C615C).withOpacity(
                                          0.2),
                                      const Color(0xFF424442).withOpacity(
                                          0.2),
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: AdWidget(
                                    ad: controller.bottomBannerAd),
                              ),
                            )
                        )
                            : const SizedBox.shrink(),
                      ],
                    )
                );
              });
            }
        )
    );
  }
}

class VersusLeaderboardItem extends StatelessWidget {
  final List<Player> leaderboard;
  final int index;

  const VersusLeaderboardItem(
      {Key? key, required this.index, required this.leaderboard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: Row(
        children: [
          Expanded(flex: 7,
            child: AutoSizeText(
              '${index + 4}. ',
              style: leaderboardItemStyle,
            ),
          ),
          Expanded(flex: 16,
            child: leaderboard[index + 3].addedAvatarsUrls == null
                ? leaderboard[index + 3].photoUrl == null
                ? Image.asset('assets/images/user_photo_bg.png')
                : FadeInImage.assetNetwork(
              image: leaderboard[index + 3].photoUrl!,
              placeholder: 'assets/images/user_photo_bg.png',
            )
                : leaderboard[index + 3].addedAvatarsUrls!.isNotEmpty
                ? FadeInImage.assetNetwork(
              image: leaderboard[index + 3].addedAvatarsUrls!.last,
              placeholder: 'assets/images/user_photo_bg.png',
            )
                : leaderboard[index + 3].photoUrl == null
                ? Image.asset('assets/images/user_photo_bg.png')
                : FadeInImage.assetNetwork(
              image: leaderboard[index + 3].photoUrl!,
              placeholder: 'assets/images/user_photo_bg.png',
            ),
          ),
          const Spacer(flex: 5,),
          Expanded(flex: 49,
            child: AutoSizeText(
              leaderboard[index + 3].nickName ?? leaderboard[index + 3].name!,
              style: leaderboardItemStyle,
            ),
          ),
          Expanded(flex: 5,
            child: Image.asset(
                'icons/flags/png/${leaderboard[index + 3]
                    .countryCode}.png',
                package: 'country_icons'),
          ),
          Expanded(flex: 18,
            child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(
                leaderboard[index + 3].rating!.toString(),
                style: defaultTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class SoloLeaderboardItem extends StatelessWidget {
  final List<Player> leaderboard;
  final int index;

  const SoloLeaderboardItem(
      {Key? key, required this.index, required this.leaderboard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: Row(
        children: [
          Expanded(flex: 7,
            child: AutoSizeText(
              '${index + 4}. ',
              style: leaderboardItemStyle,
            ),
          ),
          Expanded(flex: 16,
            child: leaderboard[index + 3].addedAvatarsUrls == null
                ? leaderboard[index + 3].photoUrl == null
                ? Image.asset('assets/images/user_photo_bg.png')
                : FadeInImage.assetNetwork(
              image: leaderboard[index + 3].photoUrl!,
              placeholder: 'assets/images/user_photo_bg.png',
            )
                : leaderboard[index + 3].addedAvatarsUrls!.isNotEmpty
                ? FadeInImage.assetNetwork(
              image: leaderboard[index + 3].addedAvatarsUrls!.last,
              placeholder: 'assets/images/user_photo_bg.png',
            )
                : leaderboard[index + 3].photoUrl == null
                ? Image.asset('assets/images/user_photo_bg.png')
                : FadeInImage.assetNetwork(
              image: leaderboard[index + 3].photoUrl!,
              placeholder: 'assets/images/user_photo_bg.png',
            ),
          ),
          const Spacer(flex: 3,),
          Expanded(flex: 43,
            child: AutoSizeText(
              leaderboard[index + 3].nickName ?? leaderboard[index + 3].name!,
              style: leaderboardItemStyle,
            ),
          ),
          Expanded(flex: 5,
            child: Image.asset(
                'icons/flags/png/${leaderboard[index + 3]
                    .countryCode}.png',
                package: 'country_icons'),
          ),
          const Spacer(flex: 2,),
          Expanded(
            flex: 13,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                Chronometer.getDisplayTime(
                    leaderboard[index + 3].soloTimeAverage!.toInt(),
                    hours: false,
                    milliSecond: false
                ),
                maxLines: 1,
                style: defaultTextStyle,
              ),
            ),
          ),
          Expanded(
            flex: 11,
            child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(
                leaderboard[index + 3].soloGuessesAverage!.toStringAsFixed(1),
                maxLines: 1,
                style: defaultTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

}




