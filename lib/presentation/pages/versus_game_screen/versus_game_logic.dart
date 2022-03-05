import 'dart:async';
import 'dart:convert';
import 'package:bulls_n_cows_reloaded/presentation/widgets/stop_watch_widget/chronometer_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/chronometer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/digit_match_result.dart';
import '../../../data/models/four_digits.dart';
import '../../../data/models/game_move.dart';
import '../../../data/models/player.dart';
import '../../../data/models/solo_game.dart';
import '../../../data/models/versus_game.dart';
import '../../../presentation/widgets/intercom_box/intercom_box_logic.dart';
import '../../../shared/constants.dart';
import '../../../shared/game_logic.dart';
import '../../controllers/numeric_keyboard_controller.dart';

class VersusGameLogic extends GetxController {
  final NumericKeyboardController keyboardLogic = Get.put(NumericKeyboardController());

  bool _gameIsInitialized = false;

  late final bool iAmPlayerOne;
  late final DocumentReference<VersusGame> gameReference;

  final _playerOneData = Rxn<Player>();
  Player? get playerOneData => _playerOneData.value;
  set playerOneData(Player? value) => _playerOneData.value = value;

  final _playerTwoData = Rxn<Player>();
  Player? get playerTwoData => _playerTwoData.value;
  set playerTwoData(Player? value) => _playerTwoData.value = value;

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

  final Rx<VersusGameStatus> _gameStatus = VersusGameStatus.unknown.obs;
  VersusGameStatus get gameStatus => _gameStatus.value;
  set gameStatus(VersusGameStatus value) => _gameStatus.value = value;

  final IntercomBoxLogic intercom = Get.put(IntercomBoxLogic());
  final ChronometerController playerOneTimer = Get.put(
      ChronometerController(
          mode: ChronometerMode.countDown,
          countDownPresetMillis: versusModeTimePresetMillis
      ),
      tag: 'p1'
  );
  final ChronometerController playerTwoTimer = Get.put(
      ChronometerController(
          mode: ChronometerMode.countDown,
          countDownPresetMillis: versusModeTimePresetMillis
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
    iAmPlayerOne = Get.arguments['isPlayerOne'];
    gameReference = Get.arguments['gameReference'];
    playerOneData = Get.arguments['playerOneObject'];
    playerTwoData = Get.arguments['playerTwoObject'];
    gameStateListener = gameStateStream.listen((event) { onGameStateReceived(event); });
    ever(keyboardLogic.newGuess, (FourDigits guess) => onThisPlayerNewGuess(guess));
    ever(_whoIsToMove, (VersusPlayer value) => onToggleMove(value));
  }

  Future<void> onGameStateReceived(DocumentSnapshot<VersusGame> gameSnapshot) async {
    logger.i('iAmPlayerOne = $iAmPlayerOne   --  Current status is: $gameStatus');
    logger.i('Received game update: ${gameSnapshot.data()!.toJson()},');
    logger.i('winnerPlayer in snapshot is: ${gameSnapshot.data()!.winnerPlayer}');

    if (_gameIsInitialized) game = gameSnapshot.data()!;

    switch (gameStatus) {
      case VersusGameStatus.unknown :
        _game = gameSnapshot.data()!.obs;
        _gameIsInitialized = true;
        gameStatus = VersusGameStatus.created;
        iAmPlayerOne
            ? await firestoreService.addPlayerTwoSecretNumberToVersusGame(gameReference.id, generateSecretNum())
            : await firestoreService.addPlayerOneSecretNumberToVersusGame(gameReference.id, generateSecretNum());
        logger.i('added secret number to player in firestore');
        break;

      case VersusGameStatus.created :
        if (game.playerOneGame.secretNum != null && game.playerTwoGame.secretNum != null) {
          logger.i('Both players ready...');
          gameStatus = VersusGameStatus.started;
          continue started;
        } else {
          logger.i('Players still not ready...');
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
            logger.i('player 2 found the number first. Game needs to be finished...');
            playerOneTimer.stopTimer();
            playerTwoTimer.stopTimer();
            gameStatus = VersusGameStatus.finished;
            continue finished;
          }
        }
        whoIsToMove = game.whoIsToMove;
        break;

      case VersusGameStatus.semiFinished:
      // game = gameSnapshot.data()!;
        playerOneGame = game.playerOneGame;
        p1TimeLeft = playerOneGame!.moves.last.timeStampMillis;
        playerTwoGame = game.playerTwoGame;
        p2TimeLeft = playerTwoGame!.moves.last.timeStampMillis;
        if (playerTwoGame!.moves.length == playerTwoGame!.moves.length) {
          playerTwoTimer.stopTimer();
          logger.i('player 2 completed last move, game is finished...');
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
    }
    logger.i('After state is $gameStatus, player to move = $whoIsToMove, p1Time: $p1TimeLeft, p2Time: $p2TimeLeft');
  }

  void onToggleMove(VersusPlayer whoIsToMove) {

    switch(whoIsToMove) {
      case VersusPlayer.unknown:
        break;
      case VersusPlayer.player1:
        addDummyMoveToPlayer(VersusPlayer.player1);
        // if(Get.isRegistered<StopWatchController>(tag: 'p1')) Get.delete<StopWatchController>(tag: 'p1');
        // playerOneTimer = Get.put(StopWatchController(mode: StopWatchMode.countDown, countDownPresetMillis: p1TimeLeft));
        playerOneTimer.timer.startFromNewPreset(p1TimeLeft);
        // playerOneTimer.startTimer();
        playerTwoTimer.stopTimer();
        if (iAmPlayerOne) { // Is my move
          logger.i('Is this player move ');
          showKeyboard = true;
          switch (playerOneGame!.moves.length) {
            case 1:
              intercom.postMessage('Time is running!!, input your guess...');
              break;
            case 2:
              intercom.postMessage('You can do it, try your guess...');
              break;
            default:
              break;
          }
        } else { //I am player two, player 1 is moving...
          showKeyboard = false;
          switch (playerTwoGame!.moves.length) {
            case 0:
              intercom.postMessage('Be ready for you first guess...');
              break;
            case 1:
              intercom.postMessage('Think your next guess..');
              break;
            default:
              break;
          }
        }
        break;
      case VersusPlayer.player2:
        addDummyMoveToPlayer(VersusPlayer.player2);
        playerOneTimer.stopTimer();
        playerTwoTimer.startTimer();
        if (iAmPlayerOne) { // Player2 is moving
          logger.i('Is opponent move ');
          showKeyboard = false;
          switch (playerTwoGame!.moves.length) {
            case 1:
              intercom.postMessage('Be ready for you second guess...');
              break;
            case 2:
              intercom.postMessage('Think of a smart guess for your next one..');
              break;
            default:
              break;
          }
        } else { // I am player 2 and is my move
          showKeyboard = true;
          switch (playerTwoGame!.moves.length) {
            case 1:
              intercom.postMessage('Time is running!!, input your guess...');
              break;
            case 2:
              intercom.postMessage('You can do it, try your guess...');
              break;
            default:
              break;
          }
        }
        break;
      case VersusPlayer.none:
        playerOneTimer.stopTimer();
        playerTwoTimer.stopTimer();
        break;
    }
  }

  void addDummyMoveToPlayer(VersusPlayer player) {
    logger.i('called for $player');
    if (player == VersusPlayer.player1) {
      _playerOneGame.update((val) {
        val!.moves.add(GameMove.dummy());
        logger.i('moves are now: ${jsonEncode(
            playerOneGame!.moves)}, qty = ${playerOneGame!.moves.length}');
      });
    } else {
      _playerTwoGame.update((val) {
        val!.moves.add(GameMove.dummy());
        logger.i('moves are now: ${jsonEncode(playerTwoGame!.moves)}, qty = ${playerTwoGame!.moves.length}');
      });
    }
    needsScrollToLast = true;
  }

