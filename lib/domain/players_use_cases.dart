import 'package:bulls_n_cows_reloaded/data/repository/players_repository.dart';
import 'package:bulls_n_cows_reloaded/data/repository/players_repository_impl.dart';
import 'package:get/get.dart';

import '../data/models/player.dart';

class FetchPlayerByIdUC {
  final PlayersRepository _playersRepository = Get.put(PlayersRepositoryImpl());

  Future<Player?> call(String playerId) async {
    return await _playersRepository.fetchPlayer(playerId);
  }
}

class UpdatePlayerAveragesUC {
  final PlayersRepository _playersRepository = Get.put(PlayersRepositoryImpl());

  Future<void> call(String playerId, double timeAverage, double guessesAverage) async {
    _playersRepository.updatePlayerAverages(playerId, timeAverage, guessesAverage);
  }
}

class GetPlayerTimeRankUC {
  final PlayersRepository _playersRepository = Get.put(PlayersRepositoryImpl());
  Future<int> call(String playerId) async {
    return await _playersRepository.getPlayerTimeRank(playerId);
  }
}

class GetPlayerGuessesRankUC {
  final PlayersRepository _playersRepository = Get.put(PlayersRepositoryImpl());
  Future<int> call(String playerId) async {
    return await _playersRepository.getPlayerGuessesRank(playerId);
  }
}