import 'dart:math';

import 'package:bulls_n_cows_reloaded/data/models/player_stats.dart';
import 'package:bulls_n_cows_reloaded/data/models/solo_game.dart';
import 'package:bulls_n_cows_reloaded/data/models/versus_game.dart';
import 'package:bulls_n_cows_reloaded/domain/solo_games_use_cases.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:get/get.dart';

import '../../../navigation/routes.dart';


class PlayerStatsController extends GetxController {

  late List<SoloGame>? myMatches;

  final RxBool _isSyncing = false.obs;
  set isSyncing(bool value) => _isSyncing.value = value;
  bool get isSyncing => _isSyncing.value;

  final Rx<PlayerStats> _playerStats = PlayerStats.blank().obs;
  set playerStats(PlayerStats stats) => _playerStats.value = stats;
  PlayerStats get playerStats => _playerStats.value;

  final GetSoloGamesByIdUC _getSoloMatchesById = GetSoloGamesByIdUC();


  Future<void> refreshStats(String playerId) async {
    int soloGamesCount = 0;
    double timeAverage = double.infinity;
    double guessesAverage = double.infinity;
    if (appController.needUpdateSoloStats.value) {
      isSyncing = true;
      double sumOfTime = 0;
      int sumOfGuesses = 0;
      var soloGames = await _getSoloMatchesById(playerId);
      soloGamesCount = soloGames.length;
      if (soloGamesCount > 0) {
        for (var game in soloGames) {
          sumOfTime += game.moves.last.timeStampMillis;
          sumOfGuesses += game.moves.length;
        }
        timeAverage = sumOfTime / soloGamesCount;
        guessesAverage = sumOfGuesses / soloGamesCount;
      }
      if (appController.currentPlayer.isVsUnlocked! || auth.currentUser!.uid != playerId) {
        await firestoreService.updatePlayerSoloAverages(playerId, timeAverage, guessesAverage, false);
      } else {
        if ((soloGamesCount >= minSoloGamesToUnlockVsMode) && (timeAverage <= maxTimeAverageToUnlockVsMode)) {
          await firestoreService.updatePlayerSoloAverages(playerId, timeAverage, guessesAverage, true);
          Get.toNamed(Routes.modeUnlocked);
        } else {
          await firestoreService.updatePlayerSoloAverages(playerId, timeAverage, guessesAverage, false);
        }
      }

      Map<String, dynamic> soloRankings = await firestoreService.getSoloRankings(playerId);

      playerStats.soloGamesCount = soloGamesCount;
      playerStats.timeAverage = timeAverage;
      playerStats.guessesAverage = guessesAverage;
      playerStats.timeRank = soloRankings['timeRank'];
      playerStats.guessesRank = soloRankings['guessRank'];
      playerStats.soloWorldRank = soloRankings['worldRank'];

      _playerStats.update((val) { });
      isSyncing = false;
    }


    if (appController.needUpdateVsStats.value) {
      isSyncing = true;
      await getVsStats(playerId)
          .then((value) {
        playerStats.vsGamesCount = value['vsGamesCount'];
        playerStats.vsGamesWon = value['vsGamesWon'];
        playerStats.vsGamesDraw = value['vsGamesDraw'];
        playerStats.vsGamesLost = value['vsGamesLost'];
        playerStats.vsWinRate = value['vsWinRate'];
        playerStats.rating = value['rating'];
        playerStats.isRated = value['isRated'];
      });
      await firestoreService.updatePlayerVsStats(
        playerId: playerId,
        winRate: playerStats.vsWinRate,
        rating: playerStats.rating,
        isRated: playerStats.isRated,
      );

      await firestoreService.getPlayerRatingRank(playerId).then((value) {
        playerStats.vsWorldRank = value['rank'];
        playerStats.vsPercentile = value['percentile'];
      });
      _playerStats.update((val) { });
      isSyncing = false;
    }
    appController.needUpdateSoloStats.value = false;
    appController.needUpdateVsStats.value = false;
    await appController.refreshPlayer();
  }

  Future<Map<String, dynamic>> getVsStats(String playerId) async {
    logger.i('called');
    int vsGamesCount = 0;
    int vsGamesWon = 0;
    int vsGamesDraw = 0;
    int vsGamesLost = 0;
    double vsWinRate = double.infinity;
    bool isRated = false;

    var whereIsP1Games = await firestoreService.getVsGamesWherePlayer1(playerId);
    whereIsP1Games.removeWhere((element) => element.winnerId == null);
    logger.i('P1 Games count: ${whereIsP1Games.length}');
    var whereIsP2Games = await firestoreService.getVsGamesWherePlayer2(playerId);
    whereIsP2Games.removeWhere((element) => element.winnerId == null);
    logger.i('P2 Games count: ${whereIsP2Games.length}');
    var allGames = <VersusGame>[];
    allGames.addAll(whereIsP1Games);
    allGames.addAll(whereIsP2Games);
    allGames.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    // var allGames = await firestoreService.getVsGamesByPlayerIdOrderedByAscDate(playerId);

    int rating = playerPresetRating;
    if (allGames.isNotEmpty) {  // Player has at least one vs game
      vsGamesCount = allGames.length;
      logger.i('Games count: $vsGamesCount');
      for (var game in allGames) {
        if (game.winnerId == 'draw') {
          vsGamesDraw ++;
        } else if (game.winnerId == playerId) {
          vsGamesWon ++;
        } else {
          vsGamesLost ++;
        }
      }
      logger.i('won: $vsGamesWon, draws: $vsGamesDraw, lost: $vsGamesLost');
      vsWinRate = vsGamesWon / vsGamesCount;
      if (vsGamesCount <= 5) { //Player is still in initial games phase, calculate initial rating
        rating = getInitialRating(playerId, allGames);
      } else { // Player is already rated, need to calculate full rating
        isRated = true;
        logger.i('Is rated..calculating full rating..');
        rating = getFullRating(playerId, allGames);
      }
    } else {
      //Player have not played yet in vs mode
    }

    return {
      'vsGamesCount' : vsGamesCount, 'vsGamesWon' : vsGamesWon,
      'vsGamesDraw' : vsGamesDraw, 'vsGamesLost' : vsGamesLost,
      'vsWinRate' : vsWinRate, 'rating': rating, 'isRated': isRated,
    };
  }

