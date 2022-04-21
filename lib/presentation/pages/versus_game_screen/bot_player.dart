import 'dart:math';
import 'package:bulls_n_cows_reloaded/data/models/four_digits.dart';
import 'package:bulls_n_cows_reloaded/data/models/versus_game.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/versus_game_screen/versus_game_logic.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/player_data_display/player_stats_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../data/models/game_move.dart';
import '../../../data/models/solo_game.dart';

class NeoBot {
  DocumentReference gameReference;
  late SoloGame botGame;
  late FourDigits secretNumber;

  NeoBot({
    required this.gameReference,
  });

  Future<void> initMatch() async {
    logger.i('called for game: ${gameReference.id}');
    await (firestoreService.versusGames.doc(gameReference.id) as DocumentReference<VersusGame>).get()
        .then((value) {
      if (value.exists) {
        logger.i('Secret number to look for is: ${value.data()!.playerTwoGame.secretNum!.toString()}');
        secretNumber = value.data()!.playerTwoGame.secretNum!;
      }
    });
    await firestoreService.getLastThousandSoloGames()
        .then((value) {
      if (value.isEmpty) {
        logger.i('No games found');
      } else {
        List<SoloGame> finishedGames = value.where((element) => element.moves.last.moveResult.bulls == 4).toList();
        List<SoloGame> goodGames = finishedGames.where((element) => element.moves.first.timeStampMillis <= 12000).toList();
        List<SoloGame> whereSecretNumber = goodGames.where((element) => element.secretNum.toString() == secretNumber.toString()).toList();

        if (whereSecretNumber.isEmpty) {
          logger.i('No games found with secret number: ${secretNumber.toString()}');
          botGame = generateBotGameScript(secretNumber, goodGames);
          logger.i('Converted game: ${botGame.toJson()}');
        } else {
          int index = Random().nextInt(whereSecretNumber.length);
          botGame = whereSecretNumber[index];
          logger.i('Found game: ${botGame.toJson()}');
        }
      }
    });
  }
  Future<void> move(int moveIndex) async {
    logger.i('Bot move number: $moveIndex');
    logger.i('Game status is: ${Get.find<VersusGameLogic>().gameStatus}');
    GameMove newMove = botGame.moves[moveIndex];
    int previousMoveTimeStamp = moveIndex == 0 ? 0 : versusModeTimePresetMillis - botGame.moves[moveIndex-1].timeStampMillis;
    int thisMoveTimeStamp = botGame.moves[moveIndex].timeStampMillis;
    int delayToMove = thisMoveTimeStamp - previousMoveTimeStamp;
    newMove.timeStampMillis = versusModeTimePresetMillis - newMove.timeStampMillis;
    logger.i('previous: $previousMoveTimeStamp, this: $thisMoveTimeStamp, delayTime: $delayToMove');
    await Future.delayed(Duration(milliseconds: delayToMove));
    if (Get.find<VersusGameLogic>().gameStatus == VersusGameStatus.semiFinished) {
      firestoreService.addLastMoveToPlayerTwoInVersusGame(gameReference, newMove);
    } else {
      firestoreService.addMoveToPlayerTwoInVersusGame(gameReference, newMove);
    }

  }

  void onBotTimeIsUp(bool isBotTimeUp) async {
    logger.i('called');
    if (!isBotTimeUp) return;
    WinnerPlayer winnerPlayer = WinnerPlayer.player1;
    WinByMode winByMode = WinByMode.opponentTimeUp;
    String winnerId = Get.find<VersusGameLogic>().playerOneData!.id!;
    await firestoreService.addFinalResultToVersusGame(
        gameReference: gameReference,
        winnerPlayer: winnerPlayer,
        winByMode: winByMode,
        winnerId: winnerId
    );
    logger.i('Bot reported player 1 as winner for bot time up.');
    appController.setP2TimeIsUp = false;
  }

