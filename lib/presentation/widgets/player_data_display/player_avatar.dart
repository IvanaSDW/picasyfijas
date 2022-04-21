import 'package:auto_size_text/auto_size_text.dart';
import 'package:bulls_n_cows_reloaded/data/models/player.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:bulls_n_cows_reloaded/shared/text_styles.dart';
import 'package:bulls_n_cows_reloaded/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({Key? key, required this.player, required this.isP1})
      : super(key: key);
  final Player player;
  final bool isP1;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(color: isP1 ? Colors.white : originalColors.accentColor2!, width: 0.5,)
              ),
            ),
            Column(
              children: [
                Expanded(flex: 80,
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: ClipOval(
                      child: player.photoUrl != null
                          ? FadeInImage.assetNetwork(
                        placeholder: 'assets/images/user_photo_bg.png',
                        image: player.addedAvatarsUrls != null
                            ? player.addedAvatarsUrls!.isNotEmpty
                            ? player.addedAvatarsUrls!.last
                            : appController.hasInterNetConnection.value
                            ? player.photoUrl!.replaceAll("s96-c", "s192-c")
                            : player.photoUrl!
                            : appController.hasInterNetConnection.value
                            ? player.photoUrl!.replaceAll("s96-c", "s192-c")
                            : player.photoUrl!, fit: BoxFit.cover,
                      )
                          : const Image(
                          image: AssetImage('assets/images/user_photo_bg.png')
                      ),
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
                        player.nickName ??
                            player.name!
                                .split(' ')
                                .first,
                        style: profilePlayerStatsSubTitleKeyStyle,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      )
                  ),
                ),
                Expanded(flex: 4, child: Container()),
              ],
            ),
            Positioned(top: 4.0, left: 4.0,
              child: SizedBox(
                  width: 28,
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