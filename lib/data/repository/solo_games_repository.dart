import '../models/solo_game.dart';

abstract class SoloGamesRepository {
  Future<void> saveSoloGameToFirestore(SoloGame match);

  Future<List<SoloGame>> getSoloGamesByPlayerId(String playerId);
}