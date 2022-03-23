import 'package:auto_size_text/auto_size_text.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/versus_game_screen/versus_game_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../../../shared/constants.dart';

class VersusGameResultWidget extends StatelessWidget {

  VersusGameResultWidget({Key? key,}) : super(key: key);
  final VersusGameLogic gameLogic = Get.find();

  @override
  Widget build(BuildContext context) {
    String titleText = '';
    String subTitleText ='';
    switch (gameLogic.game.winByMode) {
      case WinByMode.draw:
        titleText = 'amazing'.tr;
        subTitleText = 'its_a_draw'.tr;
        break;
      case WinByMode.moves:
        titleText = (gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player1) ||
            (!gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player2)
            ? 'you_won'.tr : '-you_lost-'.tr;
        subTitleText = (gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player1) ||
            (!gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player2)
            ? 'congratulations'.tr : 'maybe_next_time'.tr;
        break;
      case WinByMode.time:
        titleText = (gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player1) ||
            (!gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player2)
            ? 'you_won_by_time'.tr : 'you_lost_by_time'.tr;
        subTitleText = (gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player1) ||
            (!gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player2)
            ? 'that_was_close'.tr : 'but_well_played'.tr;
        break;
      case WinByMode.opponentLeft:
        titleText = (gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player1) ||
            (!gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player2)
            ? 'your_opponent_left'.tr : 'you_left'.tr;
        subTitleText = (gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player1) ||
            (!gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player2)
            ? 'you_won_lower'.tr : 'you_lost_lower'.tr;
        break;
      case WinByMode.opponentTimeUp:
        titleText = (gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player1) ||
            (!gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player2)
            ? 'you_won'.tr : 'your_time_is_up'.tr;
        subTitleText = (gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player1) ||
            (!gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player2)
            ? 'your_opponent_time_is_up'.tr : 'sorry_you_lost'.tr;
        break;
      default:
        break;
    }
    return Obx(() =>
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(titleText,
                maxLines: 1,
                style: GoogleFonts.robotoMono(
                    textStyle: const TextStyle(
                        color: Colors.green,
                        fontSize: 26
                    )
                ),
              ),
              Text(subTitleText,
                style: GoogleFonts.robotoMono(
                    textStyle: const TextStyle(
                        color: Colors.green,
                        fontSize: 16
                    )
                ),
              ),
              Container(height: 12,),
              AutoSizeText(
                gameLogic.game.winByMode == WinByMode.opponentLeft || gameLogic.game.winByMode == WinByMode.opponentTimeUp? ''
                   : 'time_left'.tr +  StopWatchTimer.getDisplayTime(
                gameLogic.iAmP1
                    ? gameLogic.game.playerOneGame.moves.last.timeStampMillis
                    : gameLogic.game.playerTwoGame.moves.last.timeStampMillis,
                hours: false, milliSecond: false,
              ),
                style: GoogleFonts.robotoMono(
                    textStyle: const TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                    ),
                ),
                textAlign: TextAlign.center,
              ),
              Text(gameLogic.game.winByMode == WinByMode.opponentLeft || gameLogic.game.winByMode == WinByMode.opponentTimeUp? ''
                  : 'guesses'.tr + '${gameLogic.game.playerOneGame.moves.length}',
                style: GoogleFonts.robotoMono(
                    textStyle: const TextStyle(
                        color: Colors.green,
                        fontSize: 16
                    )
                ),
              ),
            ],
          ),
        )
    );
  }
}