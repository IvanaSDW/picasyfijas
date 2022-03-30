import 'dart:async';
import 'package:bulls_n_cows_reloaded/shared/chronometer.dart';
import 'package:bulls_n_cows_reloaded/shared/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../data/ad_helper.dart';
import '../../../data/models/digit_match_result.dart';
import '../../../data/models/four_digits.dart';
import '../../../data/models/game_move.dart';
import '../../../data/models/player.dart';
import '../../../data/models/solo_game.dart';
import '../../../data/models/versus_game.dart';
import '../../../presentation/widgets/intercom_box/intercom_box_logic.dart';
import '../../../shared/constants.dart';
import '../../../shared/game_logic.dart';
import '../../widgets/chronometer_widget/chronometer_controller.dart';
import '../../widgets/numeric_keyboard/numeric_keyboard_controller.dart';

class VersusGameLogic extends GetxController {
  final NumericKeyboardController _keyboard = Get.put(NumericKeyboardController());

  //Ads logic
  InterstitialAd? _interstitialAd;
  static const int maxFailedLoadAttempts = 3;
  int _interstitialLoadAttempts = 0;

  bool _gameIsInitialized = false;

  final Rx<VersusGameStatus> _gameStatus = VersusGameStatus.unknown.obs;
  VersusGameStatus get gameStatus => _gameStatus.value;
  set gameStatus(VersusGameStatus value) => _gameStatus.value = value;

  late final bool iAmP1;
  late final DocumentReference<VersusGame> gameReference;

  final _playerOneData = Rxn<Player>();
  Player? get playerOneData => _playerOneData.value;
  set playerOneData(Player? value) => _playerOneData.value = value;

  final _playerTwoData = Rxn<Player>();
  Player? get playerTwoData => _playerTwoData.value;
  set playerTwoData(Player? value) => _playerTwoData.value = value;

  final RxBool _showNumberInput = false.obs;
  bool get showNumberInput => _showNumberInput.value;
  set showNumberInput(bool value) => _showNumberInput.value = value;

  final RxBool _showKeyboard = false.obs;
  bool get showKeyboard => _showKeyboard.value;
  set showKeyboard(bool value) => _showKeyboard.value = value;

  final RxBool _showFinalResult = false.obs;
  bool get showFinalResult => _showFinalResult.value;
  set showFinalResult(bool value) => _showFinalResult.value = value;

  final Rx<VersusPlayer> _whoIsToMove = VersusPlayer.unknown.obs;
  VersusPlayer get whoIsToMove => _whoIsToMove.value;
  set whoIsToMove(VersusPlayer value) => _whoIsToMove.value = value;

  late final Rx<VersusGame> _game;
  VersusGame get game => _game.value;
  set game(VersusGame game) => _game.value = game;

  final _playerOneGame = Rxn<SoloGame>();
  SoloGame? get playerOneGame => _playerOneGame.value;
  set playerOneGame(SoloGame? game) => _playerOneGame.value = game;

  final _playerTwoGame = Rxn<SoloGame>();
  SoloGame? get playerTwoGame => _playerTwoGame.value;
  set playerTwoGame(SoloGame? game) => _playerTwoGame.value = game;

  final IntercomBoxLogic intercom = Get.put(IntercomBoxLogic());
  final ChronometerController p1Timer = Get.put(
      ChronometerController(
        mode: ChronometerMode.countDown,
        countDownPresetMillis: versusModeTimePresetMillis,
        versusPlayer: VersusPlayer.player1,
      ),
      tag: 'p1'
  );
  final ChronometerController p2Timer = Get.put(
      ChronometerController(
        mode: ChronometerMode.countDown,
        countDownPresetMillis: versusModeTimePresetMillis,
        versusPlayer: VersusPlayer.player2,
      ),
      tag: 'p2'
  );

  final RxInt _p1TimeLeft = versusModeTimePresetMillis.obs;
  int get p1TimeLeft => _p1TimeLeft.value;
  set p1TimeLeft(int value) => _p1TimeLeft.value = value;

