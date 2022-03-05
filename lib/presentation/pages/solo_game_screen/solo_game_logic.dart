import 'package:bulls_n_cows_reloaded/domain/solo_games_use_cases.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/stop_watch_widget/chronometer_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/chronometer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/models/digit_match_result.dart';
import '../../../data/models/four_digits.dart';
import '../../../data/models/game_move.dart';
import '../../../data/models/solo_game.dart';
import '../../../presentation/widgets/intercom_box/intercom_box_logic.dart';
import '../../../shared/constants.dart';
import '../../../shared/game_logic.dart';
import '../../controllers/numeric_keyboard_controller.dart';


class SoloGameLogic extends GetxController {
  final NumericKeyboardController _keyboardLogic = Get.find();
  final SaveSoloGameToFirestoreUC _saveSoloMatchToFS = SaveSoloGameToFirestoreUC();

  late Rx<SoloGame> _match;
  SoloGame get match => _match.value;
  set match(SoloGame match) => _match.value = match;

  final Rx<SoloGameStatus> _matchState = SoloGameStatus.created.obs;
  SoloGameStatus get matchState => _matchState.value;
  set matchState(SoloGameStatus value) => _matchState.value = value;

  final RxBool _numberFound = false.obs;
  bool get numberFound => _numberFound.value;
  set numberFound(bool value) => _numberFound.value = value;

  final IntercomBoxLogic intercom = Get.put(IntercomBoxLogic());
  final ChronometerController timer = Get.put(ChronometerController(
      mode: ChronometerMode.countUp, countDownPresetMillis: versusModeTimePresetMillis));

  double textHeight = 24;

  final ScrollController scrollController = ScrollController();
  bool needsScrollToLast = false;

  @override
  void onInit() async {
    super.onInit();
    _match = SoloGame(
      playerId: appController.currentPlayer.id!,
      secretNum: generateSecretNum(),
      moves: <GameMove>[],
      createdAt: Timestamp.now(),
    ).obs;
    logger.i('Secret number: ${match.secretNum!.toJson()}');
    ever(_keyboardLogic.newGuess, (FourDigits value) => onNewGuess(value));
  }

  void startSinglePlayerMatch() {
    matchState = SoloGameStatus.started;
    match.moves.add(GameMove.dummy());
    timer.startTimer();
    intercom.postMessage('Time is running!!, input your guess...');
  }

  void onSignOutTapped() async {
    authService.removeUserAccount(auth.currentUser!);
    authService.signOut();
    firestoreService
        .deletePlayer(appController.currentPlayer.id!);
  }

  onInstructionsContinueTapped() {
    firestoreService
        .falseIsNewPlayer(appController.currentPlayer.id!);
  }

  void scrollToLastItem() {
    logger.i('Scrolling to last item...');
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    needsScrollToLast = false;
  }

  void onContinuePressed() {
    Get.back();
  }

  void onNewGuess(FourDigits guess) {
    logger.i('onNewGuess-> called with guess: $guess');
    DigitMatchResult guessResult = getMatchResult(match.secretNum!, guess);
    GameMove newMove = GameMove(
        guess: guess,
        moveResult: guessResult,
        timeStampMillis:
        Get.find<ChronometerController>().timer.rawTime.value
    );
    _match.update((_) {
      match.moves[match.moves.length - 1] = newMove;
    });
    if (match.moves.length == 1) {
      intercom.postMessage('Good, continue until you find it!');
    }
    if (guessResult.bulls == 4) {
      onNumberFound();
    } else {
      _match.update((val) {
        match.moves.add(GameMove.dummy());
      });
      needsScrollToLast = true;
    }
  }

  void onNumberFound() async {
    numberFound = true;
    matchState = SoloGameStatus.finished;
    timer.stopTimer();
    _saveSoloMatchToFS(match)
        .then((value) => appController.needUpdateSoloStats.value = true);
    intercom.postMessage('Mission successfully completed!');
  }

  Future<bool> onBackPressed() async {
    appController.playEffect('audio/door-open.wav');
    return true;
  }

}
