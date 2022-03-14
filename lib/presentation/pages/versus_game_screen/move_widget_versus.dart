import 'package:blinking_text/blinking_text.dart';
import 'package:bulls_n_cows_reloaded/data/models/game_move.dart';
import 'package:bulls_n_cows_reloaded/shared/text_styles.dart';
import 'package:bulls_n_cows_reloaded/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/constants.dart';
import '../../widgets/numeric_keyboard/numeric_keyboard_controller.dart';


class MoveItemWidget extends StatelessWidget {
  final double textHeight;
  final GameMove moveItem;
  final PlayerSide side;
  final VersusPlayer playerShift;

  MoveItemWidget({Key? key,
    required this.moveItem,
    required this.textHeight,
    required this.side,
    required this.playerShift,
  }) : super(key: key);

  final dummyMove = GameMove.dummy();

  @override
  Widget build(BuildContext context) {
    if (moveItem.moveResult.bulls == 4) {
      return CorrectMoveWidgetVersus(textHeight: textHeight, move: moveItem, side: side,);
    } else {
      if(moveItem.guess.isDummy()) {
        return side == PlayerSide.opponent
            ? PendingMoveWidgetVersusOpponent(textHeight: textHeight)
            : PendingMoveWidgetVersusThisPlayer(textHeight: textHeight, move: moveItem, side: side,);
      } else {
        return NormalMoveWidgetVersus(move: moveItem, textHeight: textHeight, side: side, playerShift: playerShift,);
      }
    }
  }
}

class NormalMoveWidgetVersus extends StatelessWidget {
  const NormalMoveWidgetVersus({
    Key? key,
    required this.move,
    required this.textHeight,
    required this.side,
    required this.playerShift,
  }) : super(key: key);

  final double textHeight;
  final GameMove move;
  final PlayerSide side;
  final VersusPlayer playerShift;

  @override
  Widget build(BuildContext context) {
    var myGuess = move.guess;
    return SizedBox(
      height: textHeight * 1.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        textBaseline: TextBaseline.ideographic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: [
          Text(
            myGuess.digit0.toString(),
            style: playerShift == VersusPlayer.player1
                ? guessTextStyleVersusPlayer1
                : guessTextStyleVersusPlayer2,
          ),
          Container(
            width: 3,
          ),
          Text(
            myGuess.digit1.toString(),
            style: playerShift == VersusPlayer.player1
                ? guessTextStyleVersusPlayer1
                : guessTextStyleVersusPlayer2,
          ),
          Container(
            width: 3,
          ),
          Text(
            myGuess.digit2.toString(),
            style: playerShift == VersusPlayer.player1
                ? guessTextStyleVersusPlayer1
                : guessTextStyleVersusPlayer2,
          ),
          Container(
            width: 3,
          ),
          Text(
            myGuess.digit3.toString(),
            style: playerShift == VersusPlayer.player1
                ? guessTextStyleVersusPlayer1
                : guessTextStyleVersusPlayer2,
          ),
          Container(
            width: 4,
          ),
          Text('->', style: resultTextStyle,),
          Container(
            width: 4,
          ),
          Text(
            move.moveResult.bulls.toString(),
            style: resultTextStyleVersus,
          ),
          Text(
            'b'.tr,
            style: resultTextStyleVersus,
          ),
          Container(
            width: 2,
          ),
          Text(
            move.moveResult.cows.toString(),
            style: resultTextStyleVersus,
          ),
          Text(
            'c'.tr,
            style: resultTextStyleVersus,
          ),
        ],
      ),
    );
  }
}

class CorrectMoveWidgetVersus extends StatelessWidget {

  const CorrectMoveWidgetVersus({
    Key? key,
    required this.textHeight,
    required this.move,
    required this.side,
  }) : super(key: key);

  final double textHeight;
  final GameMove move;
  final PlayerSide side;


