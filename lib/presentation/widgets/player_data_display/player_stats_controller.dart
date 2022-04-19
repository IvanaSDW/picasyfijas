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
    int sumOfOpsElo = 0;
    List<VersusGame> wherePlayer1 = await firestoreService.getVsGamesWherePlayer1(playerId);
    for (var game in wherePlayer1) {
      sumOfOpsElo += game.p2Rating;
    }
    List<VersusGame> wherePlayer2 = await firestoreService.getVsGamesWherePlayer2(playerId);
    for (var game in wherePlayer2) {
      sumOfOpsElo += game.p1Rating;
    }
    List<VersusGame> vsGames = <VersusGame>[];
    vsGames.addAll(wherePlayer1);
    vsGames.addAll(wherePlayer2);
    int vsGamesCount = vsGames.length;
    int vsGamesWon = 0;
    int vsGamesDraw = 0;
    int vsGamesLost = 0;
    int rating = playerPresetRating;
    double vsWinRate = double.infinity;
    bool isRated = false;
    if (vsGamesCount > 0) {
      for (var game in vsGames) {
        if (game.winnerId == playerId) {
          vsGamesWon ++;
        } else if (game.winnerPlayer == WinnerPlayer.draw) {
          vsGamesDraw ++;
        } else {
          vsGamesLost ++;
        }
      }
      vsWinRate = vsGamesWon / vsGamesCount;
      rating = (vsGamesWon*400 - vsGamesLost*400 + sumOfOpsElo) ~/ vsGamesCount;
      if (vsGamesCount >= 5) isRated = true;
    }
    return {
      'vsGamesCount' : vsGamesCount, 'vsGamesWon' : vsGamesWon,
      'vsGamesDraw' : vsGamesDraw, 'vsGamesLost' : vsGamesLost,
      'vsWinRate' : vsWinRate, 'rating': rating, 'isRated': isRated,
    };
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