  final RxInt _p2TimeLeft = versusModeTimePresetMillis.obs;
  int get p2TimeLeft => _p2TimeLeft.value;
  set p2TimeLeft(int value) => _p2TimeLeft.value = value;

  double textHeight = 20;

  final ScrollController myScrollController = ScrollController();
  final ScrollController oppScrollController = ScrollController();
  final ScrollController bulletScrollController = ScrollController();
  bool needsScrollToLast = false;

  late Stream<DocumentSnapshot<VersusGame>> gameStateStream;
  late StreamSubscription gameStateListener;

  @override
  void onInit() async {
    super.onInit();
    gameStateStream = Get.arguments['gameStream'];
    iAmP1 = Get.arguments['isPlayerOne'];
    gameReference = Get.arguments['gameReference'];
    playerOneData = Get.arguments['playerOneObject'];
    playerTwoData = Get.arguments['playerTwoObject'];
    gameStateListener = gameStateStream.listen((event) { onGameStateReceived(event); });
    _keyboard.onNewInput((newInput) {
      if (showNumberInput) {
        onSecretNumberInput(newInput);
      } else {
        onThisPlayerNewGuess(newInput);
      }
    });
    ever(_whoIsToMove, (VersusPlayer value) => onToggleMove(value));
    if(iAmP1) {
      ever(appController.p1TimeIsUp, (bool value) => onMyTimeIsUp(value));
    } else {
      ever(appController.p2TimeIsUp, (bool value) => onMyTimeIsUp(value));
    }
    _createInterstitialAd();
  }

  final RxDouble progressValue = 0.0.obs;
  late final Timer inputSecretNumberTimer;

  void startInputSecretNumberProgress() {
    inputSecretNumberTimer = Timer.periodic(
        const Duration(milliseconds: 100),
            (timer) async {
          progressValue.value += 100;
          if (progressValue.value == 10000) {
            timer.cancel();
            logger.i('time is up');
            onAutoGenerateSecretNumber();
          }
        });
  }

  Future<void> onAutoGenerateSecretNumber() async {
    inputSecretNumberTimer.cancel();
    var secretNumber = generateSecretNum();
    iAmP1
        ? await firestoreService.addPlayerTwoSecretNumberToVersusGame(gameReference.id, secretNumber)
        : await firestoreService.addPlayerOneSecretNumberToVersusGame(gameReference.id, secretNumber);
    showNumberInput = false;
  }

  Future<void> onSecretNumberInput(FourDigits number) async {
    inputSecretNumberTimer.cancel();
    showNumberInput = false;
    iAmP1
        ? await firestoreService.addPlayerTwoSecretNumberToVersusGame(gameReference.id, number)
        : await firestoreService.addPlayerOneSecretNumberToVersusGame(gameReference.id, number);
  }