  @override
  Widget build(BuildContext context) {
    var guess = move.guess;
    return SizedBox(
      height: textHeight * 1.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            guess.digit0.toString(),
            style: correctGuessStyleVersus,
          ),
          Container(
            width: 3,
          ),
          Text(
            guess.digit1.toString(),
            style: correctGuessStyleVersus,
          ),
          Container(
            width: 3,
          ),
          Text(
            guess.digit2.toString(),
            style: correctGuessStyleVersus,
          ),
          Container(
            width: 3,
          ),
          Text(
            guess.digit3.toString(),
            style: correctGuessStyleVersus,
          ),
          Container(
            width: 3,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Container(
              height: 1.0,
              width: 10,
              color: Colors.green,
            ),
          ),
          // Text('>', style: resultTextStyle,),
          Container(
            width: 3,
          ),
          Text(
            String.fromCharCodes(Runes('\u2705 \u2705 \u2705 \u2705')),
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class PendingMoveWidgetVersusOpponent extends StatelessWidget {
  const PendingMoveWidgetVersusOpponent(
      {Key? key, required this.textHeight,}) : super(key: key);

  final double textHeight;

  @override
  Widget build(BuildContext context) {
    final invisibleText = GoogleFonts.robotoMono(
        textStyle: TextStyle(
          color: Colors.transparent,
          fontSize: textHeight,
        ));
    return SizedBox(
      height: textHeight * 1.4,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: SpinKitWave(color: originalColors.accentColor2, ),
            // child: const SpinKitThreeBounce(color: Colors.amber, size: 35,),
          ),

          // Text('>', style: resultTextStyle,),
          Container(
            width: 4,
          ),
          Text(
            '0',
            style: invisibleText,
          ),
          Text(
            'b',
            style: invisibleText,
          ),
          Container(
            width: 2,
          ),
          Text(
            '0',
            style: invisibleText,
          ),
          Text(
            'c',
            style: invisibleText,
          ),
        ],
      ),
    );
  }

}

class PendingMoveWidgetVersusThisPlayer extends StatelessWidget {
  PendingMoveWidgetVersusThisPlayer({
    Key? key,
    required this.textHeight,
    required this.move,
    required this.side,
  }) : super(key: key);

  final double textHeight;
  final GameMove move;
  final PlayerSide side;
  final keyboard = Get.find<NumericKeyboardController>();

  @override
  Widget build(BuildContext context) {
    final invisibleText = GoogleFonts.robotoMono(
        textStyle: TextStyle(
          color: Colors.transparent,
          fontSize: textHeight,
        ));
    return SizedBox(
      height: textHeight * 1.4,
      child: Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          keyboard.screenDigitEnabled[0]
              ? Text(
            '${keyboard.screenDigitNumbers[0]}',
            style: guessTextStyleVersusPlayer2,
          )
              : BlinkText(
            '_',
            style: guessTextStyleVersusPlayer2,
          ),
          Container(
            width: 3,
          ),
          keyboard.screenDigitEnabled[1]
              ? Text(
            '${keyboard.screenDigitNumbers[1]}',
            style: guessTextStyleVersusPlayer2,
          )
              : BlinkText(
            '_',
            style: guessTextStyleVersusPlayer2,
          ),
          Container(
            width: 3,
          ),
          keyboard.screenDigitEnabled[2]
              ? Text(
            '${keyboard.screenDigitNumbers[2]}',
            style: guessTextStyleVersusPlayer2,
          )
              : BlinkText(
            '_',
            style: guessTextStyleVersusPlayer2,
          ),
          Container(
            width: 3,
          ),
          keyboard.screenDigitEnabled[3]
              ? Text(
            '${keyboard.screenDigitNumbers[3]}',
            style: guessTextStyleVersusPlayer2,
          )
              : BlinkText(
            '_',
            style: guessTextStyleVersusPlayer2,
          ),
          Container(
            width: 4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Container(
              height: 1.0,
              width: 12,
              color: Colors.transparent,
            ),
          ),
          // Text('>', style: resultTextStyle,),
          Container(
            width: 4,
          ),
          Text(
            '0',
            style: invisibleText,
          ),
          Text(
            'b',
            style: invisibleText,
          ),
          Container(
            width: 2,
          ),
          Text(
            '0',
            style: invisibleText,
          ),
          Text(
            'c',
            style: invisibleText,
          ),
        ],
      ),
      ),
    );
  }
}
