import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/player_data_display/guest_avatar.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/player_data_display/player_avatar.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/player_data_display/player_stats_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class PlayerDataDisplay extends StatelessWidget {

  const PlayerDataDisplay({Key? key, required this.onAvatarTapped, required this.isP1})
      : super(key: key);

  final Function onAvatarTapped;
  final bool isP1;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(flex: 26,
                child: Obx(() {
                  return InkWell(
                      onTap: () => onAvatarTapped(),
                      child: Hero(
                        tag: 'avatar',
                        child: appController.authState == AuthState.google
                            ? PlayerAvatar(player: appController.currentPlayer, isP1: isP1,)
                            : const GuestAvatar(),
                      )
                  );
                })
            ),
            const Spacer(flex: 4,),
            Expanded(flex: 70,
              child: PlayerStatsWidget(),
            )
          ],
        ),
      ),
    );
  }
}



