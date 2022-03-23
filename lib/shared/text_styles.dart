import 'package:bulls_n_cows_reloaded/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final TextStyle titleTextStyle = TextStyle(
    color: originalColors.textColor1, fontSize: 24, fontFamily: 'Mainframe');
final TextStyle reverseTitleTextStyle = TextStyle(
    color: originalColors.reverseTextColor,
    fontSize: 30,
    fontFamily: 'Mainframe');
final TextStyle defaultTextStyle = TextStyle(
    color: originalColors.textColor3, fontSize: 16, fontFamily: 'Mainframe');

final TextStyle textButtonStyle = TextStyle(
  color: originalColors.mainTitleColor,
  fontSize: 16,
  fontFamily: 'Mainframe',
);
final TextStyle exampleSecretNumberStyle = TextStyle(
  color: originalColors.accentColor2,
  fontSize: 32,
  fontFamily: 'Digital',
);
final TextStyle exampleGuessNumberStyle = TextStyle(
  color: originalColors.textColorLight,
  fontSize: 32,
  fontFamily: 'Digital',
);
final TextStyle exampleNumberStyleSmallLight = TextStyle(
  color: originalColors.textColorLight,
  fontSize: 24,
  fontFamily: 'Digital',
);

final TextStyle numberKeyOnStyle = TextStyle(
    color: originalColors.keyOnColor,
    fontFamily: 'Digital', fontSize: 42
);

final TextStyle numberKeyOffStyle = TextStyle(
    color: originalColors.keyOffColor, fontFamily: 'Digital', fontSize: 42);

final TextStyle screenDigitOnStyle = TextStyle(
    color: originalColors.screenTextOnColor,
    fontFamily: 'Digital',
    fontSize: 42);

final TextStyle screenDigitOffStyle = TextStyle(
  // color: const Color(0xFF6E7261),
    color: originalColors.screenTextOffColor,
    fontFamily: 'Digital',
    fontSize: 42);

final TextStyle profilePlayerDataKeyStyle = TextStyle(
  fontFamily: 'Digital',
  color: originalColors.textColor2,
  fontSize: 18,
);
final TextStyle profilePlayerDataValueStyle = TextStyle(
  fontFamily: 'Digital',
  color: originalColors.textColor3,
  fontSize: 18,
);

final TextStyle profilePlayerStatsSubTitleKeyStyle = TextStyle(
  fontFamily: 'Digital',
  color: originalColors.textColorLight,
  fontSize: 19,
);

final resultTextStyle = GoogleFonts.robotoMono(
    textStyle: TextStyle(
      color: originalColors.textColor3,
      fontSize: 24,
    ));

final guessTextStyle = GoogleFonts.robotoMono(
    textStyle: TextStyle(
      color: originalColors.textColor1,
      fontSize: 24,
    ));

final correctGuessStyle = GoogleFonts.robotoMono(
    textStyle: TextStyle(
        color: originalColors.correctGuessColor,
        fontSize: 24,
        fontWeight: FontWeight.bold));

final resultTextStyleVersus = GoogleFonts.robotoMono(
    textStyle: TextStyle(
      color: originalColors.textColor3,
      fontSize: 21,
    ));

final guessTextStyleVersusPlayer1 = GoogleFonts.robotoMono(
    textStyle: TextStyle(
      color: originalColors.textColor1,
      fontSize: 21,
    ));

final guessTextStyleVersusPlayer2 = GoogleFonts.robotoMono(
    textStyle: TextStyle(
      color: originalColors.textColor1,
      fontSize: 21,
    ));

final correctGuessStyleVersus = GoogleFonts.robotoMono(
    textStyle: TextStyle(
        color: originalColors.correctGuessColor,
        fontSize: 21,
        fontWeight: FontWeight.bold));

final TextStyle statsTitle =
TextStyle(color: originalColors.accentColor2, fontFamily: 'Mainframe');

final TextStyle statsSubTitle = TextStyle(
    color: originalColors.textColorLight, fontFamily: 'Mainframe');

final TextStyle statsText =
TextStyle(color: originalColors.textColor3, fontFamily: 'Mainframe');

final TextStyle playerProfileAccentTitle =
TextStyle(color: originalColors.accentColor2, fontFamily: 'Digital', fontSize: 18);

const TextStyle profilePlayerWhiteTextStyle = TextStyle(
  fontFamily: 'Digital',
  color: Colors.white,
  fontSize: 18,
);