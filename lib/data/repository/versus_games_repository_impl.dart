import 'package:bulls_n_cows_reloaded/data/models/versus_game.dart';
import 'package:bulls_n_cows_reloaded/data/repository/versus_games_repository.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VersusGamesRepositoryImpl extends VersusGamesRepository {

  @override
  Future<DocumentReference<VersusGame>> createVersusGame(VersusGame game) async {
    return await firestoreService.addVersusGame(game);
  }
}