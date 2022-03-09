import 'package:bulls_n_cows_reloaded/data/models/player_stats.dart';
import 'package:bulls_n_cows_reloaded/data/models/solo_game.dart';
import 'package:bulls_n_cows_reloaded/data/models/versus_game.dart';
import 'package:bulls_n_cows_reloaded/domain/solo_games_use_cases.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:get/get.dart';


class PlayerStatsController extends GetxController {

  late List<SoloGame>? myMatches;
  final Rx<PlayerStats> _playerStats = PlayerStats.blank().obs;
  set playerStats(PlayerStats stats) => _playerStats.value = stats;
  PlayerStats get playerStats => _playerStats.value;

  final GetSoloGamesByIdUC _getSoloMatchesById = GetSoloGamesByIdUC();
  // final GetPlayerTimeRankUC _getPlayerTimeRank = GetPlayerTimeRankUC();
  // final GetPlayerGuessesRankUC _getPlayerGuessesRank = GetPlayerGuessesRankUC();


  refreshStats(String playerId) async {
    logger.i(
        'called with needUpdateSolo = ${appController.needUpdateSoloStats.value}, and needUpdateVs = ${appController.needUpdateVsStats.value}');
    int soloGamesCount = 0;
    double timeAverage = double.infinity;
    double guessesAverage = double.infinity;
    int vsGamesCount = 0;
    double vsWinRate = double.infinity;
    int vsRank = 0;
    if (appController.needUpdateSoloStats.value) {
      double sumOfTime = 0;
      int sumOfGuesses = 0;
      var soloGames = await _getSoloMatchesById(playerId);
      logger.i('Games count found : ${soloGames.length}');
      soloGamesCount = soloGames.length;
      if (soloGamesCount > 0) {
        for (var game in soloGames) {
          sumOfTime += game.moves.last.timeStampMillis;
          sumOfGuesses += game.moves.length;
        }
        timeAverage = sumOfTime / soloGamesCount;
        guessesAverage = sumOfGuesses / soloGamesCount;
      }

      await firestoreService.updatePlayerSoloAverages(playerId, timeAverage, guessesAverage);

      // int timeRank = await _getPlayerTimeRank(playerId);
      // int guessesRank = await _getPlayerGuessesRank(playerId);
      // // int soloWorldRank = await firestoreService.getSoloWorldRank(playerId);
      Map<String, dynamic> soloRankings = await firestoreService.getSoloRankings(playerId);

      playerStats.soloGamesCount = soloGamesCount;
      playerStats.timeAverage = timeAverage;
      playerStats.guessesAverage = guessesAverage;
      playerStats.timeRank = soloRankings['timeRank'];
      playerStats.guessesRank = soloRankings['guessRank'];
      playerStats.soloWorldRank = soloRankings['worldRank'];

      _playerStats.update((val) { });
    }


    if (appController.needUpdateVsStats.value) {
      await getVsStats(playerId)
          .then((value) {
        vsGamesCount = value['vsGamesCount'];
        vsWinRate = value['vsWinRate'];
      });

      await firestoreService.updatePlayerVsRate(playerId, vsWinRate);
      vsRank = await firestoreService.getPlayerVsRank(playerId);
      playerStats.vsGamesCount = vsGamesCount;
      playerStats.vsWinRate = vsWinRate;
      playerStats.vsWorldRank = vsRank;
      _playerStats.update((val) { });
    }

    appController.needUpdateSoloStats.value = false;
    appController.needUpdateVsStats.value = false;
  }

  Future<Map<String, dynamic>> getVsStats(String playerId) async {
    logger.i(
        'called with needUpdate = ${appController.needUpdateVsStats.value}');
    List<VersusGame> wherePlayer1 = await firestoreService.getVsGamesWherePlayer1(playerId);
    List<VersusGame> wherePlayer2 = await firestoreService.getVsGamesWherePlayer2(playerId);
    List<VersusGame> vsGames = <VersusGame>[];
    vsGames.addAll(wherePlayer1);
    vsGames.addAll(wherePlayer2);
    logger.i('VS Games found : ${vsGames.length}');
    int vsGamesCount = vsGames.length;
    int vsGamesWon = 0;
    double vsWinRate = double.infinity;
    if (vsGamesCount > 0) {
      for (var game in vsGames) {
        if (game.winnerId == playerId) vsGamesWon ++;
      }
      vsWinRate = vsGamesWon / vsGamesCount;
    }
    return {'vsGamesCount' : vsGamesCount, 'vsWinRate' : vsWinRate};
  }

  @override
  void onInit() async {
    super.onInit();
    if (appController.needUpdateSoloStats.value || appController.needUpdateVsStats.value) await refreshStats(auth.currentUser!.uid);
    ever(appController.needUpdateSoloStats, (value) async => await refreshStats(auth.currentUser!.uid));
    ever(appController.needUpdateVsStats, (value) async => await refreshStats(auth.currentUser!.uid));
  }

}
