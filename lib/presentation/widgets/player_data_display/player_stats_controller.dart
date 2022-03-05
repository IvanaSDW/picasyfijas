import 'package:bulls_n_cows_reloaded/data/models/player_solo_stats.dart';
import 'package:bulls_n_cows_reloaded/data/models/solo_game.dart';
import 'package:bulls_n_cows_reloaded/domain/players_use_cases.dart';
import 'package:bulls_n_cows_reloaded/domain/solo_games_use_cases.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:get/get.dart';


class PlayerStatsController extends GetxController {

  late List<SoloGame>? myMatches;
  final Rx<PlayerSoloStats?> _playerSoloStats = PlayerSoloStats.blank().obs;
  set playerSoloStats(PlayerSoloStats? stats) => _playerSoloStats.value = stats;
  PlayerSoloStats? get playerSoloStats => _playerSoloStats.value;

  final GetSoloGamesByIdUC _getSoloMatchesById = GetSoloGamesByIdUC();
  final UpdatePlayerAveragesUC _updatePlayerAverages = UpdatePlayerAveragesUC();
  final GetPlayerTimeRankUC _getPlayerTimeRank = GetPlayerTimeRankUC();
  final GetPlayerGuessesRankUC _getPlayerGuessesRank = GetPlayerGuessesRankUC();


  refreshStats(String playerId) async {
    logger.i(
        'called with needUpdate = ${appController.needUpdateSoloStats.value}');
    if (appController.needUpdateSoloStats.value) {
      double sumOfTime = 0;
      int sumOfGuesses = 0;
      var matches = await _getSoloMatchesById(playerId);
      logger.i('Matches found : ${matches.length}');
      int matchesQty = matches.length;
      double timeAverage = double.infinity;
      double guessesAverage = double.infinity;
      if (matchesQty > 0) {
        for (var match in matches) {
          sumOfTime += match.moves.last.timeStampMillis;
          sumOfGuesses += match.moves.length;
        }
        timeAverage = sumOfTime / matchesQty;
        guessesAverage = sumOfGuesses / matchesQty;
      }
      await _updatePlayerAverages(playerId, timeAverage, guessesAverage);

      int timeRank = await _getPlayerTimeRank(playerId);
      int guessesRank = await _getPlayerGuessesRank(playerId);

      playerSoloStats = PlayerSoloStats(matchesQty, timeAverage, guessesAverage, timeRank, guessesRank);
      appController.needUpdateSoloStats.value = false;
    }
  }


  @override
  void onInit() async {
    super.onInit();
    if (appController.needUpdateSoloStats.value) await refreshStats(auth.currentUser!.uid);
    ever(appController.needUpdateSoloStats, (value) async => await refreshStats(auth.currentUser!.uid));
  }

}