  Future<void> onGameFinished(VersusGame game) async {
    logger.i('Called');
    if (game.winnerPlayer == null) {
      WinnerPlayer winnerPlayer;
      WinByMode winByMode;
      String winnerId;
      if (game.playerTwoGame.moves.last.moveResult.bulls == 4) { //Bot found number
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
      await firestoreService.addFinalResultToVersusGame(
          gameReference: gameReference,
          winnerPlayer: winnerPlayer,
          winByMode: winByMode,
          winnerId: winnerId
      );
      refreshBotStats();
    } else {
      Get.find<VersusGameLogic>().showFinalResult = true;
    }
  }

  SoloGame generateBotGameScript(FourDigits newSecretNumber, List<SoloGame> games) {
    logger.i('called');
    List<int> newSecretDigits = newSecretNumber.toList();
    List<GameMove> newMoves = <GameMove>[];
    int index = Random().nextInt(games.length);
    SoloGame chosenGame = games[index];
    logger.i('Chosen game: ${chosenGame.toJson()}');
    //Refactor game to adapt it to secret number
    List<GameMove> originalMoves = List.from(chosenGame.moves);
    List<int> originalSecretDigits = List.from(chosenGame.secretNum!.toList());
    for (int i = 0; i < originalMoves.length; i++) {
      logger.i('checking move number: $i');
      List<int> originalGuessDigits = List.from(originalMoves[i].guess.toList());
      List<int> cowsAvailable = List.from(newSecretDigits);
      List<int> indexesAvailable = [0,1,2,3];
      List<int> newGuessDigits = <int>[0,0,0,0];
      List<int> aliensAvailable = <int>[0,1,2,3,4,5,6,7,8,9];
      aliensAvailable.removeWhere((element) => newSecretDigits.contains(element));
      logger.i('List of alien digits: $aliensAvailable');

      String thisOriginalGuess = originalMoves[i].guess.toString();
      int? duplicatePosition = isGuessDuplicated(thisOriginalGuess, originalMoves, i);
      if (duplicatePosition!= null) {
        logger.i('This guess is same as a previous one');
        newGuessDigits = newMoves[duplicatePosition].guess.toList();
        logger.i('Move transformed from: ${originalMoves[i].guess} to: $newGuessDigits');
        newMoves.add(originalMoves[i]);
        newMoves.last.guess = FourDigits.fromList(newGuessDigits);
        chosenGame.moves[i] = newMoves[i];
      } else {
        for (int j = 0; j < 4; j++) { //Loop to identify bulls
          if(isBull(originalGuessDigits[j], j, originalSecretDigits)) {
            newGuessDigits[j] = newSecretDigits[j];
            cowsAvailable.remove(newGuessDigits[j]);
            indexesAvailable.remove(j);
          }
        }
        logger.i('Bulls not assigned: ${indexesAvailable.length}');
        for (int j = 0; j < 4; j++) { //Loop to assign cows and aliens
          if (indexesAvailable.contains(j)) {
            if(isCow(originalGuessDigits[j], j, originalSecretDigits)) {
              logger.i('Original guess has a cow in position $j, cowsAvailable are: $cowsAvailable');
              int index = Random().nextInt(cowsAvailable.length);
              logger.i('cowsAvailable chosen: ${cowsAvailable[index]}, newSecretDigit being compared: ${newSecretDigits[j]}');
              if (cowsAvailable[index] == newSecretDigits[j]) { //Cannot use this as cow because it would become a Bull
                if(index > 0) {
                  logger.i('index was: $index');
                  index--;
                  logger.i('index is now: $index');
                } else {
                  index++;
                }
              }
              logger.i('index of cowsAvailable: $index');
              newGuessDigits[j] = cowsAvailable[index];
              cowsAvailable.removeAt(index);
            } else { //this digit is not bull nor cow
              logger.i('Original guess have alien in position: $j AliensAvailable: $aliensAvailable');
              int index = Random().nextInt(aliensAvailable.length);
              logger.i('index to aliensAvailable: $index');
              newGuessDigits[j] = aliensAvailable[index];
              aliensAvailable.removeAt(index);
            }
          }
        }
        logger.i('Move transformed from: ${originalMoves[i].guess} to: $newGuessDigits');
        newMoves.add(originalMoves[i]);
        newMoves.last.guess = FourDigits.fromList(newGuessDigits);
        chosenGame.moves[i] = newMoves[i];
      }
    }
    return chosenGame;
  }

  bool isBull(int digit, int index, List<int> secretDigits) {
    return (secretDigits[index] == digit) ? true : false;
  }

  bool isCow(int digit, int index, List<int> secretDigits) {
    bool isCow = false;
    for (int secretDigit in secretDigits) {
      if (digit == secretDigit && (index != secretDigits.indexOf(secretDigit))) {
        isCow = true;
      }
    }
    return isCow;
  }

  Future<void> refreshBotStats() async {
    logger.i('called');
    appController.needUpdateVsStats.value = true;
    Get.find<PlayerStatsController>().refreshBotStats(botPlayerDocId);
  }

  int? isGuessDuplicated(String guess, List<GameMove> moves, int lastIndex) {
    if (lastIndex == 0) return null;
    int? duplicateIndex;
    for (int k = 0; k < lastIndex; k++) {
      if (guess == moves[k].guess.toString()) {
        duplicateIndex = k;
      }
    }
    return duplicateIndex;
  }

}