  int getInitialRating(String playerId, List<VersusGame> initialGames) {
    int sumOfOppRating = 0;
    double score = 0;
    for (var game in initialGames) {
      if(game.playerOneId == playerId) {
        sumOfOppRating += game.p2Rating;
      } else {
        sumOfOppRating += game.p1Rating;
      }
      logger.i('winner id: ${game.winnerId}');
      if (game.winnerId == 'draw') {
        score += 0.5;
      } else if (game.winnerId == playerId) {
        score += 1.0;
      }
      logger.i('sum of opp rating: $sumOfOppRating, score: $score');
    }
    int gameCount = initialGames.length;
    int kFactor = kFactorForInitialRating;
    int averageOppRating = sumOfOppRating ~/ gameCount;
    logger.i('Games count: $gameCount, Score: $score, Avg opp rating: $averageOppRating');
    double scoreDiff = score - gameCount*0.5;
    int initialRating = playerPresetRating;
    if (scoreDiff < 0) {
      double scorePercent = score / gameCount;
      int dp = ratingDpTable[scorePercent.toStringAsFixed(2)]!;
      initialRating = averageOppRating + dp;
    } else {
      initialRating = (averageOppRating + scoreDiff * kFactor).round();
    }
    return initialRating;
  }

  int getFullRating(String playerId, List<VersusGame> allGames) {
    var initialGames = <VersusGame>[];
    initialGames.addAll(allGames);
    initialGames.removeRange(minVsGamesToStartRating, allGames.length);
    logger.i('Initial games: ${initialGames.map((e) => e.toJson())}');
    int initialRating = getInitialRating(playerId, initialGames);
    logger.i('initial rating: $initialRating');
    int fullRating = initialRating;
    allGames.removeRange(0, minVsGamesToStartRating);
    logger.i('Games without initial: ${allGames.length}');
    for (var game in allGames) {
      double score = 0.0;
      int playerRating = 0;
      int oppRating = 0;
      if (game.playerOneId == playerId) {
        playerRating = game.p1Rating;
        oppRating = game.p2Rating;
      } else {
        playerRating = game.p2Rating;
        oppRating = game.p1Rating;
      }
      if (game.winnerId == 'draw') {
        score = 0.5;
      } else if (game.winnerId == playerId) {
        score = 1.0;
      }
      int ratingChange = getRatingChange(playerRating, oppRating, score);
      fullRating += ratingChange;
      logger.i('rating change: $ratingChange, new rating: $fullRating');
    }
    return fullRating;
  }

  int getRatingChange(int playerRating, int oppRating, double score) {
    int kFactor = playerRating < 2400 ? kFactorBelow2400 : kFactorAbove2400;
    logger.i('RatA: $playerRating, RatB: $oppRating, scoreA: $score, kFactor: $kFactor');
    int ratingDelta = oppRating - playerRating;
    double deltaRatio = ratingDelta / 400;
    double expectedScore = 1 / (1 + (pow(10, deltaRatio)));
    int ratingChange = (kFactor * (score - expectedScore)).round();
    return ratingChange;
  }

  Future<void> refreshBotStats(String botId) async {

    PlayerStats botStats = PlayerStats.blank();
    await getVsStats(botId)
        .then((value) {
      botStats.vsGamesCount = value['vsGamesCount'];
      botStats.vsGamesWon = value['vsGamesWon'];
      botStats.vsGamesDraw = value['vsGamesDraw'];
      botStats.vsGamesLost = value['vsGamesLost'];
      botStats.vsWinRate = value['vsWinRate'];
      botStats.rating = value['rating'];
      botStats.isRated = value['isRated'];
    });
    await firestoreService.updatePlayerVsStats(
      playerId: botId,
      winRate: botStats.vsWinRate,
      rating: botStats.rating,
      isRated: botStats.isRated,
    );

    await firestoreService.getPlayerRatingRank(botId).then((value) {
      botStats.vsWorldRank = value['rank'];
      botStats.vsPercentile = value['percentile'];
    });
  }

  @override
  void onInit() async {
    super.onInit();
    if (appController.needUpdateSoloStats.value ||
        appController.needUpdateVsStats.value) {
      await refreshStats(auth.currentUser!.uid);
    }
  }

}
