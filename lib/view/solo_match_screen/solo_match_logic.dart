import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../model/digit_match_result.dart';
import '../../model/four_digits.dart';
import '../../model/match_move.dart';
import '../../model/solo_match.dart';
import '../../repo/firestore_service.dart';
import '../../shared/constants.dart';
import '../../shared/game_logic.dart';
import '../../shared/widgets/intercom_box/intercom_box_logic.dart';
import '../../shared/widgets/numeric_keyboard/numeric_keyboard_logic.dart';
import '../../shared/widgets/stop_watch_widget/stop_watch_widget_logic.dart';

class SoloMatchLogic extends GetxController {
  final NumericKeyboardLogic keyboardLogic = Get.put(NumericKeyboardLogic());
  // final FirestoreService firestoreService = FirestoreService();

  late Rx<SoloMatch> _match;
  SoloMatch get match => _match.value;
  set match(SoloMatch match) => _match.value = match;

  final Rx<TtmMatchState> _matchState = TtmMatchState.created.obs;
  TtmMatchState get matchState => _matchState.value;
  set matchState(TtmMatchState value) => _matchState.value = value;

  final RxBool _numberFound = false.obs;
  bool get numberFound => _numberFound.value;
  set numberFound(bool value) => _numberFound.value = value;

  final IntercomBoxLogic intercom = Get.put(IntercomBoxLogic());
  final StopWatchWidgetLogic timer = Get.put(StopWatchWidgetLogic());

  double textHeight = 24;

  final ScrollController scrollController = ScrollController();
  bool needsScrollToLast = false;

  @override
  void onInit() async {
    super.onInit();
    _match = SoloMatch(
      playerId: appController.currentPlayer.id!,
      secretNum: generateSecretNum(),
      moves: <MatchMove>[],
      createdAt: Timestamp.now(),
    ).obs;
    logger.i('Secret number: ${match.secretNum.toJson()}');
    ever(keyboardLogic.newGuess, (FourDigits value) => onNewGuess(value));
  }

  void startSinglePlayerMatch() {
    matchState = TtmMatchState.started;
    match.moves.add(MatchMove.fake());
    timer.startTimer();
    intercom.postMessage('Time is running!!, input your guess...');
  }

  void onSignOutTapped() async {
    authController.removeUserAccount();
    authController.signOut();
    FirestoreService()
        .deletePlayer(appController.currentPlayer.id!);
  }

  onInstructionsContinueTapped() {
    FirestoreService()
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
    DigitMatchResult guessResult = getMatchResult(match.secretNum, guess);
    MatchMove newMove = MatchMove(
        guess: guess,
        moveResult: guessResult,
        timeStampMillis:
        Get.find<StopWatchWidgetLogic>().timer.rawTime.value
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
        match.moves.add(MatchMove.fake());
      });
      needsScrollToLast = true;
    }
  }

  void onNumberFound() async {
    numberFound = true;
    matchState = TtmMatchState.finished;
    timer.stopTimer();
    await firestoreService.saveSoloMatchToFirestore(match)
    .then((value) => appController.needUpdateSoloStats.value = true);
    // intercom.postMessage('You\'ve unlocked full modes, tap CONTINUE!');
    intercom.postMessage('Mission successfully completed!');
  }

  Future<bool> onBackPressed() async {
    appController.playEffect('audio/door-open.wav');
    return true;
  }

}