  Future<void> onGameStateReceived(DocumentSnapshot<VersusGame> gameSnapshot) async {

    if (_gameIsInitialized) {
      game = gameSnapshot.data()!;
      if (game.state == VersusGameStatus.cancelled) {
        gameStatus = VersusGameStatus.cancelled;
      }
      if (game.winByMode == WinByMode.opponentLeft || game.winByMode == WinByMode.opponentTimeUp) {
        if(game.winnerId == appController.currentPlayer.id) {
          onGameFinished();
        } else {
          if(game.winByMode == WinByMode.opponentTimeUp) onGameFinished();
        }
      }
    }

    switch (gameStatus) {
      case VersusGameStatus.unknown :
        _game = gameSnapshot.data()!.obs;
        _gameIsInitialized = true;
        gameStatus = VersusGameStatus.created;
        showNumberInput = true;
        startInputSecretNumberProgress();
        break;
      case VersusGameStatus.created :
        if (game.playerOneGame.secretNum != null && game.playerTwoGame.secretNum != null) {
          gameStatus = VersusGameStatus.started;
          continue started;
        } else {
        }
        break;

      started:
      case VersusGameStatus.started:
        playerOneGame = game.playerOneGame;
        playerTwoGame = game.playerTwoGame;
        if (playerOneGame!.moves.isNotEmpty) {
          p1TimeLeft = playerOneGame!.moves.last.timeStampMillis;
          if (playerOneGame!.moves.last.moveResult.bulls == 4) {
            gameStatus = VersusGameStatus.semiFinished;
            onGameSemiFinished();
          }
        }
        if (playerTwoGame!.moves.isNotEmpty) {
          p2TimeLeft = playerTwoGame!.moves.last.timeStampMillis;
          if (playerTwoGame!.moves.last.moveResult.bulls == 4) {
            p1Timer.stopTimer();
            p2Timer.stopTimer();
            gameStatus = VersusGameStatus.finished;
            continue finished;
          }
        }
        whoIsToMove = game.whoIsToMove;
        break;

      case VersusGameStatus.semiFinished:
        playerOneGame = game.playerOneGame;
        p1TimeLeft = playerOneGame!.moves.last.timeStampMillis;
        playerTwoGame = game.playerTwoGame;
        p2TimeLeft = playerTwoGame!.moves.last.timeStampMillis;
        if (playerTwoGame!.moves.length == playerTwoGame!.moves.length) {
          p2Timer.stopTimer();
          gameStatus = VersusGameStatus.finished;
          continue finished;
        } else {
          whoIsToMove = game.whoIsToMove;
        }
        break;

      finished:
      case VersusGameStatus.finished:
        onGameFinished();
        break;
      case VersusGameStatus.cancelled:
        Get.snackbar('game_canceled'.tr, 'game_was_canceled'.tr, backgroundColor: Colors.green);
        Future.delayed(const Duration(milliseconds: 1000), () => Get.back(closeOverlays: true));
        break;
    }
  }

  void onToggleMove(VersusPlayer whoIsToMove) {

    switch(whoIsToMove) {
      case VersusPlayer.unknown:
        break;
      case VersusPlayer.player1:
        addDummyMoveToPlayer(VersusPlayer.player1);
        p1Timer.timer.startFromNewPreset(p1TimeLeft);
        p2Timer.stopTimer();
        if (iAmP1) { // Is my move
          appController.playEffect('audio/beep-24.wav');
          HapticFeedback.mediumImpact();
          showKeyboard = true;
          switch (playerOneGame!.moves.length) {
            case 1:
              intercom.postMessage('time_is_running_input_your_guess'.tr);
              break;
            case 2:
              intercom.postMessage('you_can_do_it_try_your_guess'.tr);
              break;
            default:
              break;
          }
        } else { //I am player two, player 1 is moving...
          showKeyboard = false;
          switch (playerTwoGame!.moves.length) {
            case 0:
              intercom.postMessage('be_ready_for_your_second_guess'.tr);
              break;
            case 1:
              intercom.postMessage('think_your_next_guess'.tr);
              break;
            default:
              break;
          }
        }
        break;
      case VersusPlayer.player2:
        addDummyMoveToPlayer(VersusPlayer.player2);
        p1Timer.stopTimer();
        p2Timer.restartFromNewPreset(p2TimeLeft);
        // playerTwoTimer.startTimer();
        if (iAmP1) { // Player2 is moving
          showKeyboard = false;
          switch (playerTwoGame!.moves.length) {
            case 1:
              intercom.postMessage('be_ready_for_your_second_guess'.tr);
              break;
            case 2:
              intercom.postMessage('think_of_a_smart_guess_for_your next_move'.tr);
              break;
            default:
              break;
          }
        } else { // I am player 2 and is my move
          showKeyboard = true;
          HapticFeedback.mediumImpact();
          switch (playerTwoGame!.moves.length) {
            case 1:
              intercom.postMessage('time_is_running_input_your_guess'.tr);
              break;
            case 2:
              intercom.postMessage('you_can_do_it_try_your_guess'.tr);
              break;
            default:
              break;
          }
        }
        break;
      case VersusPlayer.none:
        p1Timer.stopTimer();
        p2Timer.stopTimer();
        break;
    }
  }

