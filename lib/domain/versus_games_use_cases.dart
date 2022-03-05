import 'package:bulls_n_cows_reloaded/data/models/versus_game.dart';
import 'package:bulls_n_cows_reloaded/data/repository/versus_games_repository.dart';
import 'package:bulls_n_cows_reloaded/data/repository/versus_games_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateVersusGameUC {
  final VersusGamesRepository _repository = VersusGamesRepositoryImpl();

  Future<DocumentReference<VersusGame>> call(VersusGame game) async {
    return await _repository.createVersusGame(game);
  }

}