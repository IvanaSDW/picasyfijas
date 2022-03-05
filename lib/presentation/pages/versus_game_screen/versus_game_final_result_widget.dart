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
    return Obx(() =>
    gameLogic.game.winnerPlayer == WinnerPlayer.draw
        ? Center(
      child: Column(
        children: [
          Text('Incredible!!',
            style: GoogleFonts.robotoMono(
                textStyle: const TextStyle(
                    color: Colors.green,
                    fontSize: 26
                )
            ),
          ),
          Text('it\'s a DRAW',
            style: GoogleFonts.robotoMono(
                textStyle: const TextStyle(
                    color: Colors.green,
                    fontSize: 16
                )
            ),
          ),
          Container(height: 8,),
          Text('Time left: ${StopWatchTimer.getDisplayTime(
              gameLogic.game.playerOneGame.moves.last.timeStampMillis,
              hours: false
          )}',
            style: GoogleFonts.robotoMono(
                textStyle: const TextStyle(
                    color: Colors.green,
                    fontSize: 18
                )
            ),
          ),
          Text('Guesses: ${gameLogic.game.playerOneGame.moves.length}',
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
        : (gameLogic.iAmPlayerOne && gameLogic.game.winnerPlayer == WinnerPlayer.player1) ||
        (!gameLogic.iAmPlayerOne && gameLogic.game.winnerPlayer == WinnerPlayer.player2)
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeText(gameLogic.game.winByMode == WinByMode.moves ?
          'YOU WON!!' : 'YOU WON BY TIME!!',
            maxLines: 1,
            style: GoogleFonts.robotoMono(
                textStyle: const TextStyle(
                    color: Colors.green,
                    fontSize: 26
                )
            ),
          ),
          Text(gameLogic.game.winByMode == WinByMode.moves ?
          'Congratulations!' : 'Wow, that was close!',
            style: GoogleFonts.robotoMono(
                textStyle: const TextStyle(
                    color: Colors.green,
                    fontSize: 16
                )
            ),
          ),
          Container(height: 16,),
          Text(gameLogic.iAmPlayerOne ?
          'Time left: ${StopWatchTimer.getDisplayTime(gameLogic.game.playerOneGame.moves.last.timeStampMillis, hours: false, milliSecond: false)}'
              : 'Time left: ${StopWatchTimer.getDisplayTime(gameLogic.game.playerTwoGame.moves.last.timeStampMillis, hours: false, milliSecond: false)}',
            style: GoogleFonts.robotoMono(
                textStyle: const TextStyle(
                    color: Colors.green,
                    fontSize: 18
                )
            ),
          ),
          Text('Guesses: ${gameLogic.game.playerOneGame.moves.length}',
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
        : Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeText(gameLogic.game.winByMode == WinByMode.moves ?
          '-YOU LOST-' : 'YOU LOST BY TIME!!',
            maxLines: 1,
            style: GoogleFonts.robotoMono(
                textStyle: const TextStyle(
                    color: Colors.green,
                    fontSize: 26
                )
            ),
          ),
          Text(gameLogic.game.winByMode == WinByMode.moves ?
          'Maybe next time!' : 'Wow, that was close!',
            style: GoogleFonts.robotoMono(
                textStyle: const TextStyle(
                    color: Colors.green,
                    fontSize: 16
                )
            ),
          ),
          Container(height: 16,),
          Text(gameLogic.iAmPlayerOne ?
          'Time left: ${StopWatchTimer.getDisplayTime(gameLogic.game.playerOneGame.moves.last.timeStampMillis, hours: false, milliSecond: false)}'
              : 'Time left: ${StopWatchTimer.getDisplayTime(gameLogic.game.playerTwoGame.moves.last.timeStampMillis, hours: false, milliSecond: false)}',
            style: GoogleFonts.robotoMono(
                textStyle: const TextStyle(
                    color: Colors.green,
                    fontSize: 18
                )
            ),
          ),
          Text('Guesses: ${gameLogic.game.playerOneGame.moves.length}',
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