import 'package:bulls_n_cows_reloaded/domain/solo_games_use_cases.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/chronometer_widget/chronometer_controller.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/player_data_display/player_stats_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/chronometer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../data/ad_helper.dart';
import '../../../data/models/digit_match_result.dart';
import '../../../data/models/four_digits.dart';
import '../../../data/models/game_move.dart';
import '../../../data/models/solo_game.dart';
import '../../../presentation/widgets/intercom_box/intercom_box_logic.dart';
import '../../../shared/constants.dart';
import '../../../shared/game_logic.dart';
import '../../widgets/numeric_keyboard/numeric_keyboard_controller.dart';

class SoloGameLogic extends GetxController {
  final NumericKeyboardController _keyboard = Get.find();
  final SaveSoloGameToFirestoreUC _saveSoloMatchToFS = SaveSoloGameToFirestoreUC();

  //Ads logic
  InterstitialAd? _interstitialAd;
  static const int maxFailedLoadAttempts = 3;
  int _interstitialLoadAttempts = 0;

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
      mode: ChronometerMode.countUp,
      countDownPresetMillis: versusModeTimePresetMillis,
    versusPlayer: VersusPlayer.none,
  ));

  double textHeight = 24;

  final ScrollController scrollController = ScrollController();
  bool needsScrollToLast = false;

  @override
  void onInit() async {
    super.onInit();
    if(appController.currentPlayer.id == null) await appController.refreshPlayer();
    _match = SoloGame(
      playerId: appController.currentPlayer.id!,
      secretNum: generateSecretNum(),
      moves: <GameMove>[],
      createdAt: Timestamp.now(),
    ).obs;
    _keyboard.onNewInput((newInput) => onNewGuess(newInput));
    _createInterstitialAd();
  }

  void startSinglePlayerMatch() {
    matchState = SoloGameStatus.started;
    match.moves.add(GameMove.dummy());
    timer.startTimer();
    intercom.postMessage('time_is_running_input_your_guess'.tr);
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
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    needsScrollToLast = false;
  }

  void onContinuePressed() {
    Get.back();
    _showInterstitialAd();
  }

  void onNewGuess(FourDigits guess) {
    DigitMatchResult guessResult = getMatchResult(match.secretNum!, guess);
    GameMove newMove = GameMove(
        guess: guess,
        moveResult: guessResult,
        timeStampMillis:
        Get.find<ChronometerController>().timer.rawTime.value
    );
    _match.update((value) {
      value!.moves.last = newMove;
    });
    if (match.moves.length == 1) {
      intercom.postMessage('good_continue_until_you_find_it'.tr);
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
    await _saveSoloMatchToFS(match)
        .then((value) async {
      appController.needUpdateSoloStats.value = true;
      logger.i('isVsUnlocked is: ${appController.currentPlayer.isVsUnlocked}');
      if(!appController.currentPlayer.isVsUnlocked!) await Get.find<PlayerStatsController>().refreshStats(auth.currentUser!.uid);
    });
    intercom.postMessage('mission_successfully_completed'.tr);
  }

  Future<bool> onBackPressed() async {
    appController.playEffect('audio/door-open.wav');
    return true;
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      // adUnitId: AdHelper.testInterstitialAdUnitId,
      adUnitId: AdHelper.afterSoloGameInterstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialLoadAttempts = 0;
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_interstitialLoadAttempts <= maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  void _showInterstitialAd() {
    logger.i('called');
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

}
