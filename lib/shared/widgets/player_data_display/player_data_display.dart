import 'package:bulls_n_cows_reloaded/shared/widgets/player_data_display/player_avatar.dart';
import 'package:bulls_n_cows_reloaded/shared/widgets/player_data_display/player_stats_widget.dart';
import 'package:flutter/material.dart';

class PlayerDataDisplay extends StatelessWidget {

  const PlayerDataDisplay({Key? key, required this.onAvatarTapped}) : super(key: key);

  final Function onAvatarTapped;

  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(flex: 26,
                child: InkWell(
                    onTap: () => onAvatarTapped(),
                    child: const Hero(
                        tag: 'avatar',
                        child: PlayerAvatar()
                    )
                )
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