  void onGameSemiFinished() {
    if (iAmPlayerOne) {
      intercom.postMessage('Cross your fingers! opponent still have one shot...');
    } else { //I am player 2 and this is my last shot
      intercom.postMessage('You better find it now...');
    }
  }

  void scrollToLastItem() {
    logger.i('Scrolling to last item...');
    myScrollController.animateTo(myScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    oppScrollController.animateTo(myScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    bulletScrollController.animateTo(myScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    needsScrollToLast = false;
  }

  void onContinuePressed() {
    Get.back();
  }

  Future<void> onThisPlayerNewGuess(FourDigits guess) async {
    logger.i('onNewGuess-> called with guess: ${guess.toJson()}');
    if (iAmPlayerOne) {
      DigitMatchResult guessResult = getMatchResult(playerOneGame!.secretNum!, guess);
      GameMove newMove = GameMove(
        guess: guess,
        moveResult: guessResult,
        timeStampMillis: playerOneTimer.timer.rawTime.value,
      );
      needsScrollToLast = true;
      logger.i('Proceeding to add one move of player one...');
      await firestoreService.addMoveToPlayerOneInVersusGame(gameReference, newMove);
    } else { //I am player two
      DigitMatchResult guessResult = getMatchResult(playerTwoGame!.secretNum!, guess);
      GameMove newMove = GameMove(
        guess: guess,
        moveResult: guessResult,
        timeStampMillis: playerTwoTimer.timer.rawTime.value,
      );
      logger.i('Proceeding to add one move of player two...');
      if (gameStatus == VersusGameStatus.semiFinished) {
        firestoreService.addLastMoveToPlayerTwoInVersusGame(gameReference, newMove);
      } else {
        firestoreService.addMoveToPlayerTwoInVersusGame(gameReference, newMove);
      }
    }
  }

  void onGameFinished() {
    logger.i('called');
    if (iAmPlayerOne) {
      if(game.winnerPlayer == null) {
        logger.i('Still not received final result...');
      } else {
        logger.i('As player1, received final result from firestore');
        showFinalResult = true;
      }
    } else { // I am player 2
      if (game.winnerPlayer == null) {
        logger.i('As player 2, proceeding to judge game and update firestore...');
        WinnerPlayer winnerPlayer;
        WinByMode winByMode;
        String winnerId;
        if (game.playerTwoGame.moves.last.moveResult.bulls == 4) { //I found number
          if (game.playerOneGame.moves.last.moveResult.bulls == 4) { // Both players found it equal in moves, need judge by time
            int playerOneTimeLeft = game.playerOneGame.moves.last.timeStampMillis ~/1000;
            int playerTwoTimeLeft = game.playerTwoGame.moves.last.timeStampMillis ~/1000;
            logger.i('Player one time left: $playerOneTimeLeft - Player two: $playerTwoTimeLeft');
            if (playerOneTimeLeft == playerTwoTimeLeft) { //Equal in moves and time => draw
              winnerPlayer = WinnerPlayer.draw;
              winByMode = WinByMode.unknown;
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
        logger.i('As player2, received final result from firestore');
        showFinalResult = true;
      }
    }
  }


  Future<bool> onBackPressed() async {
    appController.playEffect('audio/door-open.wav');
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    gameStateListener.cancel();
  }

  @override
  void onClose() {
    gameStateListener.cancel();
  }
}
