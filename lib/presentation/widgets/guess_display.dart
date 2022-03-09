import 'package:blinking_text/blinking_text.dart';
import 'package:bulls_n_cows_reloaded/data/models/game_move.dart';
import 'package:bulls_n_cows_reloaded/shared/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'guess_bullet_widget.dart';
import 'numeric_keyboard/numeric_keyboard_controller.dart';

class NormalGuessDisplay extends StatelessWidget {
  const NormalGuessDisplay({
    Key? key,
    required this.index,
    required this.item,
    required this.textHeight,
  }) : super(key: key);

  final int index;
  final double textHeight;
  final GameMove item;

  @override
  Widget build(BuildContext context) {
    var guess = item.guess;
    return SizedBox(
      height: textHeight * 1.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            // Bullet
            child: GuessBulletWidget(
              textHeight: textHeight,
              index: index,
            ),
          ),
          Container(
            width: 8,
          ),
          Text(
            guess.digit0.toString(),
            style: guessTextStyle,
          ),
          Container(
            width: 4,
          ),
          Text(
            guess.digit1.toString(),
            style: guessTextStyle,
          ),
          Container(
            width: 4,
          ),
          Text(
            guess.digit2.toString(),
            style: guessTextStyle,
          ),
          Container(
            width: 4,
          ),
          Text(
            guess.digit3.toString(),
            style: guessTextStyle,
          ),
          Container(
            width: 8,
          ),
          Container(
            height: 1.0,
            width: 15,
            color: Colors.green,
          ),
          // Text('>', style: resultTextStyle,),
          Container(
            width: 8,
          ),
          Text(
            item.moveResult.bulls.toString(),
            style: resultTextStyle,
          ),
          Container(
            width: 4,
          ),
          Text(
            'b',
            style: resultTextStyle,
          ),
          Container(
            width: 2,
          ),
          Text(
            ':',
            style: resultTextStyle,
          ),
          Container(
            width: 2,
          ),
          Text(
            item.moveResult.cows.toString(),
            style: resultTextStyle,
          ),
          Container(
            width: 4,
          ),
          Text(
            'c',
            style: resultTextStyle,
          ),
        ],
      ),
    );
  }
}

class CorrectGuessDisplay extends StatelessWidget {
  const CorrectGuessDisplay({
    Key? key,
    required this.index,
    required this.textHeight,
    required this.item,
  }) : super(key: key);

  final int index;
  final double textHeight;
  final GameMove item;

  @override
  Widget build(BuildContext context) {
    var guess = item.guess;
    return SizedBox(
      height: textHeight * 1.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              // Bullet
              child: GuessBulletWidget(
            textHeight: textHeight,
            index: index,
          )),
          Container(
            width: 8,
          ),
          Text(
            guess.digit0.toString(),
            style: correctGuessStyle,
          ),
          Container(
            width: 4,
          ),
          Text(
            guess.digit1.toString(),
            style: correctGuessStyle,
          ),
          Container(
            width: 4,
          ),
          Text(
            guess.digit2.toString(),
            style: correctGuessStyle,
          ),
          Container(
            width: 4,
          ),
          Text(
            guess.digit3.toString(),
            style: correctGuessStyle,
          ),
          Container(
            width: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Container(
              height: 1.0,
              width: 15,
              color: Colors.green,
            ),
          ),
          // Text('>', style: resultTextStyle,),
          Container(
            width: 8,
          ),
          Text(
            String.fromCharCodes(Runes('\u2705 \u2705 \u2705 \u2705')),
          ),
        ],
      ),
    );
  }
}

class PendingGuessDisplay extends StatelessWidget {
  PendingGuessDisplay({
    Key? key,
    required this.index,
    required this.textHeight,
    required this.item,
  }) : super(key: key);

  final int index;
  final double textHeight;
  final GameMove item;
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
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GuessBulletWidget(textHeight: textHeight, index: index),
            Container(
              width: 8,
            ),
            keyboard.screenDigitEnabled[0]
                ? Text(
                    '${keyboard.screenDigitNumbers[0]}',
                    style: guessTextStyle,
                  )
                : BlinkText(
                    '_',
                    style: guessTextStyle,
                  ),
            Container(
              width: 4,
            ),
            keyboard.screenDigitEnabled[1]
                ? Text(
                    '${keyboard.screenDigitNumbers[1]}',
                    style: guessTextStyle,
                  )
                : BlinkText(
                    '_',
                    style: guessTextStyle,
                  ),
            Container(
              width: 4,
            ),
            keyboard.screenDigitEnabled[2]
                ? Text(
                    '${keyboard.screenDigitNumbers[2]}',
                    style: guessTextStyle,
                  )
                : BlinkText(
                    '_',
                    style: guessTextStyle,
                  ),
            Container(
              width: 4,
            ),
            keyboard.screenDigitEnabled[3]
                ? Text(
                    '${keyboard.screenDigitNumbers[3]}',
                    style: guessTextStyle,
                  )
                : BlinkText(
                    '_',
                    style: guessTextStyle,
                  ),
            Container(
              width: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                height: 1.0,
                width: 15,
                color: Colors.transparent,
              ),
            ),
            // Text('>', style: resultTextStyle,),
            Container(
              width: 8,
            ),
            Text(
              '0',
              style: invisibleText,
            ),
            Container(
              width: 4,
            ),
            Text(
              'b',
              style: invisibleText,
            ),
            Container(
              width: 2,
            ),
            Text(
              ':',
              style: invisibleText,
            ),
            Container(
              width: 2,
            ),
            Text(
              '0',
              style: invisibleText,
            ),
            Container(
              width: 4,
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
