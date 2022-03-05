import 'package:auto_size_text/auto_size_text.dart';
import 'package:bulls_n_cows_reloaded/data/models/player.dart';
import 'package:bulls_n_cows_reloaded/shared/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../shared/constants.dart';

class GuestAvatar extends StatelessWidget {
  const GuestAvatar({Key? key,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Obx(() {
        Player player = appController.currentPlayer;
        return Stack(
          children: [
            Column(
              children: [
                Expanded(flex: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Image(
                          image: AssetImage('assets/images/user_photo_bg.png')
                      ),
                      SizedBox(
                          width: 32,
                          child: Image.asset(
                              'icons/flags/png/${appController.countryCode}.png',
                              package: 'country_icons')
                      ),
                    ],
                  ),
                ),
                Expanded(flex: 16,
                  child: Center(
                      child: player.name == null
                          ? const SpinKitThreeBounce(
                        color: Colors.white,
                        size: 14,
                      )
                          : AutoSizeText(
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
          ],
        );
      }),
    );
  }
}