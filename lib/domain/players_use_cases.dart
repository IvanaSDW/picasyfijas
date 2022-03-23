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
