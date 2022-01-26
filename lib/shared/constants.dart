
import 'package:bulls_n_cows_reloaded/repo/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'controllers/app_controller.dart';
import 'controllers/auth_controller.dart';

enum AuthState { anonymous, google, signedOut }
enum TtmMatchState { created, started, finished }

AuthController authController = AuthController.instance;
AppController appController = AppController.instance;
FirestoreService firestoreService = FirestoreService();

final Logger logger = Logger();
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
// FirebaseStorage storage = FirebaseStorage.instance;
// FirestoreRepo firestoreRepo = FirestoreRepo();
// StorageRepo storageRepo = StorageRepo();

const String playersTableName = 'players';
const String playerIdFN = 'id';
const String playerNameFN = 'name';
const String playerEmailFN = 'email';
const String playerPhoneFN = 'phone';
const String playerGoogleAvatarFN = 'google_avatar';
const String playerIsNewPlayerFN = 'is_new_user';
const String playerCreatedAtFN = 'created_at';

const String ttmMatchesTableName = 'ttm_matches';
const String ttmMatchPlayerIdFN = 'player_id';
const String ttmMatchSecretNumberFN = 'secret_num';
const String ttmMatchMovesFN = 'moves';
const String ttmMatchCreatedAtFN = 'created_at';

const String moveGuessFN = 'guess';
const String moveResultFN = 'move_result';
const String moveTimeStamp = 'timestamp';

const String moveDigitsFN = 'digits';
const String resultBullsFN = 'bulls';
const String resultCowsFN = 'cows';

ColorPalette originalColors = ColorPalette(
  backgroundColor: Colors.black,
  backPanelColor: const Color(0xFF252525),
  mainTitleColor: const Color(0xFF00FF00),
  textColor1: const Color(0xFF00FF00),
  textColor2: const Color(0xFF00D600),
  textColor3: const Color(0xFF39B54A),
  textColorLight: const Color(0xFFD2E0D4),
  accentColor1: const Color(0xFFFF0000),
  accentColor2: const Color(0xFFAA00AA),
  keyOnColor: const Color(0xFF286E02),
  keyOffColor: const Color(0xFF1C3415),
  reverseTextBg: const Color(0xFF084A00),
  reverseTextColor: Colors.black,
  screenColor: const Color(0xFFD6E2E2),
  screenTextOnColor: const Color(0xFF0B1808),
  screenTextOffColor: const Color(0xFF393939),
  correctGuessColor: const Color(0xFFACF896),
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

  ColorPalette({
    this.backgroundColor,
    this.backPanelColor,
    this.mainTitleColor,
    this.textColor1,
    this.textColor2,
    this.textColor3,
    this.textColorLight,
    this.accentColor1,
    this.accentColor2,
    this.keyOnColor,
    this.keyOffColor,
    this.reverseTextBg,
    this.reverseTextColor,
    this.screenColor,
    this.screenTextOnColor,
    this.screenTextOffColor,
    this.correctGuessColor,
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
  }
}