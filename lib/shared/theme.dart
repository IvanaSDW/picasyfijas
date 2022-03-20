import 'package:flutter/material.dart';

ColorPalette originalColors = ColorPalette(
  backgroundColor: Colors.black,
  // backPanelColor: const Color(0xFF191D19),
  backPanelColor: const Color(0xFF343434),
  mainTitleColor: const Color(0xFF00FF00),
  textColor1: const Color(0xFF00FF00),
  textColor2: const Color(0xFF00D600),
  textColor3: const Color(0xFF39B54A),
  textColorLight: const Color(0xFFD2E0D4),
  accentColor1: const Color(0xFFFF0000),
  accentColor2: const Color(0xFFB613B6),
  // keyOnColor: const Color(0xFFAA00AA),
  keyOnColor: const Color(0xFFADE0B3),
  keyOffColor: const Color(0xFF1C3415),
  reverseTextBg: const Color(0xFF084A00),
  reverseTextColor: Colors.black,
  screenColor: const Color(0xFF626655),
  screenTextOnColor: const Color(0xFF2f2f2f),
  screenTextOffColor: const Color(0xFF6E7261),
  correctGuessColor: const Color(0xFFACF896),
  myTimerColor: const Color(0xFFFF0000),
  oppTimerColor: const Color(0xFF084A00),
  playerOneBackground: const Color(0xFF829782),
  playerTwoBackground: const Color(0xff617f5f),
);

class ColorPalette {
  Color? backgroundColor;
  Color? backPanelColor;
  Color? mainTitleColor;
  Color? textColor1;
  Color? textColor2;
  Color? textColor3;
  Color? textColorLight;
  Color? accentColor1;
  Color? accentColor2;
  Color? keyOnColor;
  Color? keyOffColor;
  Color? reverseTextBg;
  Color? reverseTextColor;
  Color? screenColor;
  Color? screenTextOnColor;
  Color? screenTextOffColor;
  Color? correctGuessColor;
  Color? myTimerColor;
  Color? oppTimerColor;
  Color? playerOneBackground;
  Color? playerTwoBackground;

  ColorPalette({
    this.backgroundColor, this.backPanelColor, this.mainTitleColor,
    this.textColor1, this.textColor2, this.textColor3,
    this.textColorLight, this.accentColor1, this.accentColor2,
    this.keyOnColor, this.keyOffColor, this.reverseTextBg,
    this.reverseTextColor, this.screenColor, this.screenTextOnColor,
    this.screenTextOffColor, this.correctGuessColor, this.myTimerColor,
    this.oppTimerColor, this.playerOneBackground, this.playerTwoBackground,
  }) {
    backgroundColor = backgroundColor;
    mainTitleColor = mainTitleColor;
    textColor1 = textColor1;
    textColor2 = textColor2;
    textColor3 = textColor3;
    textColorLight = textColorLight;
    accentColor1 = accentColor1;
    accentColor2 = accentColor2;
    keyOnColor = keyOnColor;
    keyOffColor = keyOffColor;
    reverseTextBg = reverseTextBg;
    reverseTextColor = reverseTextColor;
    screenColor = screenColor;
    screenTextOnColor = screenTextOnColor;
    screenTextOffColor = screenTextOffColor;
    correctGuessColor = correctGuessColor;
    myTimerColor = myTimerColor;
    oppTimerColor = oppTimerColor;
    playerOneBackground = playerOneBackground;
    playerTwoBackground = playerTwoBackground;
  }
}