import 'package:bulls_n_cows_reloaded/model/player.dart';
import 'package:bulls_n_cows_reloaded/shared/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../constants.dart';
import '../google_sign_in_button_circular.dart';

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Player player = appController.currentPlayer;
      return Stack(
        children: [
          authController.authState == AuthState.anonymous
              ? Container()
              : Center(
            child: Image.asset('assets/images/user_image_frame.png'),
          ),
          Column(
            children: [
              Expanded(flex: 80,
                child: authController.authState == AuthState.anonymous
                    ? GoogleSignInButtonCircular()
                    :  player.photoUrl != null
                    ? FadeInImage.assetNetwork(
                  placeholder: 'assets/images/user_photo_bg.png',
                  image: player.photoUrl!,
                )
                    : const Image(
                    image: AssetImage('assets/images/user_photo_bg.png')
                ),
              ),
              Expanded(flex: 16,
                child: Center(
                    child: player.name == null
                        ? const SpinKitThreeBounce(
                      color: Colors.white,
                      size: 14,
                    )
                        : Text(
                      player.name!
                          .split(' ')
                          .first,
                      style: profilePlayerStatsSubTitleKeyStyle,
                      textAlign: TextAlign.center,
                    )
                ),
              ),
              Expanded(flex: 4, child: Container()),
            ],
          ),
          Positioned(top: 4.0, left: 4.0,
            child: SizedBox(
                width: 32,
                child: Image.asset(
                    'icons/flags/png/${appController.countryCode}.png',
                    package: 'country_icons')
            ),
          ),
        ],
      );
    });
  }
}