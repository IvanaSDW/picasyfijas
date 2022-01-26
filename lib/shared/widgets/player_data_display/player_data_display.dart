import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../google_sign_in_button_circular.dart';
import 'player_data_controller.dart';

class PlayerDataDisplay extends StatelessWidget {
  final PlayerDataDisplayController controller = Get.put(PlayerDataDisplayController());

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

    return Obx(
          () => Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  flex: 26,
                  child: Stack(
                    children: [
                      Hero(
                          tag: 'image_frame',
                          child: Center(
                            child: Image.asset(
                                'assets/images/user_image_frame.png'),
                          )),
                      Column(
                        children: [
                          Expanded(
                            flex: 80,
                            child: InkWell(
                              onTap: () => onAvatarTapped(),
                                child: const PlayerAvatar()
                            ),
                          ),
                          Expanded(
                              flex: 20,
                              child: Hero(
                                tag: 'user_name',
                                child: Center(
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 14.0),
                                      child: FittedBox(
                                        child: appController.currentPlayer.name == null
                                            ? const SpinKitChasingDots(color: Colors.white,)
                                            : Text(
                                          appController.currentPlayer.name!
                                              .split(' ')
                                              .first,
                                          style: statsSubTitle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                ),
                              )
                          ),
                        ],
                      ),
                      Hero(
                        tag: 'flag',
                        child: SizedBox(
                            width: 30,
                            child: Image.asset(
                                'icons/flags/png/${appController.countryCode}.png',
                                package: 'country_icons')),
                      ),
                    ],
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

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return authController.authState == AuthState.anonymous
        ? GoogleSignInButtonCircular()
        : appController.currentPlayer.photoUrl != null
        ? FadeInImage.assetNetwork(
          placeholder:
          'assets/images/user_photo_bg.png',
          image: appController.currentPlayer.photoUrl,
        )
        : const Image(
        image: AssetImage(
            'assets/images/user_photo_bg.png')
    );
  }
}
