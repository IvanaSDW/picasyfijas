import 'package:bulls_n_cows_reloaded/data/models/solo_game.dart';
import 'package:bulls_n_cows_reloaded/data/repository/solo_games_repository_impl.dart';
import 'package:get/get.dart';

import '../data/repository/solo_games_repository.dart';

class SaveSoloGameToFirestoreUC {
  final SoloGamesRepository _soloGamesRepository = Get.put(SoloGamesRepositoryImpl());

  Future<void> call(SoloGame game) async {
    _soloGamesRepository.saveSoloGameToFirestore(game);
  }

}

class GetSoloGamesByIdUC {
  final SoloGamesRepository _soloMatchesRepository = Get.put(SoloGamesRepositoryImpl());

  Future<List<SoloGame>> call(String playerId) async {
    return _soloMatchesRepository.getSoloGamesByPlayerId(playerId);
  }

}