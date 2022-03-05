import 'package:bulls_n_cows_reloaded/data/models/solo_game.dart';
import 'package:bulls_n_cows_reloaded/data/repository/solo_games_repository.dart';

import '../../shared/constants.dart';

class SoloGamesRepositoryImpl extends SoloGamesRepository {

  @override
  Future<void> saveSoloGameToFirestore(SoloGame match) async {
    await firestoreService.addSoloGame(match);
  }

  @override
  Future<List<SoloGame>> getSoloGamesByPlayerId(String playerId) async {
    return await firestoreService.getSoloGamesByPlayerId(playerId);
  }

}