  void addDummyMoveToPlayer(VersusPlayer player) {
    if (player == VersusPlayer.player1) {
      _playerOneGame.update((val) {
        val!.moves.add(GameMove.dummy());
      });
    } else {
      _playerTwoGame.update((val) {
        val!.moves.add(GameMove.dummy());
      });
    }
    needsScrollToLast = true;
  }

  void onGameSemiFinished() {
    if (iAmP1) {
      intercom.postMessage('cross_your_fingers'.tr);
    } else { //I am player 2 and this is my last shot
      intercom.postMessage('you_better_find_it_now'.tr);
    }
  }

  void scrollToLastItem() {
    myScrollController.animateTo(myScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    oppScrollController.animateTo(myScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    bulletScrollController.animateTo(myScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    needsScrollToLast = false;
  }

  void onContinuePressed() {
    _showInterstitialAd();
    Get.back();
  }

  Future<void> onThisPlayerNewGuess(FourDigits guess) async {
    if (iAmP1) {
      DigitMatchResult guessResult = getMatchResult(playerOneGame!.secretNum!, guess);
      GameMove newMove = GameMove(
        guess: guess,
        moveResult: guessResult,
        timeStampMillis: p1Timer.timer.rawTime.value,
      );
      needsScrollToLast = true;
      await firestoreService.addMoveToPlayerOneInVersusGame(gameReference, newMove);
    } else { //I am player two
      DigitMatchResult guessResult = getMatchResult(playerTwoGame!.secretNum!, guess);
      GameMove newMove = GameMove(
        guess: guess,
        moveResult: guessResult,
        timeStampMillis: p2Timer.timer.rawTime.value,
      );
      if (gameStatus == VersusGameStatus.semiFinished) {
        firestoreService.addLastMoveToPlayerTwoInVersusGame(gameReference, newMove);
      } else {
        firestoreService.addMoveToPlayerTwoInVersusGame(gameReference, newMove);
      }
    }
  }

  Future<void> onMyTimeIsUp(bool isMyTimeUp) async {
    if (!isMyTimeUp) return;
    if (iAmP1) {
      WinnerPlayer winnerPlayer = WinnerPlayer.player2;
      WinByMode winByMode = WinByMode.opponentTimeUp;
      String winnerId = playerTwoData!.id!;
      firestoreService.addFinalResultToVersusGame(
          gameReference: gameReference,
          winnerPlayer: winnerPlayer,
          winByMode: winByMode,
          winnerId: winnerId
      );
      appController.setP1TimeIsUp = false;
    } else { //I am player two and my time is up
      WinnerPlayer winnerPlayer = WinnerPlayer.player1;
      WinByMode winByMode = WinByMode.opponentTimeUp;
      String winnerId = playerOneData!.id!;
      await firestoreService.addFinalResultToVersusGame(
          gameReference: gameReference,
          winnerPlayer: winnerPlayer,
          winByMode: winByMode,
          winnerId: winnerId
      );
      appController.setP2TimeIsUp = false;
    }
  }

  void onGameFinished() {
    if (iAmP1) {
      if(game.winnerPlayer == null) {
      } else {
        showFinalResult = true;
        appController.needUpdateVsStats.value = true;
      }
    } else { // I am player 2
      if (game.winnerPlayer == null) {
        WinnerPlayer winnerPlayer;
        WinByMode winByMode;
        String winnerId;
        if (game.playerTwoGame.moves.last.moveResult.bulls == 4) { //I found number
          if (game.playerOneGame.moves.last.moveResult.bulls == 4) { // Both players found it equal in moves, need judge by time
            int playerOneTimeLeft = game.playerOneGame.moves.last.timeStampMillis ~/1000;
            int playerTwoTimeLeft = game.playerTwoGame.moves.last.timeStampMillis ~/1000;
            if (playerOneTimeLeft == playerTwoTimeLeft) { //Equal in moves and time => draw
              winnerPlayer = WinnerPlayer.draw;
              winByMode = WinByMode.draw;
              winnerId = 'draw';
            } else if (playerOneTimeLeft > playerTwoTimeLeft) { //Player one won by time, i lost
              winnerPlayer = WinnerPlayer.player1;
              winByMode = WinByMode.time;
              winnerId = game.playerOneId;
            } else { //I am player two and won by time
              winnerPlayer = WinnerPlayer.player2;
              winByMode = WinByMode.time;
              winnerId = game.playerTwoId;
            }
          } else { // //I found first and I am player 2, so I am winner by moves
            winnerPlayer = WinnerPlayer.player2;
            winByMode = WinByMode.moves;
            winnerId = game.playerTwoId;
          }
        } else { //I fail my last shot so I lost by moves
          winnerPlayer = WinnerPlayer.player1;
          winByMode = WinByMode.moves;
          winnerId = game.playerOneId;
        }
        firestoreService.addFinalResultToVersusGame(
            gameReference: gameReference,
            winnerPlayer: winnerPlayer,
            winByMode: winByMode,
            winnerId: winnerId
        );
      } else {
        showFinalResult = true;
        appController.needUpdateVsStats.value = true;
      }
    }
  }


  Future<bool> onBackPressed() async {
    if (showFinalResult) return true;
    String middleText = '';
    if (iAmP1) {
      if (playerOneGame!.moves.isEmpty) {
        middleText = 'your_opponent_is_still_active'.tr;
      } else if(playerOneGame!.moves.length == 1 && playerOneGame!.moves.last.guess.isDummy()) {
        middleText = 'your_opponent_is_still_active'.tr;
      } else {
        middleText = 'You_will_loose_this_game_if_quit_now'.tr;
      }
    } else { // I am player 2
      if (playerTwoGame!.moves.isEmpty) {
        middleText = 'your_opponent_is_still_active'.tr;
      } else {
        middleText = 'You_will_loose_this_game_if_quit_now'.tr
        ;
      }
    }
    Get.defaultDialog(
      title: 'press_quit_to_leave_game'.tr,
      middleText: middleText,
      textConfirm: 'quit'.tr,
      textCancel: 'cancel'.tr,
      backgroundColor: Colors.green.withOpacity(0.5),
      buttonColor: originalColors.accentColor2,
      cancelTextColor: originalColors.reverseTextColor,
      confirmTextColor: originalColors.textColorLight,
      onConfirm: onQuitGame,
    );
    return false;
  }

  void onCancelGame() async {
    await firestoreService.updateVersusGameStatus(gameReference, VersusGameStatus.cancelled);
  }

  void onQuitGame() {
    if (iAmP1) {
      if(game.playerOneGame.moves.isEmpty) { //Game cancelled by me
        logger.i('Cancelled by me before first move');
        onCancelGame();
      } else if (game.playerOneGame.moves.last.guess.isDummy()) {
        // Cancelled by this player before first move
        onCancelGame();
      } else {
        WinnerPlayer winnerPlayer = WinnerPlayer.player2;
        WinByMode winByMode = WinByMode.opponentLeft;
        String winnerId = playerTwoData!.id!;
        firestoreService.addFinalResultToVersusGame(
            gameReference: gameReference,
            winnerPlayer: winnerPlayer,
            winByMode: winByMode,
            winnerId: winnerId
        );
      }
    } else { //I am player 2
      if (game.playerTwoGame.moves.isEmpty) {
        onCancelGame();
      } else {
        WinnerPlayer winnerPlayer = WinnerPlayer.player1;
        WinByMode winByMode = WinByMode.opponentLeft;
        String winnerId = playerOneData!.id!;
        firestoreService.addFinalResultToVersusGame(
            gameReference: gameReference,
            winnerPlayer: winnerPlayer,
            winByMode: winByMode,
            winnerId: winnerId
        );
      }
    }
    appController.playEffect('audio/door-open.wav');
    Get.back(closeOverlays: true);
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.afterVersusGameInterstitialAdUnitId,
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
    super.dispose();
    gameStateListener.cancel();
    _interstitialAd?.dispose();
  }

  @override
  void onClose() {
    gameStateListener.cancel();
  }
}
