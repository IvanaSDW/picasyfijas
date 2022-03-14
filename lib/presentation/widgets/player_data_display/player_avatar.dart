import 'package:auto_size_text/auto_size_text.dart';
import 'package:bulls_n_cows_reloaded/data/models/player.dart';
import 'package:bulls_n_cows_reloaded/shared/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({Key? key, required this.player,}) : super(key: key);
  final Player player;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: Image.asset('assets/images/user_image_frame.png'),
            ),
            Column(
              children: [
                Expanded(flex: 80,
                  child: ClipOval(
                    child: player.photoUrl != null
                        ? FadeInImage.assetNetwork(
                      placeholder: 'assets/images/user_photo_bg.png',
                      image: player.photoUrl!,
                    )
                        : const Image(
                        image: AssetImage('assets/images/user_photo_bg.png')
                    ),
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
            Positioned(top: 4.0, left: 4.0,
              child: SizedBox(
                  width: 32,
                  child: Image.asset(
                      'icons/flags/png/${player.countryCode}.png',
                      package: 'country_icons')
              ),
            ),
          ],
        )
    );
  }
}