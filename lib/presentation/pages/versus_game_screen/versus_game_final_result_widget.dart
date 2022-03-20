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
        titleText = 'Amazing!!';
        subTitleText = 'it\'s a DRAW';
        break;
      case WinByMode.moves:
        titleText = (gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player1) ||
            (!gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player2)
            ? 'YOU WON!!' : '-YOU LOST-';
        subTitleText = (gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player1) ||
            (!gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player2)
            ? 'Congratulations!' : 'Maybe next time!';
        break;
      case WinByMode.time:
        titleText = (gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player1) ||
            (!gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player2)
            ? 'YOU WON BY TIME!!' : 'YOU LOST BY TIME!!';
        subTitleText = (gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player1) ||
            (!gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player2)
            ? 'Wow, that was close!' : 'But well played!';
        break;
      case WinByMode.opponentLeft:
        titleText = (gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player1) ||
            (!gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player2)
            ? 'YOUR OPPONENT LEFT!!' : 'YOU LEFT!!';
        subTitleText = (gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player1) ||
            (!gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player2)
            ? 'You win!' : 'You lost!';
        break;
      case WinByMode.opponentTimeUp:
        titleText = (gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player1) ||
            (!gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player2)
            ? 'YOU WIN!!' : 'YOUR TIME IS UP!!';
        subTitleText = (gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player1) ||
            (!gameLogic.iAmP1 && gameLogic.game.winnerPlayer == WinnerPlayer.player2)
            ? 'Your opponent time is up!' : 'Sorry, you lost.';
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
              Container(height: 16,),
              Text(gameLogic.game.winByMode == WinByMode.opponentLeft || gameLogic.game.winByMode == WinByMode.opponentTimeUp? ''
                   : 'time_left'.tr +  StopWatchTimer.getDisplayTime(
                gameLogic.iAmP1
                    ? gameLogic.game.playerOneGame.moves.last.timeStampMillis
                    : gameLogic.game.playerTwoGame.moves.last.timeStampMillis,
                hours: false, milliSecond: false,
              ),
                style: GoogleFonts.robotoMono(
                    textStyle: const TextStyle(
                        color: Colors.green,
                        fontSize: 18
                    )
                ),
              ),
              Text(gameLogic.game.winByMode == WinByMode.opponentLeft || gameLogic.game.winByMode == WinByMode.opponentTimeUp? ''
                  : 'guesses'.tr + '${gameLogic.game.playerOneGame.moves.length}',
                style: GoogleFonts.robotoMono(
                    textStyle: const TextStyle(
                        color: Colors.green,
                        fontSize: 18
                    )
                ),
              ),
            ],
          ),
        )
    );
  }
}